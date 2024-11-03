#!/bin/bash

# Định nghĩa đường dẫn thư mục mã nguồn và plugin
source_code_dir="sources"
plugins_dir="$source_code_dir/plugins"
glpi_download_url=$(curl -s https://api.github.com/repos/glpi-project/glpi/releases/latest | grep 'browser_download_url' | cut -d '"' -f 4 | grep '.tgz')

# Kiểm tra URL tải về
if [ -z "$glpi_download_url" ]; then
    echo "Failed to find the GLPI download URL. Please check the API response or connectivity."
    exit 1
fi

# Bước 1: Tải xuống GLPI nếu chưa có
echo "Downloading GLPI..."
echo "==================="
if [ ! -f "$source_code_dir/glpi-latest.tgz" ]; then
    mkdir -p $source_code_dir
    wget -O $source_code_dir/glpi-latest.tgz "$glpi_download_url"
    if [ $? -ne 0 ]; then
        echo "Download failed! Check the URL or your internet connection."
        exit 1
    fi
else
    echo "GLPI archive already exists. Skipping download."
fi

# Bước 2: Dọn dẹp thư mục cũ nếu có
echo "Cleaning directories..."
echo "======================="
rm -rf glpi nginx/glpi php-fpm/glpi

# Bước 3: Giải nén các tệp mã nguồn và plugin
echo "Extracting sources..."
echo "====================="
tar -xvzf $source_code_dir/glpi-latest.tgz -C .

if [ -d "$plugins_dir" ]; then
    unzip "$plugins_dir/glpi*.zip" -d glpi/plugins/
else
    echo "Plugin directory not found!"
    exit 1
fi

# Bước 4: Sao chép mã nguồn vào thư mục cần thiết
echo "Copying files..."
echo "================"
cp -a glpi nginx/glpi
cp -a glpi php-fpm/glpi

# Bước 5: Xây dựng và chạy Docker
echo "Building docker images..."
echo "========================="
docker compose up -d --build

# Hoàn tất
echo "Done!"
echo "========================="
