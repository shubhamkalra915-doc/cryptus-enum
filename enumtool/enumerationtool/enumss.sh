#!/bin/bash

# =========================================================
# DOMAIN ENUMERATION & SECURITY INFORMATION SCRIPT
# =========================================================
#
# Usage:
#   ./enum.sh example.com
#
# Tools:
#   whois
#   dnsmap
#   dnsrecon
#   dig
#   host
#   openssl
#   curl
#   ruby
#   git
#
# Use only on domains you own or are authorized to assess.
# =========================================================


# ---------------------------------------------------------
# COLORS & STYLES
# ---------------------------------------------------------

CYAN='\033[0;36m'
BOLD='\033[1m'
MAGENTA='\033[0;35m'
RED_B='\033[1;31m'
YELLOW_B='\033[1;33m'
RESET='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
WHITE='\033[1;37m'
DIM='\033[2m'
NC='\033[0m'

BRIGHT_CYAN='\033[1;36m'
BRIGHT_GREEN='\033[1;32m'
BRIGHT_MAGENTA='\033[1;35m'
BRIGHT_BLUE='\033[1;34m'
ORANGE='\033[38;5;214m'
GREY='\033[38;5;245m'


# ---------------------------------------------------------
# HELPER FUNCTIONS
# ---------------------------------------------------------

# Print a full-width double-line section header
section_header() {
    local num="$1"
    local title="$2"
    echo ""
    echo -e "${BRIGHT_MAGENTA}╔══════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${BRIGHT_MAGENTA}║${RESET}  ${BRIGHT_CYAN}${BOLD}[${num}]${RESET}  ${WHITE}${BOLD}${title}${RESET}"
    echo -e "${BRIGHT_MAGENTA}╚══════════════════════════════════════════════════════════╝${RESET}"
    echo ""
}

# Thin divider
thin_div() {
    echo -e "${GREY}  ────────────────────────────────────────────────────────${RESET}"
}

# Status messages
info()    { echo -e "  ${BRIGHT_CYAN}[•]${RESET} ${WHITE}$*${RESET}"; }
success() { echo -e "  ${BRIGHT_GREEN}[✔]${RESET} ${GREEN}$*${RESET}"; }
warn()    { echo -e "  ${YELLOW_B}[!]${RESET} ${YELLOW}$*${RESET}"; }
fail()    { echo -e "  ${RED_B}[✘]${RESET} ${RED}$*${RESET}"; }
ip_div()  {
    echo ""
    echo -e "  ${BRIGHT_BLUE}┌─────────────────────────────────────────┐${RESET}"
    echo -e "  ${BRIGHT_BLUE}│${RESET}  ${ORANGE}IP Address:${RESET} ${WHITE}$1${RESET}"
    echo -e "  ${BRIGHT_BLUE}└─────────────────────────────────────────┘${RESET}"
}
ns_div()  {
    echo ""
    echo -e "  ${BRIGHT_MAGENTA}┌─────────────────────────────────────────┐${RESET}"
    echo -e "  ${BRIGHT_MAGENTA}│${RESET}  ${ORANGE}Nameserver:${RESET} ${WHITE}$1${RESET}"
    echo -e "  ${BRIGHT_MAGENTA}└─────────────────────────────────────────┘${RESET}"
}


# ---------------------------------------------------------
# BANNER
# ---------------------------------------------------------

clear

echo ""
echo -e "${CYAN}${BOLD}"
echo "  ██████╗██████╗ ██╗   ██╗██████╗ ████████╗██╗   ██╗███████╗"
echo " ██╔════╝██╔══██╗╚██╗ ██╔╝██╔══██╗╚══██╔══╝██║   ██║██╔════╝"
echo " ██║     ██████╔╝ ╚████╔╝ ██████╔╝   ██║   ██║   ██║███████╗"
echo " ██║     ██╔══██╗  ╚██╔╝  ██╔═══╝    ██║   ██║   ██║╚════██║"
echo " ╚██████╗██║  ██║   ██║   ██║        ██║   ╚██████╔╝███████║"
echo "  ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚═╝        ╚═╝    ╚═════╝ ╚══════╝"
echo -e "${RESET}"
echo -e "${YELLOW_B}              ·  E N U M  ·  T O O L  ·${RESET}"
echo -e "${MAGENTA}        ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo -e "${RED_B}          [ Domain Enumeration & Recon Suite ]${RESET}"
echo -e "${MAGENTA}        ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""
echo -e "  ${CYAN}Tool    :${RESET} CRYPTUS.ENUM"
echo -e "  ${CYAN}Version :${RESET} 1.0.0"
echo -e "  ${CYAN}Warning :${RESET} Use only on domains you own or are authorized to test."
echo ""
echo -e "${MAGENTA}        ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""
sleep 1


