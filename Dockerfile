# Container image that runs your code
FROM alpine:3.10

RUN apt-get update && apt-get install -y git

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]