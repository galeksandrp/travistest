FROM drodrigues/ubuntu-phash
COPY phash.cpp .
RUN c++ phash.cpp
