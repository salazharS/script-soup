#
#
#
#--------------------------------------------------------------------------------------------------------------------------------------------------
#
# O script habilita o psremote no computador alvo pelo psexec, solicita uma autentificação de usuario 
# e dados como IP e o caminho da pasta. A pasta já possui a partição e o coringa para todos os .exe, C:\$pasta\*.exe
# 
#--------------------------------------------------------------------------------------------------------------------------------------------------
#
#
#
#
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
    Start-Process pwsh7.exe -ArgumentList ('-NoProfile -ExecutionPolicy Bypass -File "{0}"' -f $myinvocation.MyCommand.Definition) -Verb RunAs
    exit #substituia pelo nome arquivo ps que utiliza 
}
Enable-PSRemoting -Force
$domain = Read-Host "Digite o dominio"
Write-Host "Dominio em uso: $domain"
$user = Read-Host "Digite o usuario"
$pass = Read-Host "Coloque sua senha" -AsSecureString
$user_domain = "$domain\$user"
$ip = Read-Host "Digite o endereço IP"
$credenciais = New-Object System.Management.Automation.PSCredential ($user_domain, $pass)
psexec \\$ip -u $user_domain -p $pass -s powershell.exe "Enable-PSRemoting -Force"
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "$ip" -Concatenate -Force
Start-Process explorer.exe -ArgumentList "\\$($ip)\c$\"
$pasta = Read-Host "Digite o caminho da pasta"
$pasta = Read-Host "Digite o caminho da pasta"
Invoke-Command -ComputerName $ip -ScriptBlock {
    param($pasta)
    Get-ChildItem -Path "C:\$pasta\*.exe" -Filter *.exe | ForEach-Object {
        try {
            $process = Start-Process -FilePath $_.FullName -ArgumentList '/silent' -Wait -PassThru
            if ($process.ExitCode -ne 0) {
                throw "O instalador retornou o código de saída $($process.ExitCode)."
            }
            "$($_.Name) instalado com sucesso com PID $($process.Id)" | Out-File -FilePath "C:\log_install.txt" -Append
        } catch {
            "Erro ao instalar $($_.Name): $_" | Out-File -FilePath "C:\ERRO_install.txt" -Append
        }
    }
    Get-ChildItem -Path "C:\$pasta\*.msi" -Filter *.msi | ForEach-Object {
        try {
            $process = Start-Process -FilePath 'msiexec.exe' -ArgumentList "/i", $_.FullName, "/quiet", "/norestart" -Wait -NoNewWindow -PassThru
            if ($process.ExitCode -ne 0) {
                throw "O instalador .msi retornou o código de saída $($process.ExitCode)."
            }
            "$($_.Name) .msi instalado com sucesso" | Out-File -FilePath "C:\log_install.txt" -Append
        } catch {
            "Erro ao instalar $($_.Name) .msi: $_" | Out-File -FilePath "C:\ERRO_install.txt" -Append
        }
    }
    "Instalação completa de arquivos .exe e .msi" | Out-File -FilePath "C:\complete_install.txt" -Append
} -ArgumentList $pasta -Credential $credenciais
psexec \\${ip} -u $domain\$user -p $passdecode -s powershell.exe "Disable-PSRemoting" -Force
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "" -Force
Disable-PSRemoting -Force
