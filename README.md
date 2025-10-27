# Documentação Técnica — Scripts PowerShell (.ps1)

> **Resumo:** Esta documentação descreve o propósito, uso, parâmetros, pré-requisitos e boas práticas para os três scripts PowerShell que você enviou: `wifi_installv2.ps1`, `psremote_exe_all.ps1` e `desliga_pc.ps1`.

---

## Índice

1. Visão geral
2. Convenções deste repositório
3. `wifi_installv2.ps1`
4. `psremote_exe_all.ps1`
5. `desliga_pc.ps1`
6. Estrutura sugerida do repositório
7. Como publicar no GitHub (passos rápidos)
8. Histórico de alterações
9. Contato / Notas finais

---

## 1. Visão geral

Este documento serve como referência técnica para operadores e administradores que irão usar os scripts. Cada seção dedica‑se a explicar em linguagem técnica e direta como executar e integrar cada `.ps1` em fluxos de trabalho de automação de infraestrutura.

---

## 2. Convenções deste repositório

- Nomes de scripts: `kebab_case` ou `snake_case` conforme já enviados.
- Logs: todos os scripts devem gravar saída para um arquivo `.log` no mesmo diretório `%~dp0\logs`.
- Execução: sempre rodar com PowerShell 5.1+ (ou PowerShell Core 7+ quando compatível). Quando necessário, executar como administrador.
- Safety-first: incluir `-WhatIf` ou modos de teste nas ações destrutivas; recomenda‑se testar em VM antes de rodar em produção.

---

## 3. `wifi_installv2.ps1`

### Objetivo
Adiciona uma rede Wi‑Fi em uma máquina local, solicitando nome de usuário (SSID) e senha; após um delay, valida a conectividade com a nova rede.

### Pré‑requisitos
- Execução local (não requer domínio).
- Permissão de administrador para alterar configurações de interface wireless (em geral não é obrigatório, mas depende da GPO local).
- Adaptadores wireless compatíveis e drivers instalados.

### Parâmetros sugeridos
- `-SSID` (string) — nome da rede.
- `-Password` (string) — senha da rede (secure string recomendado).
- `-DelaySeconds` (int, default: 10) — tempo para aguardar antes de validar conexão.
- `-InterfaceAlias` (string, optional) — alias da interface wireless quando houver múltiplas.
- `-TestHost` (string, default: 8.8.8.8) — host para validar conectividade via `Test-Connection`.
- `-LogPath` (string, default: .\logs\wifi_installv2.log)
- `-WhatIf` (switch) — executar em modo de teste (se o script suportar).

### Exemplo de execução

```powershell
.\wifi_installv2.ps1 -SSID "MinhaRede" -Password "Senha1234!" -DelaySeconds 15
```

### Fluxo e comportamento esperado
1. Valida parâmetros obrigatórios.
2. Cria perfil wireless e tenta conectar.
3. Aguarda `DelaySeconds` e valida conectividade.
4. Registra resultado em `LogPath`.

---

## 4. `psremote_exe_all.ps1`

### Objetivo
Utiliza `PsExec` para habilitar PSRemoting nos hosts remotos e iniciar uma instalação em massa de arquivos `.exe`/`.msi`.

### Pré‑requisitos
- PsExec (Sysinternals) no PATH.
- Credenciais com permissão administrativa.
- Firewall e WinRM configurados.

### Parâmetros sugeridos
- `-TargetsFile` — arquivo com lista de hosts.
- `-InstallerPath` — caminho do instalador (.exe/.msi).
- `-InstallerArgs` — argumentos passados ao instalador.
- `-TimeoutSeconds` — tempo máximo por host.
- `-Parallelism` — quantidade de hosts simultâneos.
- `-LogPath` — arquivo de log.

### Exemplo

```powershell
.\psremote_exe_all.ps1 -TargetsFile .\hosts.txt -InstallerPath "\\srv\instaladores\app.msi" -InstallerArgs "/qn /norestart"
```

### Fluxo esperado
1. Valida lista e acesso ao instalador.
2. Usa PsExec para habilitar PSRemoting e executar o instalador.
3. Gera log por host com código de retorno e status.

---

## 5. `desliga_pc.ps1`

### Objetivo
Agenda o desligamento do computador via Task Scheduler, permitindo agendamento por tempo decorrido ou horário específico.

### Pré‑requisitos
- Permissão local para criar tarefas agendadas.
- PowerShell 5.1+.

### Parâmetros sugeridos
- `-When` — tempo relativo ou horário exato.
- `-Action` — comando de desligamento (default `shutdown /s /t 0`).
- `-TaskName` — nome da tarefa.
- `-Force` — substitui tarefa existente.

### Exemplo

```powershell
.\desliga_pc.ps1 -When "in:30m"
.\desliga_pc.ps1 -When "at:23:00" -TaskName "DesligaNoite"
```

---

## 6. Estrutura sugerida do repositório

```
/ps-scripts
├─ README.md
├─ scripts/
│  ├─ wifi_installv2.ps1
│  ├─ psremote_exe_all.ps1
│  └─ desliga_pc.ps1
├─ logs/
└─ tools/
   └─ psexec.exe
```

---

## 7. Como publicar no GitHub

1. `git init`
2. `git add .`
3. `git commit -m "Adiciona scripts PowerShell e documentação"`
4. Criar repositório no GitHub e rodar `git push -u origin main`

---

## 8. Histórico de alterações

- v1.0 — Documento inicial com descrição e exemplos (Felps)

---

## 9. Contato / Notas finais

Este README destina-se a documentação técnica interna e portfólio público no GitHub.
