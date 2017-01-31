FROM centos:6.8
RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
RUN yum -y install wget
RUN wget https://raw.githubusercontent.com/galeksandrp/mikbill/master/6/x86_64/mikbill-repo-1.0-1.x86_64.rpm -O - | rpm2cpio | cpio -i
RUN sed 's&http://194.28.89.175/&https://raw.githubusercontent.com/galeksandrp/mikbill/master/&' -i /etc/yum.repos.d/mikbill.repo
RUN yum makecache
RUN yum -y update
RUN yum -y install $(yum deplist mikbill | grep dependency | cut -d ' ' -f 4)
EXPOSE 80
CMD yum -y install mikbill
