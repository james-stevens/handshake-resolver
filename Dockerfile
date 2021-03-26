# (c) Copyright 2019-2020, James Stevens ... see LICENSE for details
# Alternative license arrangements are possible, contact me for more information

FROM alpine

RUN apk update
RUN apk upgrade

RUN apk add bind

RUN mkdir -p /opt /opt/named /opt/named/dev /opt/named/etc
RUN mkdir -p /opt/named/etc/bind /opt/named/zones /opt/named/var /opt/named/var/run

RUN cp -a /dev/null /opt/named/dev
RUN cp -a /dev/zero /opt/named/dev
RUN cp -a /dev/random /opt/named/dev
RUN cp -a /dev/urandom /opt/named/dev

RUN chown -R nobody: /opt/named/zones /opt/named/var

COPY inittab /etc/inittab
COPY named.conf /opt/named/etc/bind

CMD [ "/sbin/init" ]
