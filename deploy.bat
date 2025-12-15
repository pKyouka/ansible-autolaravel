@echo off
REM ============================================
REM Laravel Auto Deployment Script for Windows
REM ============================================

setlocal enabledelayedexpansion

if "%~1"=="" (
    echo.
    echo ============================================
    echo Laravel Auto Deployment
    echo ============================================
    echo.
    echo Penggunaan:
    echo   deploy.bat ^<source^>
    echo.
    echo Contoh:
    echo   deploy.bat C:\laravel-project
    echo   deploy.bat C:\myapp.zip
    echo   deploy.bat https://github.com/username/laravel-app.git
    echo.
    echo Source bisa berupa:
    echo   - Folder lokal
    echo   - File .zip
    echo   - Git repository URL
    echo ============================================
    exit /b 1
)

set PROJECT_PATH=%~1

REM Cek apakah file/folder ada
if not exist "%PROJECT_PATH%" (
    echo ERROR: File atau folder tidak ditemukan: %PROJECT_PATH%
    exit /b 1
)

echo.
echo ============================================
echo Memulai deployment Laravel...
echo ============================================
echo Project: %PROJECT_PATH%
echo.

REM Jalankan ansible-playbook
ansible-playbook -i inventory.ini deploy.yml -e "project_source=%PROJECT_PATH%" --ask-become-pass

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ============================================
    echo Deployment BERHASIL!
    echo ============================================
    echo.
) else (
    echo.
    echo ============================================
    echo Deployment GAGAL!
    echo ============================================
    echo Silakan cek error di atas.
    echo.
    exit /b 1
)

endlocal
