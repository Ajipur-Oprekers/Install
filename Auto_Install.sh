#!/bin/bash

clear

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

# ✅ Tambahkan Go ke PATH
echo "export PATH=\$PATH:/usr/local/go/bin:\$HOME/go/bin" >> ~/.bashrc
source ~/.bashrc

# ✅ Step 2: Update & Install Dependencies
echo -e "${YELLOW}➡️ Updating system and installing dependencies...${NC}"
sudo apt-get update -y
sudo apt-get install imagemagick -y
sudo apt-get install openssl -y
sudo apt-get install figlet -y

# ✅ Step 3: Clone 0g-storage-client
echo -e "${YELLOW}➡️ Cloning 0g-storage-client...${NC}"
if [ ! -d "$HOME/0g-storage-client" ]; then
  git clone -b v0.6.1 https://github.com/0glabs/0g-storage-client.git
else
  echo -e "${YELLOW}⚠️ 0g-storage-client already exists, skipping...${NC}"
fi

cd $HOME/0g-storage-client
git submodule update --init
go build

# ✅ Step 4: Download Auto Upload Script
echo -e "${YELLOW}➡️ Downloading auto upload script...${NC}"
wget -q -O auto_upload.sh https://raw.githubusercontent.com/Ajipur-Oprekers/auto_upload-OGLabs/main/auto_upload.sh
chmod +x auto_upload.sh

# ✅ Fixing Windows-style carriage return
echo -e "${YELLOW}➡️ Fixing file format issues...${NC}"
dos2unix auto_upload.sh

echo -e "${GREEN}✅ Permission granted for auto_upload.sh${NC}"

# ✅ Step 5: Jalankan Script di dalam folder
echo -e "${GREEN}🚀 Running auto_upload.sh...${NC}"
cd $HOME/0g-storage-client
./auto_upload.sh

echo -e "${GREEN}🎉 Semua proses selesai dengan sukses! 🚀${NC}"
