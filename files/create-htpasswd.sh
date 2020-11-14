#!/bin/sh
set -e

if [ ! -f /config/nginx/.htpasswd ] \
    && [ ! -z "$WEBDAV_USERNAME" ] \
    && [ ! -z "$WEBDAV_PASSWORD" ]; then

    echo "Creating .htpassword file for user $WEBDAV_USERNAME"
    echo $WEBDAV_PASSWORD | htpasswd -ic /config/nginx/.htpasswd $WEBDAV_USERNAME
fi