FROM node:12.6.0
RUN apt-get update && apt-get install -y jq
RUN npm install -g bower
RUN npm install -g grunt-cli
