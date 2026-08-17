# Contributing to CRYPTUS.ENUM

Thank you for your interest in contributing to **CRYPTUS.ENUM**! We welcome bug reports, feature suggestions, documentation improvements, and code contributions from the cybersecurity community.

---

## 📜 Code of Conduct

All contributors must adhere to our [Code of Conduct](CODE_OF_CONDUCT.md). Please maintain a professional, respectful, and inclusive environment in all interactions.

---

## 🚀 How to Contribute

### 1. Reporting Bugs

- Search existing [GitHub Issues](https://github.com/shubhamkalra915-doc/cryptus-enum/issues) to check the bug hasn't already been reported.
- If not, open a new issue and include:
  - Steps to reproduce the problem
  - Expected vs. actual behaviour
  - Your environment details (e.g., OS, Bash version, WSL2 build)
  - Relevant terminal output or error messages

### 2. Requesting Features

- Open a GitHub issue describing the proposed feature.
- Explain the security relevance or operational benefit clearly.

### 3. Submitting Code Changes

#### Workflow

1. **Fork** the repository and clone your fork locally.
2. Create a new topic branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. Make your changes to `enumtool/enumerationtool/enumss.sh`.
4. Verify the script has no syntax errors:
   ```bash
   bash -n enumtool/enumerationtool/enumss.sh
   ```
5. If `shellcheck` is available, run it for additional checks:
   ```bash
   shellcheck enumtool/enumerationtool/enumss.sh
   ```
6. Commit with a clear, descriptive message:
   ```bash
   git commit -m "feat(module): add SSL cipher suite audit to module 10"
   ```
7. Push your branch and open a **Pull Request** against the `main` branch.

---

## 🛠️ Code Standards & Guidelines

### Shell Script (`enumtool/enumerationtool/enumss.sh`)

- Written for **Bash 4.0+**.
- Use upper-case names for environment-level constants and lower-case for local variables.
- Always wrap variable expansions in double quotes (`"$VARIABLE"`) to prevent word splitting and glob expansion.
- Use the existing helper functions for terminal output — `section_header`, `info`, `success`, `warn`, `fail` — rather than raw `echo` calls.
- Clean up any temporary files or background processes gracefully.
- Do not add dependencies beyond those already managed by the script's `install_package` function without discussion.

---

## 🔒 Security Vulnerabilities

Please **do not** open public GitHub issues for security vulnerabilities. Report them privately by contacting the project maintainer directly via GitHub.

---

Thank you for helping make CRYPTUS.ENUM a reliable and well-maintained recon tool!
