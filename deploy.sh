#!/bin/bash
# ============================================
# Laravel Auto Deployment Script for Linux/Mac
# ============================================

if [ -z "$1" ]; then
    echo ""
    echo "============================================"
    echo "Laravel Auto Deployment"
    echo "============================================"
    echo ""
    echo "Penggunaan:"
    echo "  ./deploy.sh <path-to-project>"
    echo ""
    echo "Contoh:"
    echo "  ./deploy.sh /home/user/laravel-project"
    echo "  ./deploy.sh /home/user/myapp.zip"
    echo ""
    echo "Project bisa berupa folder atau file .zip"
    echo "============================================"
    exit 1
fi

PROJECT_PATH="$1"

# Cek apakah file/folder ada
if [ ! -e "$PROJECT_PATH" ]; then
    echo "ERROR: File atau folder tidak ditemukan: $PROJECT_PATH"
    exit 1
fi

echo ""
echo "============================================"
echo "Memulai deployment Laravel..."
echo "============================================"
echo "Project: $PROJECT_PATH"
echo ""

# Jalankan ansible-playbook
ansible-playbook -i inventory.ini deploy.yml -e "project_source=$PROJECT_PATH" --ask-become-pass

if [ $? -eq 0 ]; then
    echo ""
    echo "============================================"
    echo "Deployment BERHASIL!"
    echo "============================================"
    echo ""
else
    echo ""
    echo "============================================"
    echo "Deployment GAGAL!"
    echo "============================================"
    echo "Silakan cek error di atas."
    echo ""
    exit 1
fi
