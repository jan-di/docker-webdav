# docker-webdav

Docker image of a nginx powered webdav server for my personal use. Feel free to use, but be aware that backwards compatability is not assured and things can break at any time.

## Usage

Specify `WEBDAV_USERNAME` and `WEBDAV_PASSWORD` as environment variables or create a .htpasswd file by yourself and put it to `/config/nginx/.htpasswd`.
Even though the image is designed to be used behind a reverse proxy, the webserver must be accessed through HTTPS to prevent issues with certain WebDAV methods (e.g. MOVE)

## Parameters

You can use the following environment variables to configure the image at runtime:

- `WEBDAV_USERNAME` Name of WebDAV user
- `WEBDAV_PASSWORD` Password of WebDAV user

See also the parameters from the upstream image [linuxserver/nginx](https://github.com/linuxserver/docker-nginx#parameters).