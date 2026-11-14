# 🚀 GenieACS Windows Setup & Installation Guide

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GenieACS](https://img.shields.io/badge/GenieACS-v1.2.x-blue.svg)](https://genieacs.com)
[![Platform](https://img.shields.io/badge/Platform-Windows%2010%20%7C%2011%20%7C%20Server-lightgrey.svg)]()
[![TR-069 / CWMP](https://img.shields.io/badge/Protocol-TR--069%20%2F%20CWMP-green.svg)]()

A complete, end-to-end guide and automation toolkit for installing, configuring, and running **GenieACS** natively on **Windows (10, 11, or Windows Server)** without requiring Linux, Docker, or WSL.

---

## 📑 Table of Contents
- [Overview](#-overview)
- [Architecture & Ports](#-architecture--ports)
- [Prerequisites](#-prerequisites)
- [Step-by-Step Installation](#-step-by-step-installation)
  - [1. Install Node.js](#1-install-nodejs)
  - [2. Install MongoDB](#2-install-mongodb)
  - [3. Install GenieACS](#3-install-genieacs)
  - [4. Configure Environment](#4-configure-environment)
- [Running GenieACS](#-running-genieacs)
  - [Option A: Interactive Launcher (Quick Start)](#option-a-interactive-launcher-quick-start)
  - [Option B: Windows Background Services (NSSM)](#option-b-windows-background-services-nssm-recommended)
- [Windows Firewall Setup](#-windows-firewall-setup)
- [Web UI Dashboard & Login](#-web-ui-dashboard--login)
- [Connecting ONTs / Routers (TR-069)](#-connecting-onts--routers-tr-069)
- [Troubleshooting & FAQs](#-troubleshooting--faqs)
- [Repository Structure](#-repository-structure)
- [License](#-license)

---

## 🔍 Overview

**GenieACS** is a high-performance, open-source TR-069 / CWMP (CPE WAN Management Protocol) Auto Configuration Server (ACS). It allows ISPs, network engineers, and lab testers to remotely provision, manage, monitor, and diagnose CPE devices such as:
- Fiber ONTs / ONUs (Nokia, Zyxel, Huawei, ZTE, Netlink, Syrotech, V-Sol)
- FTTH Home Gateways & Wi-Fi Routers
- Android TV Boxes / IPTV Set-Top Boxes (STBs)

While GenieACS is traditionally deployed on Linux, this repository provides everything needed to run it smoothly on **Windows**.

---

## 🏗️ Architecture & Ports

GenieACS is composed of four decoupled microservices communicating with a MongoDB database:

```
                  +--------------------------------+
                  |         MongoDB Server         |
                  |          (Port 27017)          |
                  +---------------+----------------+
                                  |
    +---------------+-------------+--------------+---------------+
    |               |                            |               |
+---v----+    +-----v----+                 +-----v----+    +-----v----+
|  CWMP  |    |   NBI    |                 |    FS    |    |    UI    |
| (7547) |    |  (7557)  |                 |  (7567)  |    |  (3000)  |
+---+----+    +----------+                 +----------+    +----+-----+
    |                                                           |
    | (TR-069 CWMP Protocol)                         (HTTP / Browser)
    v                                                           v
[ONT / Router / STB]                                    [Network Admin]
```

| Service | Port | Description |
|---|---|---|
| **genieacs-cwmp** | `7547` | TR-069 interface where CPEs (ONTs/Routers) connect. |
| **genieacs-nbi** | `7557` | Northbound Interface (REST API for 3rd-party integrations). |
| **genieacs-fs** | `7567` | File server for delivering firmware images & configuration backups. |
| **genieacs-ui** | `3000` | Web administration user interface. |

---

## 🛠️ Prerequisites

Download and install the following software before installing GenieACS:

### 1. Node.js (v18 or v20 LTS)
- Download from: [https://nodejs.org/](https://nodejs.org/)
- Recommended: **Node.js LTS (v18.x or v20.x 64-bit)**
- Verify installation in Command Prompt:
  ```cmd
  node -v
  npm -v
  ```

### 2. MongoDB Community Server
- Download from: [MongoDB Community Download Portal](https://www.mongodb.com/try/download/community)
- Version: **v6.x or v7.x (Windows x64 MSI)**
- Installation Instructions:
  1. Choose **Complete** installation setup.
  2. Select **"Run service as Network Service user"** (keeps MongoDB running automatically as a Windows service).
  3. (Optional) Check **Install MongoDB Compass** for graphical DB inspection.
- Verify MongoDB is running in CMD:
  ```cmd
  net start MongoDB
  ```

---

## 📦 Step-by-Step Installation

### 1. Install Node.js
Ensure Node.js and `npm` are in your Windows system PATH.

### 2. Install MongoDB
Verify connection to local MongoDB:
```cmd
mongosh "mongodb://127.0.0.1:27017"
```
*(If `mongosh` connects successfully, your database is ready!)*

### 3. Install GenieACS
Open **Command Prompt as Administrator** and run:
```cmd
npm install -g genieacs@1.2.9
```
*(Note: GenieACS 1.2.9 is widely tested and stable on Node.js on Windows).*

Check that the binaries were installed:
```cmd
genieacs-cwmp --version
```

### 4. Configure Environment
1. Create the base configuration directory:
   ```cmd
   mkdir C:\genieacs
   mkdir C:\genieacs\log
   mkdir C:\genieacs\ext
   ```
2. Copy `config/genieacs.env.example` from this repo to `C:\genieacs\genieacs.env`.
3. The content of `C:\genieacs\genieacs.env` should be:
   ```env
   GENIEACS_MONGODB_CONNECTION_URL=mongodb://127.0.0.1:27017/genieacs
   GENIEACS_CWMP_ACCESS_LOG_FILE=C:/genieacs/log/cwmp-access.log
   GENIEACS_NBI_ACCESS_LOG_FILE=C:/genieacs/log/nbi-access.log
   GENIEACS_FS_ACCESS_LOG_FILE=C:/genieacs/log/fs-access.log
   GENIEACS_UI_ACCESS_LOG_FILE=C:/genieacs/log/ui-access.log
   GENIEACS_DEBUG_FILE=C:/genieacs/log/debug.log
   GENIEACS_EXT_DIR=C:/genieacs/ext
   GENIEACS_UI_JWT_SECRET=super_secret_jwt_key_dc_voltage_2026_genieacs
   ```

---

## 🏃 Running GenieACS

### Option A: Interactive Launcher (Quick Start)
This method launches each service in its own console window for easy live log monitoring:

1. Double-click [`scripts/start-genieacs.bat`](scripts/start-genieacs.bat).
2. Four command windows will open:
   - `GenieACS CWMP [Port 7547]`
   - `GenieACS NBI [Port 7557]`
   - `GenieACS FS [Port 7567]`
   - `GenieACS UI [Port 3000]`
3. To stop all services, run [`scripts/stop-genieacs.bat`](scripts/stop-genieacs.bat).

---

### Option B: Windows Background Services (NSSM) [Recommended]
To run GenieACS 24/7 silently as background Windows Services that restart automatically upon system reboot:

1. Download **NSSM (Non-Sucking Service Manager)**: [https://nssm.cc/download](https://nssm.cc/download)
2. Extract `nssm.exe` from the `win64` folder into `C:\Windows\System32\`.
3. Right-click [`scripts/install-windows-services.bat`](scripts/install-windows-services.bat) and choose **"Run as administrator"**.
4. All four services (`genieacs-cwmp`, `genieacs-nbi`, `genieacs-fs`, `genieacs-ui`) will be registered and started.

> To remove the background services at any time, run [`scripts/uninstall-windows-services.bat`](scripts/uninstall-windows-services.bat) as Administrator.

---

## 🛡️ Windows Firewall Setup

In order for ONTs, routers, and other devices on your LAN/VLAN to reach GenieACS, Windows Firewall must permit inbound traffic on ports **7547**, **3000**, **7557**, and **7567**.

Run [`scripts/setup-firewall.bat`](scripts/setup-firewall.bat) as Administrator, or execute the following manually in CMD:

```cmd
netsh advfirewall firewall add rule name="GenieACS CWMP (7547)" dir=in action=allow protocol=TCP localport=7547
netsh advfirewall firewall add rule name="GenieACS Web UI (3000)" dir=in action=allow protocol=TCP localport=3000
netsh advfirewall firewall add rule name="GenieACS File Server (7567)" dir=in action=allow protocol=TCP localport=7567
netsh advfirewall firewall add rule name="GenieACS NBI API (7557)" dir=in action=allow protocol=TCP localport=7557
```

---

## 🖥️ Web UI Dashboard & Login

1. Open your browser and navigate to:
   ```
   http://localhost:3000
   ```
2. **Default Credentials**:
   - **Username:** `admin`
   - **Password:** `admin`
3. 🔒 **Important Security Note:** Change the default admin password immediately under **Admin > Users**.

---

## 📡 Connecting ONTs / Routers (TR-069)

To connect an ONT, router, or STB to GenieACS:

1. Determine your Windows host machine's IP address on the local network (e.g. `192.168.1.100` or `192.168.28.1`).
   ```cmd
   ipconfig
   ```
2. Log in to your ONT / Router web administration page (e.g., Nokia, Zyxel, Huawei, Netlink, Jio, Airtel).
3. Navigate to **Management > TR-069 / CWMP Configuration**.
4. Configure the following parameters:
   - **ACS URL:** `http://<YOUR_PC_IP>:7547/`  *(e.g., `http://192.168.1.100:7547/`)*
   - **ACS Username:** `(Leave blank or use your configured preset)`
   - **ACS Password:** `(Leave blank or use your configured preset)`
   - **Periodic Inform:** `Enabled`
   - **Periodic Inform Interval:** `60` or `300` (seconds)
   - **Connection Request Username:** `admin`
   - **Connection Request Password:** `admin`
5. Click **Apply / Save** and reboot the device or click "Send Inform".
6. Within a minute, your device will show up in the GenieACS Web Dashboard under **Devices**!

---

## ❓ Troubleshooting & FAQs

### 1. `MongoServerSelectionError: connect ECONNREFUSED 127.0.0.1:27017`
- **Cause:** MongoDB service is stopped.
- **Fix:** Press `Win + R`, type `services.msc`, locate `MongoDB Server`, right-click and click **Start**. Alternatively run `net start MongoDB` as Administrator.

### 2. Device is not appearing in the Dashboard
- **Fix 1:** Ensure Windows Defender Firewall is not blocking port `7547` (run `scripts/setup-firewall.bat`).
- **Fix 2:** Verify the ONT has route reachability to your PC IP (test by pinging the PC from the ONT diagnostic menu).
- **Fix 3:** Check the log file at `C:\genieacs\log\cwmp-access.log` to see incoming HTTP requests.

### 3. Port 3000 is already in use by another application
- **Fix:** Open `C:\genieacs\genieacs.env` and set `GENIEACS_UI_PORT=3001`, then restart the UI service and visit `http://localhost:3001`.

---

## 📂 Repository Structure

```text
genieacs-windows-setup/
├── README.md                           # Main documentation & complete guide
├── LICENSE                             # MIT License
├── .gitignore                          # Git ignore rules for logs & env
├── config/
│   └── genieacs.env.example            # Environment configuration template
└── scripts/
    ├── start-genieacs.bat              # Multi-window foreground service launcher
    ├── stop-genieacs.bat               # Clean process shutdown script
    ├── setup-firewall.bat              # One-click Windows Firewall rule setup
    ├── install-windows-services.bat    # Background service installer (NSSM)
    └── uninstall-windows-services.bat  # Background service uninstaller
```

---

## 📜 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

GenieACS is developed by Zaid Abdulla and is licensed under the **AGPL-3.0 License**.
