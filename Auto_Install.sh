#!/bin/bash

clear

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}🚀 Starting InsideDropLabs Installer...${NC}"

# ✅ Step 1: Install Go
echo -e "${YELLOW}➡️ Installing Golang...${NC}"
wget -q https://go.dev/dl/go1.22.0.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.22.0.linux-amd64.tar.gz
rm go1.22.0.linux-amd64.tar.gz

# ✅ Tambahkan Go ke PATH
echo "export PATH=\$PATH:/usr/local/go/bin:\$HOME/go/bin" >> ~/.bashrc
source ~/.bashrc

# ✅ Cek apakah `go` sudah bisa diakses
if ! command -v go &> /dev/null; then
    echo -e "${RED}❌ Golang tidak terdeteksi di PATH!${NC}"
    exit 1
fi

# ✅ Step 2: Update System & Install Dependencies
echo -e "${YELLOW}➡️ Updating system and installing dependencies...${NC}"
sudo apt-get update -y
sudo apt-get install imagemagick -y
sudo apt-get install openssl -y
sudo apt-get install figlet -y

# ✅ Step 3: Clone 0g-storage-client
if [ -d "$HOME/0g-storage-client" ]; then
    echo -e "${RED}⚠️ Directory '0g-storage-client' already exists. Removing...${NC}"
    rm -rf "$HOME/0g-storage-client"
fi

echo -e "${YELLOW}➡️ Cloning 0g-storage-client...${NC}"
git clone -b v0.6.1 https://github.com/0glabs/0g-storage-client.git
cd $HOME/0g-storage-client
git submodule update --init

# ✅ Tunggu build selesai sebelum lanjut
echo -e "${YELLOW}➡️ Building project...${NC}"
go build
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Build gagal!${NC}"
    exit 1
fi

# ✅ Step 4: Download Auto Upload Script
echo -e "${YELLOW}➡️ Downloading auto upload script...${NC}"
wget -q -O auto_upload.sh https://raw.githubusercontent.com/Ajipur-Oprekers/auto_upload-OGLabs/main/auto_upload.sh

# ✅ Fix format ke LF (hindari ^M)
sed -i 's/\r$//' auto_upload.sh

# ✅ Step 5: Tambahkan Permission + Jalankan Script
chmod +x auto_upload.sh
echo -e "${GREEN}✅ Permission granted for auto_upload.sh${NC}"

# ✅ Step 6: Jalankan Script Otomatis (pakai `exec` supaya dieksekusi di environment aktif)
echo -e "${GREEN}🚀 Running auto_upload.sh...${NC}"
exec ./auto_upload.sh
