FROM debian:9.7-slim

RUN apt-get update \
  && apt-get install -y git \
  && apt-get install -y wget \
  && rm -rf /var/lib/apt/lists/*


ADD entrypoint.sh /entrypoint.sh
ADD build-deploy.sh /build-deploy.sh
ADD build.sh /build.sh
ADD deploy.sh /deploy.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]`