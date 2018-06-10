FROM golang:1.9 AS build
ADD . /src
WORKDIR /src
RUN go get -d -v -t
RUN go test --cover -v ./... --run UnitTest
RUN go build -v -o go-demo

#FROM ruby:2.3-slim
FROM ubuntu:16.04
MAINTAINER 	Vitor Caetano <vitor.e.caetano@gmail.com>

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -qq -y --no-install-recommends \
    apache2

ADD ssl/icasei.com.br.pem /etc/ssl/apache2/icasei.com.br.pem
ADD ssl/icasei.com.br.key /etc/ssl/apache2/icasei.com.br.key
ADD ssl/gd_bundle.crt /etc/ssl/apache2/gd_bundle.crt

ADD admin_material.conf /etc/apache2/sites-available/admin_material.conf
ADD admin_material-ssl.conf /etc/apache2/sites-available/admin_material-ssl.conf

RUN a2enmod ssl proxy proxy_http proxy_wstunnel
RUN a2ensite admin_material
RUN a2ensite admin_material-ssl

COPY --from=build /src/go-demo /usr/local/bin/go-demo
RUN chmod +x /usr/local/bin/go-demo

ENV INSTALL_PATH /admin_material
RUN mkdir -p $INSTALL_PATH
WORKDIR $INSTALL_PATH

COPY ./public ./public

WORKDIR /
COPY ./start.sh /

EXPOSE 80
EXPOSE 443

CMD ["./start.sh"]