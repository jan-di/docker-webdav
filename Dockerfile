FROM ghcr.io/linuxserver/nginx

# add packages via apk
RUN set -eux; \
    echo "@edge http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories; \
    apk add --no-cache \
        apache2-utils \
        nginx-mod-http-dav-ext@edge

# customize nginx
COPY files/vhost.conf /config/nginx/site-confs/default
RUN set -eux; \
    rm -rf /var/www/*

# docker entrypoint
COPY files/create-htpasswd.sh /config/custom-cont-init.d/

# exposed ports & volumes
EXPOSE 443
VOLUME /var/www