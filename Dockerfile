FROM galeksandrp/travistest:docker-build-android
RUN apt-get update && apt-get install -y openjdk-8-jdk
