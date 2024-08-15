FROM ghcr.io/linuxserver/nginx:1.26.2

# add packages via apk
RUN set -eux; \
    apk add --no-cache \
    apache2-utils

# customize nginx
COPY files/vhost.conf /config/nginx/site-confs/default
RUN set -eux; \
    rm -rf /var/www/*; \
    mkdir /var/www/dav; \
    chmod -R a+rwX /var/www

# docker entrypoint
COPY files/create-htpasswd.sh /custom-cont-init.d/

# exposed ports & volumes
EXPOSE 443
VOLUME /var/www/dav