# ---------------------------------------------------------
# SUDO CHECK
# ---------------------------------------------------------

if [ "$EUID" -eq 0 ]; then
    SUDO=""
else
    SUDO="sudo"
fi


# ---------------------------------------------------------
# DEPENDENCY INSTALLATION FUNCTION
# ---------------------------------------------------------

install_package() {

    COMMAND=$1
    PACKAGE=$2

    if command -v "$COMMAND" > /dev/null 2>&1; then

        success "$COMMAND is already installed."

    else

        warn "$COMMAND is missing."
        info "Installing $PACKAGE..."

        $SUDO apt-get update -qq
        $SUDO apt-get install -y "$PACKAGE"

        if command -v "$COMMAND" > /dev/null 2>&1; then
            success "$COMMAND installed successfully."
        else
            fail "Failed to install $COMMAND."
        fi

    fi
}


# ---------------------------------------------------------
# DEPENDENCY CHECK
# ---------------------------------------------------------

echo ""
echo -e "${BRIGHT_CYAN}${BOLD}╔══════════════════════════════════════════════════════════╗${RESET}"
echo -e "${BRIGHT_CYAN}${BOLD}║              ⚙  DEPENDENCY CHECK                        ║${RESET}"
echo -e "${BRIGHT_CYAN}${BOLD}╚══════════════════════════════════════════════════════════╝${RESET}"
echo ""

install_package whois whois
install_package dnsmap dnsmap
install_package dnsrecon dnsrecon
install_package dig dnsutils
install_package host dnsutils
install_package openssl openssl
install_package curl curl
install_package ruby ruby
install_package git git

echo ""


# ---------------------------------------------------------
# URLCRAZY CHECK
# ---------------------------------------------------------

echo -e "${BRIGHT_CYAN}${BOLD}╔══════════════════════════════════════════════════════════╗${RESET}"
echo -e "${BRIGHT_CYAN}${BOLD}║              🔗  URLCRAZY CHECK                          ║${RESET}"
echo -e "${BRIGHT_CYAN}${BOLD}╚══════════════════════════════════════════════════════════╝${RESET}"
echo ""

URLCRAZY_DIR="$HOME/urlcrazy"
URLCRAZY_SCRIPT="$URLCRAZY_DIR/urlcrazy.rb"

if [ -f "$URLCRAZY_SCRIPT" ]; then

    success "urlcrazy is already installed."

else

    warn "urlcrazy is not installed."
    info "Downloading urlcrazy..."

    if git clone https://github.com/urbanadventurer/urlcrazy.git "$URLCRAZY_DIR"; then

        if [ -f "$URLCRAZY_SCRIPT" ]; then
            success "urlcrazy installed successfully."
        else
            fail "urlcrazy installation failed."
        fi

    else

        fail "Could not download urlcrazy."

    fi

fi

echo ""


# ---------------------------------------------------------
# TARGET CHECK
# ---------------------------------------------------------

TARGET=$1

if [ -z "$TARGET" ]; then

    echo ""
    echo -e "${RED_B}╔══════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${RED_B}║  ✘  No target domain specified.                          ║${RESET}"
    echo -e "${RED_B}╚══════════════════════════════════════════════════════════╝${RESET}"
    echo ""
    echo -e "  ${WHITE}Usage:${RESET}"
    echo -e "  ${YELLOW}  ./enum.sh example.com${RESET}"
    echo ""
    exit 1

fi


# Remove HTTP/HTTPS if supplied

TARGET=$(echo "$TARGET" | sed 's~https\?://~~' | sed 's~/.*~~')


# ---------------------------------------------------------
# REPORT DIRECTORY
# ---------------------------------------------------------

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

REPORT_DIR="domain_report_${TARGET}_${TIMESTAMP}"

mkdir -p "$REPORT_DIR"


# ---------------------------------------------------------
# START REPORT
# ---------------------------------------------------------

echo ""
echo -e "${BRIGHT_GREEN}${BOLD}╔══════════════════════════════════════════════════════════╗${RESET}"
echo -e "${BRIGHT_GREEN}${BOLD}║       🎯  DOMAIN ENUMERATION & SECURITY REPORT           ║${RESET}"
echo -e "${BRIGHT_GREEN}${BOLD}╠══════════════════════════════════════════════════════════╣${RESET}"
echo -e "${BRIGHT_GREEN}${BOLD}║${RESET}  ${ORANGE}Target  :${RESET}  ${WHITE}${TARGET}${RESET}"
echo -e "${BRIGHT_GREEN}${BOLD}║${RESET}  ${ORANGE}Report  :${RESET}  ${WHITE}${REPORT_DIR}${RESET}"
echo -e "${BRIGHT_GREEN}${BOLD}║${RESET}  ${ORANGE}Started :${RESET}  ${WHITE}$(date)${RESET}"
echo -e "${BRIGHT_GREEN}${BOLD}╚══════════════════════════════════════════════════════════╝${RESET}"
echo ""


