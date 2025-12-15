# Ansible Auto Laravel Deployment

Sistem deployment otomatis untuk Laravel menggunakan Ansible. Cukup berikan path project atau file .zip, dan biarkan Ansible mengurus semuanya!

## 🚀 Fitur

- ✅ Support deployment dari **folder**, **file .zip**, atau **Git repository**
- ✅ Otomatis **git clone** dari GitHub/GitLab/Bitbucket
- ✅ Otomatis setup **MySQL** (database & user)
- ✅ Otomatis install **Composer dependencies**
- ✅ Otomatis konfigurasi **.env**
- ✅ Otomatis **migrate database**
- ✅ Otomatis konfigurasi **Apache virtual host**
- ✅ Otomatis set **permissions** yang benar
- ✅ Otomatis **optimize cache** Laravel
- ✅ Satu perintah untuk deploy lengkap!

## 📋 Prasyarat

Server target sudah harus terinstall:
- Apache2
- PHP (8.0+)
- MySQL/MariaDB
- Composer
- Ansible (di mesin yang menjalankan deployment)

## ⚙️ Konfigurasi

### 1. Edit `vars.yml`

Sesuaikan konfigurasi deployment di file `vars.yml`:

```yaml
# Path ke project (akan di-override saat menjalankan script)
project_source: ""

# Nama project
project_name: "laravel-app"

# Direktori deployment
deploy_base_path: "/var/www/html"

# Konfigurasi domain
server_name: "localhost"
server_alias: "www.localhost"

# Port Apache (bisa single atau multi port)
# Single port: apache_port: 80
# Multi port: apache_port: [80, 8080, 8081]
apache_port: 80

# Konfigurasi database
db_name: "laravel_db"
db_user: "laravel_user"
db_password: "laravel_password"
db_host: "localhost"

# MySQL root password
mysql_root_password: "root"

# PHP version
php_version: "8.1"

# Apache user
apache_user: "www-data"
apache_group: "www-data"

# Laravel environment
app_env: "production"
app_debug: "false"
```

### 2. Edit `inventory.ini`

Tentukan server target deployment:

```ini
[laravel_servers]
# Untuk deployment lokal:
localhost ansible_connection=local

# Untuk deployment ke remote server:
# 192.168.1.100 ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa
```

## 🎯 Cara Penggunaan

### Windows

```cmd
# Dari folder lokal
deploy.bat C:\path\to\laravel-project

# Dari file zip
deploy.bat C:\path\to\project.zip

# Dari Git repository
deploy.bat https://github.com/username/laravel-app.git
```

### Linux/Mac

```bash
chmod +x deploy.sh

# Dari folder lokal
./deploy.sh /path/to/laravel-project

# Dari file zip
./deploy.sh /path/to/project.zip

# Dari Git repository
./deploy.sh https://github.com/username/laravel-app.git
```

### Manual (tanpa script)

```bash
# Dari folder/zip
ansible-playbook -i inventory.ini deploy.yml -e "project_source=/path/to/project" --ask-become-pass

# Dari Git repository
ansible-playbook -i inventory.ini deploy.yml -e "project_source=https://github.com/username/laravel-app.git" --ask-become-pass

# Dari Git dengan branch tertentu
ansible-playbook -i inventory.ini deploy.yml -e "project_source=https://github.com/username/laravel-app.git" -e "git_branch=develop" --ask-become-pass
```

## 📁 Struktur Project

```
ansible-autolaravel/
├── deploy.yml              # Main playbook
├── vars.yml                # Konfigurasi deployment
├── inventory.ini           # Daftar server target
├── deploy.bat              # Script Windows
├── deploy.sh               # Script Linux/Mac
└── roles/
    ├── project_setup/      # Extract & copy project
    │   └── tasks/
    │       └── main.yml
    ├── mysql_setup/        # Setup database
    │   └── tasks/
    │       └── main.yml
    ├── laravel_setup/      # Setup Laravel (composer, env, migrate)
    │   └── tasks/
    │       └── main.yml
    └── apache_setup/       # Setup Apache virtual host
        ├── tasks/
        │   └── main.yml
        ├── templates/
        │   └── laravel-vhost.conf.j2
        └── handlers/
            └── main.yml
```

## 🔧 Proses Deployment

Ansible akan otomatis melakukan:

1. **Setup Database**
   - Membuat database MySQL
   - Membuat user database
   - Set privileges

2. **Setup Project**
   - Extract file .zip (jika source berupa .zip)
   - Copy files ke destination
   - Set ownership yang benar

3. **Setup Laravel**
   - Copy .env dari .env.example
   - Update konfigurasi database di .env
   - Install composer dependencies
   - Generate application key
   - Run database migrations
   - Clear & optimize cache
   - Set permissions untuk storage & bootstrap/cache
   - Create storage link

4. **Setup Apache**
   - Konfigurasi port Apache (single atau multi port)
   - Buat virtual host configuration
   - Enable required modules (rewrite, proxy_fcgi)
   - Enable site
   - Restart Apache

## 🎨 Kustomisasi

### Multi Port Configuration

Aplikasi bisa diakses di berbagai port:

```yaml
# Single port
apache_port: 80

# Multi port
apache_port: [80, 8080, 8081]
```

Dengan multi port, aplikasi bisa diakses di:
- http://localhost:80
- http://localhost:8080  
- http://localhost:8081

### Deploy hanya bagian tertentu dengan tags:

```bash
# Hanya setup database
ansible-playbook -i inventory.ini deploy.yml -e "project_source=/path/to/project" --tags mysql

# Hanya setup Laravel (tanpa Apache)
ansible-playbook -i inventory.ini deploy.yml -e "project_source=/path/to/project" --tags laravel

# Hanya setup Apache
ansible-playbook -i inventory.ini deploy.yml -e "project_source=/path/to/project" --tags apache
```

### Override variables via command line:

```bash
ansible-playbook -i inventory.ini deploy.yml \
  -e "project_source=/path/to/project" \
  -e "project_name=myapp" \
  -e "db_name=myapp_db" \
  -e "server_name=myapp.local" \
  -e "apache_port=[80,8080]"
```

### Contoh penggunaan port custom:

```bash
# Deploy dengan port 3000
ansible-playbook -i inventory.ini deploy.yml -e "project_source=/path/to/project" -e "apache_port=3000"

# Deploy dengan multi port
ansible-playbook -i inventory.ini deploy.yml -e "project_source=/path/to/project" -e "apache_port=[80,8080,8888]"
```

## 🐛 Troubleshooting

### Permission denied saat copy files
Pastikan user Ansible punya akses sudo. Gunakan `--ask-become-pass` untuk input password sudo.

### Composer command not found
Install composer di server target atau sesuaikan path composer di playbook.

### MySQL connection error
Pastikan MySQL root password di `vars.yml` benar dan MySQL service berjalan.

### Apache not restarting
Cek syntax virtual host: `sudo apache2ctl configtest`

## 📝 Catatan

- Pastikan port 80 tidak digunakan aplikasi lain
- Untuk production, ubah `app_debug: "false"` dan `app_env: "production"`
- Backup database sebelum re-deploy jika ada data penting
- File .env akan dibuat otomatis dari .env.example jika belum ada

## 📄 License

Bebas digunakan untuk keperluan apapun.

## 🤝 Kontribusi

Silakan buat issue atau pull request untuk improvement!
