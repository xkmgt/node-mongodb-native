
# Example usage
# $ docker run -it --net=host \
#   -e MONGODB_URI="mongodb://127.0.0.1:27017" \
#   docker-runner 3.5 argon

FROM centos:7 AS base
RUN yum update -y && yum install -y git make gcc gcc-c++

FROM base

WORKDIR /root
COPY entrypoint.sh entrypoint.sh

ARG MONGODB_URI

ENV DRIVER_REVISION "master"
ENV DRIVER_REPOSITORY "https://github.com/mongodb/node-mongodb-native.git"

ENTRYPOINT ["/bin/bash", "/root/entrypoint.sh"]
CMD ["master", "dubnium"]