# ---------------------------------------------------------
# 1. DOMAIN INFORMATION
# ---------------------------------------------------------

section_header "01" "DOMAIN INFORMATION"

{
    echo "Target Domain: $TARGET"
    echo "Collection Time: $(date)"
    echo ""

    echo "A Records:"
    dig A "$TARGET" +short

    echo ""
    echo "AAAA Records:"
    dig AAAA "$TARGET" +short

    echo ""
    echo "MX Records:"
    dig MX "$TARGET" +short

    echo ""
    echo "CNAME Records:"
    dig CNAME "$TARGET" +short

    echo ""
    echo "SOA Record:"
    dig SOA "$TARGET" +short

} | tee "$REPORT_DIR/domain_information.txt"

echo ""


# ---------------------------------------------------------
# 2. WHOIS INFORMATION
# ---------------------------------------------------------

section_header "02" "WHOIS INFORMATION"

whois "$TARGET" | tee "$REPORT_DIR/whois.txt"

echo ""


# ---------------------------------------------------------
# 3. DNS RECORDS - DNSRECON
# ---------------------------------------------------------

section_header "03" "DNS RECORDS — DNSRECON"

dnsrecon -d "$TARGET" | tee "$REPORT_DIR/dnsrecon.txt"

echo ""


# ---------------------------------------------------------
# 4. SUBDOMAIN ENUMERATION - DNSMAP
# ---------------------------------------------------------

section_header "04" "SUBDOMAIN ENUMERATION — DNSMAP"

dnsmap "$TARGET" | tee "$REPORT_DIR/dnsmap.txt"

echo ""


# ---------------------------------------------------------
# 5. PARALLEL / TYPO DOMAINS - URLCRAZY
# ---------------------------------------------------------

section_header "05" "PARALLEL / TYPO DOMAINS — URLCRAZY"

if [ -f "$URLCRAZY_SCRIPT" ]; then

    ruby "$URLCRAZY_SCRIPT" -p "$TARGET" \
        | tee "$REPORT_DIR/urlcrazy.txt"

else

    warn "urlcrazy is not available."

fi

echo ""


# ---------------------------------------------------------
# 6. NAMESERVER INFORMATION - DIG
# ---------------------------------------------------------

section_header "06" "NAMESERVER INFORMATION — DIG"

NS_SERVERS=$(dig NS "$TARGET" +short)

if [ -z "$NS_SERVERS" ]; then

    warn "No nameservers found."

else

    echo "$NS_SERVERS"

fi

echo "$NS_SERVERS" > "$REPORT_DIR/nameservers.txt"

echo ""


# ---------------------------------------------------------
# 7. HOST DNS RESOLUTION
# ---------------------------------------------------------

section_header "07" "HOST DNS RESOLUTION"

info "Running host against target..."
echo ""

host "$TARGET" | tee "$REPORT_DIR/host_resolution.txt"

echo ""

info "Reverse DNS information where available:"
echo ""

IP_ADDRESSES=$(dig A "$TARGET" +short)

for IP in $IP_ADDRESSES
do

    ip_div "$IP"
    host "$IP"

done

echo ""


# ---------------------------------------------------------
# 8. DNSSEC INFORMATION
# ---------------------------------------------------------

section_header "08" "DNSSEC INFORMATION"

{

    echo "DNSKEY Records:"
    dig DNSKEY "$TARGET" +short

    echo ""
    echo "DS Records:"
    dig DS "$TARGET" +short

    echo ""
    echo "DNSSEC Query:"
    dig "$TARGET" +dnssec

} | tee "$REPORT_DIR/dnssec.txt"

echo ""


# ---------------------------------------------------------
# 9. DNS ZONE TRANSFER TEST
# ---------------------------------------------------------

section_header "09" "DNS ZONE TRANSFER TEST"

if [ -z "$NS_SERVERS" ]; then

    warn "No nameservers available."

else

    for NS in $NS_SERVERS
    do

        ns_div "$NS"
        info "Testing nameserver: $NS"
        echo ""
        dig AXFR "$TARGET" @"$NS"
        echo ""

    done

fi


