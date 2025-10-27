# 🧰 PowerShell Automation Tools

Conjunto de **scripts PowerShell** desenvolvidos para **automatizar tarefas administrativas em ambiente corporativo Windows**, incluindo instalação de softwares, configuração de rede, agendamento de desligamento e pós-instalação de máquinas.

---

## 📦 Scripts incluídos

### 1. 🛜 `wifi_installv2.ps1`
Adiciona e conecta automaticamente uma estação de trabalho a uma rede Wi-Fi.

**Funções principais:**
- Solicita **SSID**, **usuário** e **senha** da rede.  
- Cria o perfil de conexão via `netsh wlan add profile`.  
- Executa um **delay configurável** e testa a conectividade.  
- Retorna sucesso ou falha na autenticação.

**Uso:**
```powershell
.\wifi_installv2.ps1
```

**Requisitos:**
- Executar como **Administrador**.  
- Interface Wi-Fi ativa e drivers atualizados.

---

### 2. 🖥️ `psremote_exe_all.ps1`
Executa a **instalação remota em massa** de aplicativos (.exe/.msi) via **PsExec** e habilita automaticamente o **PowerShell Remoting** nos hosts de destino.

**Funções principais:**
- Habilita o `PSRemoting` e o serviço `WinRM`.  
- Distribui e executa instaladores em múltiplas máquinas.  
- Suporta pacotes que aceitam o parâmetro **`/quiet`**.  
- Gera logs de sucesso e falha por host.

**Uso:**
```powershell
.\psremote_exe_all.ps1 -Path "C:\instaladores" -Computers "lista_hosts.txt"
```

**Requisitos:**
- Executar com **permissões administrativas de rede**.  
- Ter o **PsExec** instalado e no PATH do sistema.  
- O instalador deve ser compatível com `/quiet` ou `/silent`.

---

### 3. ⏱️ `desliga_pc.ps1`
Automatiza o **agendamento de desligamento** de um computador através do **Task Scheduler**, permitindo definir **horário fixo** ou **tempo decorrido**.

**Funções principais:**
- Cria tarefa no agendador (`schtasks.exe`).  
- Suporte a agendamento em minutos ou hora específica.  
- Cancela tarefas de desligamento previamente criadas.  
- Feedback visual e logs no console.

**Uso:**
```powershell
# Desliga após 30 minutos
.\desliga_pc.ps1 -Delay 30

# Desliga às 23:00
.\desliga_pc.ps1 -Hora "23:00"
```

**Requisitos:**
- Permissões administrativas locais.  
- Serviço do Agendador de Tarefas ativo.

---

### 4. ⚙️ `padrao_ho_2310.ps1`
Script de **pós-instalação corporativa** (HO padrão 23/10) que automatiza configurações essenciais de ambiente.

**Funções principais:**
- Instala e configura o **Kaspersky Endpoint**.  
- Instala o **Cisco AnyConnect VPN**.  
- Realiza **ingresso automático no domínio corporativo**.  
- Executa a **instalação completa e silenciosa do Protheus**.  
- Aplica parâmetros e políticas padrão do ambiente.

**Uso:**
```powershell
.\padrao_ho_2310.ps1
```

**Requisitos:**
- Conectividade com servidores internos de instalação.  
- Executar como Administrador.  
- Pacotes de instalação disponíveis nas rotas configuradas no script.

---

## 📋 Observações gerais

- Todos os scripts devem ser executados com **privilégios administrativos**.  
- Recomendado executar a partir de uma sessão **PowerShell 5.1+**.  
- Verifique caminhos de rede e dependências antes da execução.  

---

## 🧑‍💻 Autor
**Felipe Conceição Lula Lublanski (Felps)**  
💼 Técnico N1 em Infraestrutura e Automação de Processos  
📅 Outubro / 2025  

---

## 📜 Licença
Distribuído sob a licença **MIT** — uso livre para fins profissionais e educacionais.
