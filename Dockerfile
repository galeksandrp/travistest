FROM gcc
RUN sed 's&http://deb.debian.org/debian&http://httpredir.debian.org/debian&' -i /etc/apt/sources.list
RUN apt-get update
RUN git clone http://git.stg.codes/stg.git
RUN cd stg/projects/stargazer
RUN git checkout stg-2.409
RUN ./build
