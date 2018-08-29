FROM ubuntu:xenial
RUN sed 's&http://archive.ubuntu.com/ubuntu/&mirror://mirrors.ubuntu.com/mirrors.txt&' -i /etc/apt/sources.list
RUN apt-get update && apt-get install -y curl apt-transport-https
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl -o /etc/apt/sources.list.d/microsoft.list https://packages.microsoft.com/config/ubuntu/16.04/prod.list
RUN apt-get update && apt-get install -y git build-essential powershell bison gawk m4 texinfo
RUN pwsh -Command Install-Module -Name Pester -Force -SkipPublisherCheck
