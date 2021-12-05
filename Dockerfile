FROM docker

RUN mkdir -p /root/dockerbuild

RUN echo 'FROM scratch AS stage1' >> /root/dockerbuild/Dockerfile
RUN echo 'COPY data /root/dockerbuild/data' >> /root/dockerbuild/Dockerfile

WORKDIR /root/dockerbuild

CMD ["sh", "-c", "( ( docker pull $DOCKER_TAG \
        && echo \"FROM $DOCKER_TAG\" >> /root/dockerbuild/Dockerfile \
        || echo 'FROM alpine:3.22.1' >> /root/dockerbuild/Dockerfile ) \
    && echo 'COPY --from=stage1 /root/dockerbuild/data /root/dockerbuild/data' >> /root/dockerbuild/Dockerfile \
    && docker build -t $DOCKER_TAG . \
    && docker login -u $DOCKERHUB_LOGIN -p $DOCKERHUB_TOKEN \
    && docker push $DOCKER_TAG ) ; sleep 600"]
