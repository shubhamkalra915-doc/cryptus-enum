# CRYPTUS.ENUM — Domain Reconnaissance & Security Intelligence Suite

```
  ██████╗██████╗ ██╗   ██╗██████╗ ████████╗██╗   ██╗███████╗
 ██╔════╝██╔══██╗╚██╗ ██╔╝██╔══██╗╚══██╔══╝██║   ██║██╔════╝
 ██║     ██████╔╝ ╚████╔╝ ██████╔╝   ██║   ██║   ██║███████╗
 ██║     ██╔══██╗  ╚██╔╝  ██╔═══╝    ██║   ██║   ██║╚════██║
 ╚██████╗██║  ██║   ██║   ██║        ██║   ╚██████╔╝███████║
  ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚═╝        ╚═╝    ╚═════╝ ╚══════╝
```

> **Automated OSINT, DNS Security Reconnaissance & Subdomain Assessment Engine**  
> A CLI-based security tool for passive and active domain intelligence gathering.

![Version](https://img.shields.io/badge/version-1.0.0-cyan?style=for-the-badge)
![Shell](https://img.shields.io/badge/shell-bash_4.0+-green?style=for-the-badge&logo=gnubash)
![Platform](https://img.shields.io/badge/platform-Linux%2FWSL-orange?style=for-the-badge&logo=linux)
![License](https://img.shields.io/badge/license-MIT-purple?style=for-the-badge)
![Security](https://img.shields.io/badge/security-authorized_testing_only-red?style=for-the-badge)

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Key Features](#-key-features)
- [Project Structure](#-project-structure)
- [Prerequisites & Dependencies](#️-prerequisites--dependencies)
- [Installation](#-installation)
- [Usage](#-usage)
- [Recon Modules](#-recon-modules)
- [Output & Report Format](#-output--report-format)
- [Security & Legal Disclaimer](#️-security--legal-disclaimer)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🔍 Overview

**CRYPTUS.ENUM** is a domain enumeration and security assessment tool designed for ethical hackers, penetration testers, and security researchers. It automates multi-stage passive and active reconnaissance — including DNS record enumeration, WHOIS lookups, subdomain discovery, typosquat analysis, SSL/TLS inspection, and HTTP security header auditing — into a single, structured workflow.

All results are saved into an automatically generated, timestamped report folder for offline review and record-keeping.

---

## ✨ Key Features

- **13 Automated Recon Modules** — Covers WHOIS, DNS records, subdomain enumeration, DNSSEC, zone transfer testing, SSL/TLS certificate parsing, HTTP security headers, redirect behaviour, and domain expiry.
- **High-Contrast CLI Output** — ANSI color-coded, formatted terminal output with section banners, status indicators, and dividers for readability.
- **Automated Dependency Resolution** — Self-checks required system tools on startup and auto-installs missing packages on `apt`-based systems.
- **Automatic Typosquat Analysis** — Automatically clones and integrates `urlcrazy` from GitHub for parallel domain threat detection.
- **Timestamped Report Folders** — Generates isolated report directories (`domain_report_<target>_<timestamp>/`) with individual plain-text log files for every module.

---

## 📁 Project Structure

```
enumtool/
└── enumerationtool/
    └── enumss.sh       # Main Bash enumeration script (single entry point)
```

The entire tool is a single self-contained Bash script. No additional configuration files, build steps, or runtimes are required beyond the system dependencies listed below.

---

## ⚙️ Prerequisites & Dependencies

### Operating System
- **Linux** (Kali Linux, Ubuntu, Debian recommended) or **Windows Subsystem for Linux (WSL2)**
- **Bash 4.0+** shell environment

### Required System Tools
The script automatically checks for — and installs if missing — the following packages at startup:

| Tool | Package | Purpose |
|------|---------|---------|
| `whois` | `whois` | Domain registrar and registration date lookup |
| `dnsmap` | `dnsmap` | Wordlist-based subdomain brute-force |
| `dnsrecon` | `dnsrecon` | Advanced DNS record enumeration |
| `dig` | `dnsutils` | DNS querying (A, AAAA, MX, CNAME, SOA, NS, DNSSEC) |
| `host` | `dnsutils` | Forward and reverse DNS resolution |
| `openssl` | `openssl` | SSL/TLS certificate inspection |
| `curl` | `curl` | HTTP/HTTPS header and status retrieval |
| `ruby` | `ruby` | Runtime for `urlcrazy` typosquat analysis |
| `git` | `git` | Cloning `urlcrazy` from GitHub |

> **Note**: `urlcrazy` is not a system package. The script automatically clones it from `https://github.com/urbanadventurer/urlcrazy.git` into `$HOME/urlcrazy` on first run.

---

## 📥 Installation

```bash
# 1. Clone this repository
git clone https://github.com/shubhamkalra915-doc/cryptus-enum.git
cd cryptus-enum

# 2. Grant execute permissions to the script
chmod +x enumtool/enumerationtool/enumss.sh
```

No build step, no `npm install`, and no Docker setup is required.

---

## 🚀 Usage

Run the script from the repository root, passing the target domain as the first argument:

```bash
./enumtool/enumerationtool/enumss.sh <target-domain>
```

### Examples

```bash
# Scan a domain
./enumtool/enumerationtool/enumss.sh example.com

# Protocol prefix is automatically stripped
./enumtool/enumerationtool/enumss.sh https://example.com
```

> 💡 **Tip**: If missing dependencies need to be auto-installed via `apt`, run with `sudo`:
> ```bash
> sudo ./enumtool/enumerationtool/enumss.sh example.com
> ```

### What happens on launch

1. **Banner** is displayed with tool name, version (`1.0.0`), and warning notice.
2. **Dependency check** — each required tool is verified; any missing ones are installed automatically.
3. **URLcrazy check** — if not already present, cloned from GitHub to `$HOME/urlcrazy`.
4. **Target validation** — exits with a usage message if no domain is provided.
5. **Report directory** — a timestamped folder (`domain_report_<target>_<YYYYMMDD_HHMMSS>/`) is created.
6. **13 recon modules** run sequentially, printing output to the terminal and saving results to individual files inside the report folder.
7. **Final summary** lists all generated report files.

---

## 🧪 Recon Modules

| # | Module | Core Tool | What It Does |
|---|--------|-----------|--------------|
| **01** | Domain Information | `dig` | Queries A, AAAA, MX, CNAME, and SOA DNS records |
| **02** | WHOIS Information | `whois` | Retrieves registrar, contact metadata, and registration dates |
| **03** | DNS Records | `dnsrecon` | Executes automated DNS enumeration and discovery |
| **04** | Subdomain Enumeration | `dnsmap` | Wordlist-based subdomain discovery |
| **05** | Typosquat Detection | `urlcrazy` | Detects typosquatting and brand-impersonation domain variants |
| **06** | Nameserver Records | `dig NS` | Identifies authoritative nameservers for the domain |
| **07** | Host DNS Resolution | `host` | Forward A record resolution + reverse PTR lookups on discovered IPs |
| **08** | DNSSEC Information | `dig` | Checks DNSKEY, DS records and DNSSEC trust chain |
| **09** | Zone Transfer Test | `dig AXFR` | Tests each nameserver for misconfigured AXFR zone transfers |
| **10** | SSL/TLS Certificate | `openssl` | Parses subject, SANs, issuer, validity period, serial, and fingerprint |
| **11** | HTTP Security Headers | `curl` | Audits HSTS, CSP, X-Frame-Options, X-Content-Type-Options, Referrer-Policy, Permissions-Policy, and CORS headers |
| **12** | HTTP Status & Redirect | `curl` | Captures response code, effective URL, remote IP, and total request time |
| **13** | Domain Expiration | `whois` | Extracts creation and expiry dates for compliance tracking |

---

## 📊 Output & Report Format

Each run creates a unique, timestamped directory in the current working directory:

```
domain_report_<target>_<YYYYMMDD_HHMMSS>/
├── domain_information.txt   # DNS A, AAAA, MX, CNAME, SOA records
├── whois.txt                # Full raw WHOIS output
├── dnsrecon.txt             # DNSrecon scan log
├── dnsmap.txt               # Discovered subdomains
├── urlcrazy.txt             # Typo domain threat list
├── nameservers.txt          # Authoritative nameservers
├── host_resolution.txt      # Forward and reverse DNS mappings
├── dnssec.txt               # DNSKEY and DS records
├── zone_transfer.txt        # AXFR attempt logs per nameserver
├── ssl_tls.txt              # SSL/TLS certificate breakdown
├── https_headers.txt        # Full HTTP/HTTPS response headers
├── http_status.txt          # Status code, effective URL, IP, duration
└── domain_expiration.txt    # Registration and expiry date summary
```

All files are plain text and can be opened with any text editor or imported into other analysis tools.

---

## ⚠️ Security & Legal Disclaimer

> **IMPORTANT**: **CRYPTUS.ENUM** is designed strictly for authorized security assessments, penetration testing, and defensive OSINT research.
>
> Running this tool against any target without **explicit, written permission** from the asset owner is illegal and unethical. The authors and contributors assume **no liability** for misuse or damages resulting from the use of this software.
>
> *Use only on domains you own or are authorized to assess.*

---

## 🤝 Contributing

Contributions are welcome. Please read [CONTRIBUTING.md](CONTRIBUTING.md) before submitting a pull request, and follow the [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) in all interactions.

---

## 📄 License

This project is licensed under the **MIT License**.

---

<p align="center">
  <b>CRYPTUS.ENUM</b> • Domain Reconnaissance & Security Intelligence Suite
</p>
