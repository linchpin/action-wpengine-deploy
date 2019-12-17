FROM debian:9.7-slim

RUN apt-get update && apt-get install -y git

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]