# 🐾 Pet Locate

**Pet Locate** é um aplicativo web progressivo (PWA) criado para ajudar tutores a **cadastrar, localizar e proteger seus pets**.  
Através de **QR Codes personalizados**, o sistema permite que qualquer pessoa que encontrar o animal acesse instantaneamente suas informações e entre em contato com o tutor.

---

## 🚀 Demonstração

🔗 **Acesse o projeto:** [https://seuusuario.github.io/pet-locate/](https://seuusuario.github.io/pet-locate/)  
📱 Pode ser instalado como aplicativo em qualquer dispositivo (Android, iOS ou Desktop).

---

## 🧭 Sumário
- [Descrição](#-descrição)
- [Recursos Principais](#-recursos-principais)
- [Arquitetura do Projeto](#-arquitetura-do-projeto)
- [Tecnologias Utilizadas](#-tecnologias-utilizadas)
- [Instalação e Uso Local](#-instalação-e-uso-local)
- [Publicação no GitHub Pages](#-publicação-no-github-pages)
- [PWA e Service Worker](#-pwa-e-service-worker)
- [Capturas de Tela](#-capturas-de-tela)
- [Contribuição](#-contribuição)
- [Licença](#-licença)

---

## 🐶 Descrição

O **Pet Locate** foi desenvolvido com o objetivo de facilitar o **reencontro de animais perdidos**.  
Cada pet cadastrado gera um **QR Code único**, que direciona para uma **página pública** com seus dados básicos, foto e informações de contato do tutor.

Além disso, o tutor pode gerenciar múltiplos pets, tokens e histórico de localização em uma interface simples e moderna.

---

## ⚙️ Recursos Principais

✅ **Autenticação com Google** via Firebase  
✅ **Cadastro e edição de pets** com foto e dados do tutor  
✅ **Geração automática de QR Codes**  
✅ **Painel administrativo de tokens**  
✅ **Página pública do pet** com mapa e informações  
✅ **Interface responsiva e animada**  
✅ **Modo offline (PWA)** com cache inteligente  
✅ **Sistema de notificações toast** e modais de confirmação  
✅ **Design clean com gradientes suaves**

---

## 🧩 Arquitetura do Projeto

```bash
pet-locate/
│
├── index.html               # Tela de login e autenticação
├── dashboard.html           # Painel principal do tutor
├── add_edit_pet.html        # Formulário para cadastro/edição de pet
├── pet_locate.html          # Página pública (QR Code)
├── admin_tokens.html        # Painel administrativo de tokens
├── 404.html                 # Página de erro personalizada
│
├── manifest.json            # Configuração PWA
├── service-worker.js        # Cache e funcionamento offline
│
├── /images/                 # Ícones e logos
└── /scripts/                # (opcional) scripts JS separados
```

---

## 🧠 Tecnologias Utilizadas

| Tecnologia | Finalidade |
|-------------|------------|
| **HTML5 / CSS3 / JS** | Estrutura e estilo da aplicação |
| **Firebase (Auth & Firestore)** | Login e armazenamento de dados |
| **PWA (Manifest + Service Worker)** | Instalação e modo offline |
| **QRCode.js** | Geração de QR Codes para pets |
| **Google Maps Embed API** | Exibição do endereço do tutor |
| **Toast / Modal System** | Notificações e feedback ao usuário |

---

## 🧰 Instalação e Uso Local

```bash
# Clone o repositório
git clone https://github.com/seuusuario/pet-locate.git

# Acesse a pasta
cd pet-locate

# Abra o index.html no navegador
```

> 💡 Dica: use uma extensão como **Live Server (VSCode)** para testar as rotas internas e o PWA localmente.

---

## 🌍 Publicação no GitHub Pages

1. Vá em **Settings → Pages**
2. Selecione:
   - **Source:** `Deploy from branch`
   - **Branch:** `main`
   - **Folder:** `/ (root)`
3. Salve e acesse:
   ```
   https://seuusuario.github.io/pet-locate/
   ```

---

## ⚡ PWA e Service Worker

O app foi configurado para funcionar **offline**:
- `service-worker.js` gerencia o cache dos principais arquivos;
- `manifest.json` define ícones, cores e nome do app;
- É possível **instalar o Pet Locate** em dispositivos móveis e desktops.

---

## 🖼️ Capturas de Tela (opcional)

> *(adicione imagens aqui futuramente)*  
> - `index.html` — Tela de login  
> - `dashboard.html` — Painel de pets  
> - `pet_locate.html` — Página pública via QR  

---

## 🤝 Contribuição

1. Faça um fork do projeto  
2. Crie uma branch:
   ```bash
   git checkout -b feature/nome-da-sua-feature
   ```
3. Faça o commit das mudanças:
   ```bash
   git commit -m "Adiciona nova feature"
   ```
4. Envie a branch:
   ```bash
   git push origin feature/nome-da-sua-feature
   ```
5. Abra um **Pull Request**

---

## 📜 Licença

Este projeto está sob a licença **MIT**.  
Sinta-se livre para utilizar e aprimorar o código.  
Desenvolvido com 💜 por **Felipe Conceição Lula Lublanski (Felps)**.

---

## 🧾 Créditos

- Ícones: [Lucide Icons](https://lucide.dev)  
- QRCode.js: [David Shim](https://github.com/davidshimjs/qrcodejs)  
- PWA Base: Google Developers Docs  
- Firebase Hosting (opcional): [firebase.google.com](https://firebase.google.com)
