#!/bin/bash

# === Kiloview Intercom Server Enhanced Installer ===
echo -e "\n\033[1;44m     🎧 Kiloview Intercom Server Installer Starting...     \033[0m\n"
sleep 1

# === Configuration ===
CONTAINER_NAME="KisServer"
IMAGE_TAG="kiloview/kis-image:1.10.0025"
DATA_DIR="/usr/local/bin/kis_db"

echo -e "\033[1;36m\nSelect an option:\033[0m"
echo -e "  1) Install Kiloview Intercom Server"
echo -e "  2) Uninstall any version of Kiloview Intercom Server\n"
read -rp "Enter choice [1-2]: " CHOICE

if [[ "$CHOICE" == "1" ]]; then
    echo -e "\n\033[1;36m=== Checking dependencies ===\033[0m"
    missing=""
    command -v curl >/dev/null 2>&1 || missing="$missing curl"
    if [ -n "$missing" ]; then
        echo "Installing: $missing"
        apt-get update -qq
        apt-get install -y $missing
    else
        echo "All dependencies satisfied."
    fi

    echo -e "\n\033[1;36m=== Checking Docker ===\033[0m"
    if ! command -v docker >/dev/null || ! docker version >/dev/null 2>&1; then
        echo "Installing Docker..."
        curl -fsSL https://get.docker.com | sh
        systemctl enable docker >/dev/null
        systemctl start docker
    else
        echo "Docker is already installed."
    fi

    echo -e "\033[1;36m\n=== Installing Kiloview Intercom Server ===\033[0m"
    docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1
    docker run --name="$CONTAINER_NAME" -idt --network host --privileged=true --restart=always \
        -v "$DATA_DIR":/usr/local/bin/kis/KisServer/db/ \
        -v /etc/localtime:/etc/localtime:ro \
        "$IMAGE_TAG" /usr/local/bin/kis/start.sh

    echo -e "\033[1;32m\n✅ Installation complete.\033[0m"

    echo -e "\n\033[1;44m 🎉 Installation Complete! \033[0m\n"
    IP=$(hostname -I | awk '{print $1}')
    echo -e "\033[1;37mYour Kiloview Intercom Server is now running.\033[0m"
    echo -e "\033[1;36mAccess the Web UI at: https://$IP:8443\033[0m"
    echo -e "\033[1;33mDefault credentials: \033[1;37madmin / admin\033[0m"
    echo -e "\033[1;37mAt first login, you will be required to set a new password.\033[0m"
    echo
    echo -e "\033[1;32m🎤  Start your intercom party line now!\033[0m"
    echo -e "\033[1;34m🔗  For firmware updates, visit:\033[0m https://www.kiloview.com/en/support/download/"
    echo -e "\033[1;34m📤  You can upload the latest .bin file directly from the Web UI.\033[0m"
    echo
    echo -e "\033[1;35mThank you for choosing Kiloview – Your AVoIP Trailblazer!\033[0m"

elif [[ "$CHOICE" == "2" ]]; then
    echo -e "\n\033[1;36m=== Uninstalling Kiloview Intercom Server ===\033[0m"
    docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 && echo "Container removed."
    docker rmi -f $(docker images "$IMAGE_TAG" -q) 2>/dev/null && echo "Image removed."
    rm -rf "$DATA_DIR" && echo "Data directory removed."
    echo -e "\033[1;32m\n✅ Cleanup complete.\033[0m"
else
    echo -e "\033[1;31mInvalid choice. Exiting.\033[0m"
    exit 1
fi
