FROM docker

RUN mkdir -p /root/dockerbuild

WORKDIR /root/dockerbuild

CMD ["sh", "-c", "( docker login -u $DOCKERHUB_LOGIN -p $DOCKERHUB_TOKEN $DOCKERHUB_URL \
        && INT_DOCKER_IMAGE=galeksandrp/travistest:docker-alpine-rsync \
        && docker pull $DOCKER_TAG \
        && INT_DOCKER_IMAGE=$DOCKER_TAG \
    ; INT_DOCKER_CONTAINER=name-$(echo $DOCKER_TAG | sha256sum | cut -d ' ' -f1) \
        && docker rm $INT_DOCKER_CONTAINER \
    ; docker run --name $INT_DOCKER_CONTAINER -v $HOST_DIRPATH:/root/dockerbuild/from $INT_DOCKER_IMAGE rsync -ar --info=NAME --no-owner --no-group --delete /root/dockerbuild/from /root/dockerbuild/data | grep . \
        && docker commit $INT_DOCKER_CONTAINER $DOCKER_TAG \
    ; docker rm $INT_DOCKER_CONTAINER \
        && docker push $DOCKER_TAG ) ; sleep 600"]
