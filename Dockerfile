FROM ubuntu:groovy
# AOSP
RUN DEBIAN_FRONTEND=noninteractive apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y git-core gnupg flex bison build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z1-dev libgl1-mesa-dev libxml2-utils xsltproc unzip fontconfig
# LineageOS
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y bc bison build-essential ccache curl flex g++-multilib gcc-multilib git gnupg gperf imagemagick lib32ncurses5-dev lib32readline-dev lib32z1-dev liblz4-tool libncurses5 libncurses5-dev libsdl1.2-dev libssl-dev libxml2 libxml2-utils lzop pngcrush rsync schedtool squashfs-tools xsltproc zip zlib1g-dev
# FIH SS2
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y python3
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
