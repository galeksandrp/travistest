FROM centos:6.8
RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
RUN yum -y install wget
RUN wget https://gist.githubusercontent.com/galeksandrp/dfc7c2c85f9fe6726f0df45094e48315/raw/ff8f14dc50188bdbd28764b9e19661da0c7d17bb/mikbill.repo -O /etc/yum.repos.d/mikbill.repo
RUN yum makecache
RUN yum -y update
RUN yum -y install $(yum deplist mikbill | grep dependency | cut -d ' ' -f 4)
EXPOSE 80
CMD yum -y install mikbill
