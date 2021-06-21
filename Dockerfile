FROM ubuntu
RUN apt update && apt install -y liblzo2-dev mtd-utils squashfs-tools fakeroot python-is-python3 python3-pip
RUN pip install python-lzo ubi_reader
