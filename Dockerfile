FROM golang:1.6-wheezy

MAINTAINER Rudi Kramer <rudi.kramer@gmail.com>

RUN apt-get update && apt-get install -y curl python supervisor --no-install-recommends && \
  export DEBIAN_FRONTEND=noninteractive && \
  curl -k -s https://repo.varnish-cache.org/GPG-key.txt | apt-key add - && \
  apt-get update && apt-get install -y apt-transport-https && \
  echo "deb https://repo.varnish-cache.org/debian wheezy varnish-4.1" >> /etc/apt/sources.list && \
  apt-get update && apt-get -y dist-upgrade && \
  apt-get -y install varnish && \
  rm -rf /var/lib/apt/lists/*

RUN go get github.com/jonnenauha/prometheus_varnish_exporter

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ADD varnish /etc/default/varnish

EXPOSE 9131

CMD ["/usr/bin/supervisord"]
