FROM mysql:5.7
RUN wget https://github.com/galeksandrp/mysql-server/releases/download/v5.7.20-fix-mysql-5.7.20-deploy/mysqldump -O /usr/bin/mysqldump-tldr
