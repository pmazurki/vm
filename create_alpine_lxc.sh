#!/usr/bin/env bash

# Kolory dla wyjścia terminala
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
NC="\033[0m" # No Color

# Funkcje wyświetlania komunikatów
msg_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

msg_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

msg_info() {
    echo -e "${YELLOW}[INFO]${NC} $1"
}

# Sprawdzenie, czy skrypt jest uruchamiany jako root
check_root() {
    if [[ $(id -u) -ne 0 ]]; then
        msg_error "Skrypt musi być uruchomiony jako root."
        exit 1
    fi
}

# Tworzenie kontenera
create_container() {
    local CONTAINER_ID=$1
    local CONTAINER_NAME=$2
    local CONTAINER_TEMPLATE=$3

    msg_info "Tworzenie kontenera LXC z Alpine Linux..."
    pct create "$CONTAINER_ID" "$CONTAINER_TEMPLATE" --hostname "$CONTAINER_NAME" --memory 512 --net0 name=eth0,bridge=vmbr0,ip=dhcp

    if [[ $? -ne 0 ]]; then
        msg_error "Błąd podczas tworzenia kontenera LXC."
        exit 1
    fi

    msg_success "Kontener LXC z Alpine Linux utworzony pomyślnie."
}

# Uruchomienie kontenera
start_container() {
    local CONTAINER_ID=$1

    msg_info "Uruchamianie kontenera..."
    pct start "$CONTAINER_ID"

    if [[ $? -ne 0 ]]; then
        msg_error "Błąd podczas uruchamiania kontenera LXC."
        exit 1
    fi

    msg_success "Kontener LXC uruchomiony pomyślnie."
}

# Główna funkcja skryptu
main() {
    check_root

    # Parametry kontenera
    local CONTAINER_ID=107
    local CONTAINER_NAME="alpine-container"
    local CONTAINER_TEMPLATE="local:vztmpl/alpine-3.13-standard_3.13-1_amd64.tar.gz"

    create_container "$CONTAINER_ID" "$CONTAINER_NAME" "$CONTAINER_TEMPLATE"
    start_container "$CONTAINER_ID"

    # Tutaj możesz dodać dodatkowe konfiguracje
}

main
