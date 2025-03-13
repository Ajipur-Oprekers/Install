#!/bin/bash

clear

# ✅ Definisi warna untuk output terminal
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}🚀 Starting InsideDropLabs Installer...${NC}"

# ✅ Step 1: Install Golang
echo -e "${YELLOW}➡️ Installing Golang...${NC}"
wget -q https://go.dev/dl/go1.22.0.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.22.0.linux-amd64.tar.gz
rm go1.22.0.linux-amd64.tar.gz

# ✅ Tambahkan Go ke PATH (Sementara + Permanen)
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
echo "export PATH=\$PATH:/usr/local/go/bin:\$HOME/go/bin" >> ~/.bashrc

# ✅ Verifikasi apakah Golang terdeteksi
if command -v go &> /dev/null; then
    echo -e "${GREEN}✅ Golang berhasil diinstall dan terdeteksi di PATH${NC}"
else
    echo -e "${RED}❌ Golang tidak terdeteksi di PATH! Coba jalankan 'source ~/.bashrc' secara manual.${NC}"
    exit 1
fi

# ✅ Step 2: Update System & Install Dependencies
echo -e "${YELLOW}➡️ Updating system and installing dependencies...${NC}"
sudo apt-get update -y
sudo apt-get install imagemagick -y
sudo apt-get install openssl -y
sudo apt-get install figlet -y

# ✅ Step 3: Clone Repository 0g-storage-client
echo -e "${YELLOW}➡️ Cloning 0g-storage-client...${NC}"
if [ -d "$HOME/0g-storage-client" ]; then
    echo -e "${RED}❌ Folder 0g-storage-client sudah ada. Menghapus...${NC}"
    rm -rf $HOME/0g-storage-client
fi
git clone -b v0.6.1 https://github.com/0glabs/0g-storage-client.git $HOME/0g-storage-client

# ✅ Step 4: Build Project
echo -e "${YELLOW}➡️ Building Go project...${NC}"
cd $HOME/0g-storage-client
git submodule update --init
go build
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Build berhasil!${NC}"
else
    echo -e "${RED}❌ Build gagal! Periksa kembali kode atau dependency.${NC}"
    exit 1
fi

# ✅ Step 5: Download Auto Upload Script
echo -e "${YELLOW}➡️ Downloading auto upload script...${NC}"
wget -q -O $HOME/0g-storage-client/auto_upload.sh https://raw.githubusercontent.com/Ajipur-Oprekers/auto_upload-OGLabs/main/auto_upload.sh

# ✅ Step 6: Tambahkan Permission + Jalankan Script
chmod +x $HOME/0g-storage-client/auto_upload.sh
echo -e "${GREEN}✅ Permission granted for auto_upload.sh${NC}"

# ✅ Step 7: Jalankan Auto Upload Script (Langsung)
echo -e "${GREEN}🚀 Running auto_upload.sh...${NC}"
cd $HOME/0g-storage-client
./auto_upload.sh

# ✅ Step 8: Selesai!
echo -e "${GREEN}🎉 Semua proses selesai dengan sukses! 🚀${NC}"
