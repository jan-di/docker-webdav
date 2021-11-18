FROM ghcr.io/linuxserver/nginx:1.20.2

# add packages via apk
RUN set -eux; \
    apk add --no-cache \
        apache2-utils

# customize nginx
COPY files/vhost.conf /config/nginx/site-confs/default
RUN set -eux; \
    rm -rf /var/www/*

# docker entrypoint
COPY files/create-htpasswd.sh /config/custom-cont-init.d/

# exposed ports & volumes
EXPOSE 443
VOLUME /var/www