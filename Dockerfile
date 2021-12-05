FROM docker

RUN mkdir -p /root/dockerbuild

RUN echo 'FROM alpine:3.22.1' >> /root/dockerbuild/Dockerfile
RUN echo 'COPY data /root/dockerbuild/data' >> /root/dockerbuild/Dockerfile

WORKDIR /root/dockerbuild

CMD ["sh", "-c", "( docker build -t $DOCKER_TAG . \
    && docker login -u $DOCKERHUB_LOGIN -p $DOCKERHUB_TOKEN $DOCKERHUB_URL \
    && docker push $DOCKER_TAG ) ; sleep 600"]
