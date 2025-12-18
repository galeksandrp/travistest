FROM php:7.4.33-apache

RUN apt-get update && apt-get install -y \
  openssh-server \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /root/.ssh
RUN echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC2mDA6VeYm/OaiF5A82Rlo8c5bH8uZltencwPCJBRx1XZ4a1uVvkPJgzYGHtXUSY3wh/eGnvvYeV0dUZUvTKlxMU6LQDyuDVrh1KRK/vY4b+CtxRY24i+GLyTJMarPDsulXca8s8yqVRtwgYusn3UdMS7UqLn2bDTLMluuDSDXIgfX34Z8w7K0ashX2YrO6lmy1CmfvLj1u0/jeF4is0rT94bL83uBHpmCoV6xEoABYY0tZ1InrUXDm5fhKJrna7xbJSiPk7wjtxyFA/cphO4jiTJZmmsHDsg9RnpJMxHRX2ClAg9xqhNxMlpfJhUtjG/h0gPgY19bpVeEpLgqv02z ubuntu@HP' > /root/.ssh/authorized_keys

RUN a2enmod rewrite
RUN a2dismod php7
RUN a2dismod mpm_prefork
RUN a2enmod mpm_event
RUN a2enmod proxy_fcgi
RUN a2enmod http2
