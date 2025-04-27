#!/bin/sh

# === CONFIGURATION ===
DOWNLOAD_URL="https://www.kiloview.com/downloads/Firmware/Kiloview-Intercom-Server-Pro/kiloview_kis_image_1.10.0025.tar"
DOWNLOAD_DIR="/tmp/kis"
TAR_FILE="$DOWNLOAD_DIR/kiloview_kis_image_1.10.0025.tar"
EXTRACTION_DIR="$DOWNLOAD_DIR/kiloview-kis-1.10.0025"
IMAGE_TAR="kiloview_kis_image_1.10.0025.tar"
CONTAINER_NAME="KisServer"
IMAGE_TAG="kiloview/kis-image:1.10.0025"

# --- 1) Install missing Debian packages in one shot ---
missing=""
command -v curl >/dev/null 2>&1 || missing="$missing curl"

if [ -n "$missing" ]; then
  echo "Installing missing packages:$missing"
  apt-get update -qq
  apt-get install -y $missing
else
  echo "All required Debian packages already installed."
fi

# --- 2) Install Docker if missing or broken ---
echo "Checking Docker..."
if command -v docker >/dev/null 2>&1 && docker version >/dev/null 2>&1; then
  echo "Docker already installed and working."
else
  echo "Docker not found or not functional. Installing..."
  curl -fsSL https://get.docker.com | sh
  systemctl enable docker >/dev/null 2>&1
  systemctl start docker
fi

# --- 3) Download & extract the KIS archive ---
echo "Preparing download directory..."
rm -rf "$DOWNLOAD_DIR"
mkdir -p "$DOWNLOAD_DIR"

echo "Downloading Kiloview Intercom Server package..."
curl -fSL "$DOWNLOAD_URL" -o "$TAR_FILE" || { echo "ERROR: download failed"; exit 1; }

# Nessuna estrazione necessaria: l'immagine è direttamente il tar Docker

# --- 4) Load the Docker image ---
IMAGE_PATH="$TAR_FILE"
if [ ! -f "$IMAGE_PATH" ]; then
  echo "ERROR: image tar not found at $IMAGE_PATH"; exit 1
fi

echo "Loading Docker image..."
docker load -i "$IMAGE_PATH" || { echo "ERROR: docker load failed"; exit 1; }

# --- 5) Remove any existing container ---
if docker ps -a --format '{{.Names}}' | grep -qx "$CONTAINER_NAME"; then
  echo "Removing existing container $CONTAINER_NAME..."
  docker rm -f "$CONTAINER_NAME"
fi

# --- 6) Run the new container ---
echo "Starting container $CONTAINER_NAME..."
docker run -d \
  --name="$CONTAINER_NAME" \
  --network host \
  --privileged=true \
  --restart=always \
  -v /usr/local/bin/kis_db/:/usr/local/bin/kis/KisServer/db/ \
  -v /etc/localtime:/etc/localtime:ro \
  "$IMAGE_TAG" \
  /usr/local/bin/kis/start.sh || { echo "ERROR: failed to start container"; exit 1; }

# --- 7) Cleanup ---
echo "Cleaning up temporary files..."
rm -rf "$DOWNLOAD_DIR"

echo "Done! ✅"
