FROM ubuntu:xenial
RUN apt update && apt install -y wget apt-transport-https
RUN wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb \
  && dpkg -i packages-microsoft-prod.deb \
  && rm packages-microsoft-prod.deb
RUN apt update && apt install -y powershell
RUN pwsh Install-Module -Name Pester -Force
