# sol-crm

## 💻 Development Environment Setup & Troubleshooting (Windows 11 + WSL2)

To ensure an enterprise-grade production parity, this project is built entirely inside a Linux kernel abstraction layer within Windows 11 using **WSL2 (Windows Subsystem for Linux)**. This eliminates file-system permission conflicts (`\` vs `/`) and avoids performance degradation typical of native Windows environments when running Node.js and Docker architectures.

### 🛠️ Core Tech Stack & Tooling Rationale

| Tool | Role | Advantage |
| :--- | :--- | :--- |
| **WSL2 (Ubuntu)** | Operating System Layer | Real Linux kernel execution, preventing native OS compatibility bugs. |
| **fnm (Fast Node Manager)** | Node.js Version Control | Built in Rust, extremely fast, manages isolated workspace runtimes seamlessly. |
| **Node.js v22 (LTS)** | Runtime Environment | Active LTS providing features like native `node:sqlite` needed by modern bundle managers. |
| **pnpm** | Package Management | Uses hard links and content-addressable storage to minimize disk space and optimize installs. |

---

### ⚠️ Common Environment Edge Cases & Resolution Ledger

During the bootstrap phase on Windows/WSL2 environments, the following technical edge cases were identified and solved:

#### 1. Missing Archiving Utilities (`unzip`)
* **Symptom:** The `fnm` rust installation script aborts with a `Checking availability of unzip... Missing!` error flag.
* **Root Cause:** Fresh vanilla Ubuntu images on WSL2 lack standard decompression binaries needed to unpack Node platform-specific builds.
* **Resolution:** Install the dependencies directly via the Advanced Package Tool (APT):
  ```bash
  sudo apt update && sudo apt install -y unzip

  ### 🚀 Development Environment Automation via Shell Script (`setup-env.sh`)

To accelerate developer onboarding and guarantee that the entire engineering team builds software under the exact same runtime versions, this repository includes an automated Bash setup script that configures 100% of the Linux/WSL2 environment with a single command.

#### Automated Procedures Executed by the Script:
1. **Scope Validation:** Prevents incorrect or unsafe execution directly via `sudo`.
2. **Package Synchronization:** Sychronizes and upgrades system operating packages via `APT`.
3. **Core Dependencies Provisioning:** Installs native toolchains and compilation utilities (`curl`, `git`, `build-essential`, `unzip`).
4. **FNM Installation:** Configures **FNM (Fast Node Manager)** and injects persistent environment variables into the shell profile.
5. **Runtime Abstraction:** Installs and locks the global environment into **Node.js v22 (LTS)**.
6. **Package Manager Locking:** Enables **Corepack** and provisions the latest stable release of **pnpm**.

#### How to Execute the Automation:

From your **Ubuntu (WSL2)** terminal, navigate to the repository root where the script is located (`scripts/setup-env.sh`) and execute the following commands sequence:

```bash
# 1. Grant execution permissions to the script file
chmod +x scripts/setup-env.sh

# 2. Run the automation script
./scripts/setup-env.sh

# 3. CRITICAL: Reload your active shell session to apply the newly injected environment variables
source ~/.bashrc