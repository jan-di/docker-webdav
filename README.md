# docker-webdav

Docker image of a nginx powered webdav server for my personal use. Feel free to use, but be aware that backwards compatability is not assured and things can break at any time.

## Usage

Specify `WEBDAV_USERNAME` and `WEBDAV_PASSWORD` as environment variables or create a .htpasswd file by yourself and put it to `/config/nginx/.htpasswd`.
Even though the image is designed to be used behind a reverse proxy, the webserver must be accessed through HTTPS to prevent issues with certain WebDAV methods (e.g. MOVE)

## Parameters

Configure the container by specifying environment variables:

Name | Description
--- | ---
`WEBDAV_USERNAME` | Name of WebDAV user
`WEBDAV_PASSWORD` | Password of WebDAV user

See also the parameters from the upstream image [linuxserver/nginx](https://github.com/linuxserver/docker-nginx#parameters).

## Example Configuration

Docker-compose file with webdav server behind traefik reverse proxy:
Make sure you also allow insecure certificates in traefik for internal connections.

```yml
version: '3.8'

services: 
  web:
    image: jandi/webdav
    labels:
      - traefik.enable=true
      - traefik.http.routers.webdav.entryPoints=https
      - traefik.http.routers.webdav.rule=Host(`domain.example`)
      - traefik.http.routers.webdav.tls=true
      - traefik.http.services.webdav.loadbalancer.server.scheme=https
      - traefik.http.services.webdav.loadbalancer.server.port=443
    networks:
      - ~traefik
    volumes:
      - ./data/web:/var/www
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/Berlin
      - WEBDAV_USERNAME=username
      - WEBDAV_PASSWORD=super-secret-password
    restart: unless-stopped

networks:
  ~traefik:
    external: true
```
