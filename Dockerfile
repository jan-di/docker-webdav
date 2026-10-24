FROM ghcr.io/linuxserver/nginx:1.30.4

# add packages via apk
RUN set -eux; \
    apk add --no-cache \
    apache2-utils

# remove php packages (php<version>-*), not used
RUN set -eux; \
    pkgs="$(apk info | grep -E '^php[0-9]+-' || true)"; \
    if [ -n "$pkgs" ]; then apk del --no-cache $pkgs; fi

# customize nginx
COPY files/vhost.conf /config/nginx/site-confs/default
RUN set -eux; \
    rm -rf /var/www/*; \
    mkdir /var/www/dav; \
    chmod -R a+rwX /var/www

# docker entrypoint
COPY files/create-htpasswd.sh /custom-cont-init.d/
RUN chmod +x /custom-cont-init.d/*.sh

# disable php-fpm, not used
RUN rm -r /etc/s6-overlay/s6-rc.d/svc-php-fpm /etc/s6-overlay/s6-rc.d/user/contents.d/svc-php-fpm

# exposed ports & volumes
EXPOSE 443
VOLUME /var/www/dav
