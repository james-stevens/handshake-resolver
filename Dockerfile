# (c) Copyright 2019-2020, James Stevens ... see LICENSE for details
# Alternative license arrangements are possible, contact me for more information

FROM alpine:3.13

RUN apk update
RUN apk upgrade

RUN apk add bind

RUN mkdir -p /opt /opt/named /opt/named /opt/named/etc
RUN mkdir -p /opt/named/etc/bind /opt/named/zones /opt/named/var /opt/named/var/run

RUN cp -a /etc/bind/rndc.key /opt/named/etc/bind

RUN chown -R named: /opt/named/zones /opt/named/var
RUN rm -f /etc/periodic/monthly/dns-root-hints

COPY inittab /etc/inittab
COPY named.conf /opt/named/etc/bind
COPY servers.internal servers.inc /opt/named/etc/bind/
COPY update_servers /etc/periodic/weekly
COPY sync_clean /etc/periodic/daily

COPY start_syslogd /usr/local/bin
COPY startup /usr/local/bin
COPY start_bind /usr/local/bin

CMD [ "/sbin/init" ]
