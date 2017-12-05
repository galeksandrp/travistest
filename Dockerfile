FROM ubuntu:xenial
RUN sed 's&http://archive.ubuntu.com/ubuntu/&mirror://mirrors.ubuntu.com/mirrors.txt&' -i /etc/apt/sources.list
RUN apt-get update && apt-get install -y git build-essential make gperf texinfo lzop xsltproc libxml-parser-perl wget bc gawk zip unzip mkfontscale mkfontdir bdftopcf java
