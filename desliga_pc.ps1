# Desliga_PC.ps1

Clear-Host

function Obter-HorarioDesligamento {
    param (
        [string]$entrada
    )

    $dataAtual = Get-Date

    if ($entrada -match '^\d{1,2}:\d{2}h$') {
        $tempoStr = $entrada.TrimEnd('h')
        $partes = $tempoStr.Split(':')
        $horas = [int]$partes[0]
        $minutos = [int]$partes[1]
        return $dataAtual.AddHours($horas).AddMinutes($minutos)
    }
    elseif ($entrada -match '^\d{1,2}h$') {
        $horas = [int]$entrada.TrimEnd('h')
        return $dataAtual.AddHours($horas)
    }
    elseif ($entrada -match '^\d{1,2}:\d{2}$') {
        $partes = $entrada.Split(':')
        $hora = [int]$partes[0]
        $minuto = [int]$partes[1]

        if ($hora -ge 24 -or $minuto -ge 60) {
            return $null
        }

        $dataAlvo = Get-Date -Hour $hora -Minute $minuto -Second 0

        if ($dataAlvo -lt $dataAtual) {
            $dataAlvo = $dataAlvo.AddDays(1)
        }
        return $dataAlvo
    }
    else {
        return $null
    }
}

function Agendar-Desligamento {
    param (
        [datetime]$dataHora
    )

    $taskName = "Desliga_PC"

    if (Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue) {
        Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
    }

    $action = New-ScheduledTaskAction -Execute "shutdown.exe" -Argument "/s /t 0"
    $trigger = New-ScheduledTaskTrigger -Once -At $dataHora

    Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -User "$env:USERNAME" -RunLevel Highest -Force

    Write-Host "`Desligamento agendado com sucesso!" -ForegroundColor Green
    Write-Host "Data: $($dataHora.ToString("dd/MM/yyyy"))"
    Write-Host "Hora: $($dataHora.ToString("HH:mm"))"
    #Write-Host "`Para cancelar, execute:" -ForegroundColor Yellow
    #Write-Host "`nUnregister-ScheduledTask -TaskName 'Desliga_PC' -Confirm:`$false`n" -ForegroundColor Yellow
    Pause
}

# --- Execução Principal ---

Write-Host "====== AGENDADOR DE DESLIGAMENTO ======" -ForegroundColor Cyan
Write-Host "Informe o horário ou tempo restante para desligar o PC:"
Write-Host "- Ex: 23:45  → horário exato"
Write-Host "- Ex: 2h     → daqui 2 horas"
Write-Host "- Ex: 1:30h  → daqui 1 hora e 30 minutos"
Write-Host "- Digite 'cancelar' para remover tarefa já existente"
Write-Host "----------------------------------------"

do {
    $entrada = Read-Host "Digite o horário, duração ou 'cancelar'"

    if ($entrada.Trim().ToLower() -eq "cancelar") {
        if (Get-ScheduledTask -TaskName "Desliga_PC" -ErrorAction SilentlyContinue) {
            Unregister-ScheduledTask -TaskName "Desliga_PC" -Confirm:$false
            Write-Host "`Tarefa 'Desliga_PC' cancelada com sucesso!" -ForegroundColor Green
        } else {
            Write-Host "`Nenhuma tarefa 'Desliga_PC' encontrada para cancelar." -ForegroundColor Yellow
        }
        Pause
        exit
    }

    $dataHoraDesligamento = Obter-HorarioDesligamento -entrada $entrada

    if (-not $dataHoraDesligamento) {
        Write-Host "Entrada inválida. Tente novamente." -ForegroundColor Red
    }
} until ($dataHoraDesligamento)

# Confirmação do usuário
$dataFormatada = $dataHoraDesligamento.ToString("dd/MM/yyyy")
$horaFormatada = $dataHoraDesligamento.ToString("HH:mm")

Write-Host "`O PC será desligado em: $dataFormatada às $horaFormatada"
$confirmacao = Read-Host "Deseja agendar essa tarefa? (S/N)"

if ($confirmacao -match '^[sS]$') {
    Agendar-Desligamento -dataHora $dataHoraDesligamento
} else {
    Write-Host "`Agendamento cancelado." -ForegroundColor DarkYellow
    Pause
}
