FROM debian:9.7-slim

RUN apt-get update \
  && apt-get install -y git \
  && apt-get install -y wget \
  && curl -sL https://deb.nodesource.com/setup_13.x | bash -
  && apt-get install -y nodejs
  && rm -rf /var/lib/apt/lists/*

COPY *.sh /
RUN chmod +x /*.sh

ENTRYPOINT ["/entrypoint.sh"]