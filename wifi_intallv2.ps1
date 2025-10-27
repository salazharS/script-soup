#habilita scripts
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser

# Solicita ao usuário para fornecer SSID e se a rede é oculta
$ssid = Read-Host "Insira o SSID da rede Wi-Fi"
$passwordSecure = Read-Host "Insira a senha da rede Wi-Fi" -AsSecureString
$isNetworkHidden = Read-Host "A rede é oculta? (Digite 'true' para Sim ou 'false' para Não)"

# Converte a senha de SecureString para texto comum
$password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($passwordSecure))

# Valida e converte a entrada para um valor booleano
$isNetworkHidden = if ($isNetworkHidden -eq 'true') {$true} else {$false}

# Converte o SSID para o formato hexadecimal
$HexArray = $ssid.ToCharArray() | foreach-object { [System.String]::Format("{0:X}", [System.Convert]::ToUInt32($_)) }
$HexSSID = $HexArray -join ""

$nonBroadcast = if ($isNetworkHidden) {"<nonBroadcast>true</nonBroadcast>"} else {""}

# Cria o perfil WLAN
$guid = New-Guid
$wlanProfileXml = @"
<?xml version="1.0"?>
<WLANProfile xmlns="http://www.microsoft.com/networking/WLAN/profile/v1">
    <name>$ssid</name>
    <SSIDConfig>
        <SSID>
            <hex>$HexSSID</hex>
            <name>$ssid</name>
        </SSID>
        $nonBroadcast
    </SSIDConfig>
    <connectionType>ESS</connectionType>
    <connectionMode>auto</connectionMode>
    <MSM>
        <security>
            <authEncryption>
                <authentication>WPA2PSK</authentication>
                <encryption>AES</encryption>
                <useOneX>false</useOneX>
            </authEncryption>
            <sharedKey>
                <keyType>passPhrase</keyType>
                <protected>false</protected>
                <keyMaterial>$password</keyMaterial>
            </sharedKey>
        </security>
    </MSM>
    <MacRandomization xmlns="http://www.microsoft.com/networking/WLAN/profile/v3">
        <enableRandomization>false</enableRandomization>
        <randomizationSeed>1451755948</randomizationSeed>
    </MacRandomization>
</WLANProfile>
"@

# Salva o perfil WLAN em um arquivo temporário
$profilePath = "$($ENV:TEMP)\$guid.SSID"
$wlanProfileXml | Out-File $profilePath

# Adiciona o perfil WLAN
netsh wlan add profile filename=$profilePath user=all

# Tentativa de conexão - Tenta se conectar várias vezes
$maxTentativas = 5
$contadorTentativas = 0
$connected = $false

while ($contadorTentativas -lt $maxTentativas -and -not $connected) {
    $contadorTentativas++
    Write-Host "Tentativa de conexão #$contadorTentativas..."
    netsh wlan connect name=$ssid
    Start-Sleep -Seconds 5

    # Verifica se a conexão foi bem-sucedida
    $status = netsh wlan show interfaces
    if ($status -like "*Estado*autenticado*") {
        $connected = $true
        Write-Host "Conectado à rede $ssid com sucesso."
    } else {
        Write-Host "Falha na conexão. Tentando novamente..."
    }
}

# Renova o endereço IP
ipconfig /release
Start-Sleep -Seconds 5
ipconfig /renew

# Limpeza: remove o perfil WLAN temporário
Remove-Item $profilePath -Force

# Bloqueia scripts terceiros
Set-ExecutionPolicy -ExecutionPolicy Restricted -Scope CurrentUser
