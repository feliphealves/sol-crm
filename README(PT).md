## 💻 Configuração do Ambiente de Desenvolvimento e Resolução de Problemas (Windows 11 + WSL2)

Para garantir paridade estrita com o ambiente de produção em nuvem, este projeto é executado inteiramente dentro de uma camada de abstração do kernel Linux no Windows 11 usando o **WSL2 (Windows Subsystem for Linux)**. Isso elimina conflitos crônicos de permissão de sistema de arquivos (`\` vs `/`) e evita a perda de performance típica de ambientes Windows nativos ao rodar arquiteturas baseadas em Node.js e Docker.

### 🛠️ Justificativa Técnica da Stack de Ferramentas Core

| Ferramenta | Papel / Função | Vantagem Competitiva |
| :--- | :--- | :--- |
| **WSL2 (Ubuntu)** | Camada de Sistema Operacional | Execução real do kernel Linux, prevenindo bugs de compatibilidade entre sistemas. |
| **fnm (Fast Node Manager)** | Controle de Versão do Node.js | Desenvolvido em Rust, extremamente rápido, gerencia runtimes isolados sem overhead. |
| **Node.js v22 (LTS)** | Ambiente de Execução (Runtime) | LTS ativa que traz recursos nativos como o `node:sqlite`, exigido por gerenciadores modernos. |
| **pnpm** | Gerenciamento de Pacotes | Utiliza links físicos (hard links) e armazenamento indexado por conteúdo para otimizar espaço e instalações. |

---

### ⚠️ Histórico de Resolução de Problemas no Ambiente (Windows/WSL2)

Durante a fase de inicialização do ambiente, os seguintes cenários de erro foram identificados, mapeados e corrigidos:

#### 1. Ausência de Utilitários de Descompactação (`unzip`)
* **Sintoma:** O script de instalação do `fnm` via terminal aborta com a mensagem `Checking availability of unzip... Missing!`.
* **Causa Raiz:** Imagens limpas do Ubuntu instaladas via WSL2 não trazem por padrão binários de descompactação necessários para extrair os pacotes do Node do servidor.
* **Resolução:** Instalar as dependências ausentes diretamente via gerenciador de pacotes APT:
  ```bash
  sudo apt update && sudo apt install -y unzip

### 🚀 Automação do Setup com Shell Script (`setup-env.sh`)

Para acelerar o processo de integração (onboarding) e garantir que todo o time desenvolva exatamente sob as mesmas versões de runtime, este repositório inclui um script de automação Bash que configura 100% do ambiente Linux/WSL2 com um único comando.

#### O que o script faz de forma automatizada:
1. Valida o escopo de execução (impede rodar incorretamente via `sudo` direto).
2. Sincroniza e atualiza os repositórios do sistema operacional via `APT`.
3. Instala dependências nativas e utilitários de compilação essenciais (`curl`, `git`, `build-essential`, `unzip`).
4. Instala e configura o **FNM (Fast Node Manager)** injetando as variáveis no ambiente de forma persistente.
5. Provisiona e define o **Node.js v22 (LTS)** como ambiente de execução padrão global.
6. Ativa o **Corepack** e configura a versão estável mais recente do **pnpm**.

#### Como Executar a Automação:

A partir do terminal do seu **Ubuntu (WSL2)**, navegue até a pasta onde deseja salvar o script (ou use o arquivo já presente no repositório em `scripts/setup-env.sh`) e execute os comandos abaixo:

```bash
# 1. Conceda permissão de execução ao arquivo do script
chmod +x scripts/setup-env.sh

# 2. Execute o script de automação
./scripts/setup-env.sh

# 3. CRÍTICO: Recarregue seu terminal atual para aplicar as novas variáveis de ambiente
source ~/.bashrc