# Save zone-transfer results

{

    for NS in $NS_SERVERS
    do

        echo "=============================================="
        echo "Nameserver: $NS"
        echo "=============================================="

        dig AXFR "$TARGET" @"$NS"

        echo ""

    done

} > "$REPORT_DIR/zone_transfer.txt"

echo ""


# ---------------------------------------------------------
# 10. SSL/TLS CERTIFICATE INFORMATION
# ---------------------------------------------------------

section_header "10" "SSL/TLS CERTIFICATE INFORMATION"

info "Checking SSL/TLS certificate..."
echo ""

echo | openssl s_client \
    -connect "$TARGET:443" \
    -servername "$TARGET" \
    2>/dev/null \
    | openssl x509 \
        -noout \
        -subject \
        -issuer \
        -serial \
        -dates \
        -fingerprint \
        -ext subjectAltName \
    | tee "$REPORT_DIR/ssl_tls.txt"

echo ""


# ---------------------------------------------------------
# 11. HTTP SECURITY HEADERS
# ---------------------------------------------------------

section_header "11" "HTTP SECURITY HEADERS"

info "Checking HTTPS headers..."
echo ""

curl -k -I -L \
    --max-time 15 \
    "https://$TARGET" \
    | tee "$REPORT_DIR/https_headers.txt"

echo ""

thin_div
echo -e "  ${ORANGE}${BOLD}Selected Security Headers${RESET}"
thin_div

curl -k -s -I -L \
    --max-time 15 \
    "https://$TARGET" \
    | grep -Ei \
    'Strict-Transport-Security|Content-Security-Policy|X-Frame-Options|X-Content-Type-Options|Referrer-Policy|Permissions-Policy|Cross-Origin-Opener-Policy|Cross-Origin-Resource-Policy'

echo ""


# ---------------------------------------------------------
# 12. HTTP STATUS & REDIRECT INFORMATION
# ---------------------------------------------------------

section_header "12" "HTTP STATUS & REDIRECT INFORMATION"

curl -k -s -o /dev/null \
    -w "HTTP Status : %{http_code}\nFinal URL   : %{url_effective}\nRemote IP   : %{remote_ip}\nTotal Time  : %{time_total}s\n" \
    --max-time 15 \
    -L "https://$TARGET" \
    | tee "$REPORT_DIR/http_status.txt"

echo ""


# ---------------------------------------------------------
# 13. DOMAIN EXPIRATION INFORMATION
# ---------------------------------------------------------

section_header "13" "DOMAIN EXPIRATION INFORMATION"

whois "$TARGET" \
    | grep -Ei \
    'Creation Date|Created|Registration Time|Registered On|Expiry Date|Expiration Date|Registry Expiry Date|Registrar Registration Expiration Date' \
    | tee "$REPORT_DIR/domain_expiration.txt"

echo ""


# ---------------------------------------------------------
# FINAL SUMMARY
# ---------------------------------------------------------

echo ""
echo -e "${BRIGHT_GREEN}${BOLD}╔══════════════════════════════════════════════════════════╗${RESET}"
echo -e "${BRIGHT_GREEN}${BOLD}║            ✅  ENUMERATION COMPLETE                      ║${RESET}"
echo -e "${BRIGHT_GREEN}${BOLD}╠══════════════════════════════════════════════════════════╣${RESET}"
echo -e "${BRIGHT_GREEN}${BOLD}║${RESET}  ${ORANGE}Target    :${RESET}  ${WHITE}${TARGET}${RESET}"
echo -e "${BRIGHT_GREEN}${BOLD}║${RESET}  ${ORANGE}Completed :${RESET}  ${WHITE}$(date)${RESET}"
echo -e "${BRIGHT_GREEN}${BOLD}╠══════════════════════════════════════════════════════════╣${RESET}"
echo -e "${BRIGHT_GREEN}${BOLD}║${RESET}  ${CYAN}Reports saved in:${RESET}  ${WHITE}${REPORT_DIR}${RESET}"
echo -e "${BRIGHT_GREEN}${BOLD}║${RESET}"
echo -e "${BRIGHT_GREEN}${BOLD}║${RESET}  ${CYAN}Files generated:${RESET}"
echo -e "${BRIGHT_GREEN}${BOLD}║${RESET}"

for f in $(ls -1 "$REPORT_DIR"); do
    echo -e "${BRIGHT_GREEN}${BOLD}║${RESET}    ${GREY}▸${RESET}  ${WHITE}${f}${RESET}"
done

echo -e "${BRIGHT_GREEN}${BOLD}╚══════════════════════════════════════════════════════════╝${RESET}"
echo ""
