FROM mcr.microsoft.com/windows/servercore:ltsc2022

# choco

RUN powershell Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# msys2

RUN powershell iwr -UseBasicParsing -OutFile msys2.exe https://github.com/msys2/msys2-installer/releases/download/nightly-x86_64/msys2-base-x86_64-latest.sfx.exe && msys2.exe && del /F msys2.exe

# app deps

RUN msys64\msys2_shell.cmd -mingw64 -defterm -no-start -c "pacman -Syu --noconfirm mingw-w64-x86_64-yasm make mingw-w64-x86_64-gcc mingw-w64-cross-binutils"
RUN msys64\msys2_shell.cmd -mingw64 -defterm -no-start -c "pacman -Syu --noconfirm mingw-w64-x86_64-yasm make mingw-w64-x86_64-gcc mingw-w64-cross-binutils"

RUN choco install -y git

# Build Tools for Visual Studio 2022

RUN choco install -y visualstudio2022-workload-vctools --params "--add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.Windows10SDK.19041 --add Microsoft.VisualStudio.Component.VC.ATL --add Microsoft.VisualStudio.Component.VC.ATLMFC --no-includeRecommended"

#FROM galeksandrp/travistest:docker-servercore-ltsc2022

# 7-zip

RUN choco install -y 7zip

# MPC-BE SDK

RUN powershell iwr -UseBasicParsing -OutFile msys.7z "$('https://mpc-be.org/MSYS/' + ((iwr -UseBasicParsing 'https://mpc-be.org/MSYS/').Links.href | ? {$_ -like '*.7z'})[-1])" && 7z x msys.7z mingw\mpcbe_libs mingw\lib\gcc\x86_64-w64-mingw32 && del /F msys.7z
RUN mkdir mingw\bin
RUN echo ^%SYSTEMDRIVE^%\msys64\mingw64\bin\gcc %* >> mingw\bin\gcc.bat

# Inno Setup

RUN choco install -y innosetup
