FROM ubuntu:xenial
# AOSP
RUN apt-get update && apt-get install -y git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev libgl1-mesa-dev libxml2-utils xsltproc unzip
# LineageOS
RUN apt-get install -y bc bison build-essential ccache curl flex g++-multilib gcc-multilib git gnupg gperf imagemagick lib32ncurses5-dev lib32readline-dev lib32z1-dev liblz4-tool libncurses5-dev libsdl1.2-dev libssl-dev libwxgtk3.0-dev libxml2 libxml2-utils lzop pngcrush rsync schedtool squashfs-tools xsltproc zip zlib1g-dev
# AOSP repo preq
RUN mkdir ~/bin
RUN echo 'PATH=~/bin:$PATH' >> ~/.bashrc
# AOSP repo
RUN curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
RUN chmod a+x ~/bin/repo
# Mitigate repo question
RUN git config --global user.name 'Alexander Georgievskiy'
RUN git config --global user.email 'galeksandrp@gmail.com'
# LineageOS required directories
RUN mkdir -p ~/bin
RUN mkdir -p ~/android/lineage
