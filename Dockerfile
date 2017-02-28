FROM gcc:6.1
RUN sed 's&http://deb.debian.org/debian&http://httpredir.debian.org/debian&' -i /etc/apt/sources.list
RUN apt-get update && apt-get install -y wget
WORKDIR /root
RUN wget https://dl.google.com/android/ndk/android-ndk-r10e-linux-x86_64.bin && chmod +x android-ndk-r10e-linux-x86_64.bin && ./android-ndk-r10e-linux-x86_64.bin | egrep -v ^Extracting && /root/android-ndk-r10e/build/tools/make-standalone-toolchain.sh --arch=arm --install-dir=/root/android-toolchain && rm -rf /root/android-ndk-r10e*
WORKDIR /root/android-toolchain
