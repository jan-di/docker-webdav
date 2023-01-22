# Dockered WebDAV Server

![](https://flat.badgen.net/docker/size/jandi/webdav/latest)
![](https://flat.badgen.net/docker/layers/jandi/webdav/latest)
![](https://flat.badgen.net/docker/pulls/jandi/webdav)
![](https://flat.badgen.net/docker/stars/jandi/webdav)

Docker image of a nginx powered webdav server for my personal use. This will implement a [Class 2](https://stackoverflow.com/questions/58900793/what-is-a-level-2-webdav-server) compliant WebDAV server. Feel free to use, but be aware that backwards compatability is not assured and things can break at any time.

Registry | Image | Tags
 --- | --- | ---
Dockerhub | `docker.io/jandi/webdav` | [Details](https://hub.docker.com/r/jandi/webdav/tags)
GitHub Container Registry | `ghcr.io/jan-di/webdav` | [Details](https://github.com/jan-di/docker-webdav/pkgs/container/webdav)

## Usage

Specify `WEBDAV_USERNAME` and `WEBDAV_PASSWORD` as environment variables or create a `.htpasswd` file by yourself and put it to `/config/nginx/.htpasswd`.
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
    image: docker.io/jandi/webdav
    labels:
      - traefik.enable=true
      - traefik.http.routers.webdav.entryPoints=https
      - traefik.http.routers.webdav.rule=Host(`domain.example`)
      - traefik.http.routers.webdav.tls=true
      - traefik.http.services.webdav.loadbalancer.server.scheme=https
      - traefik.http.services.webdav.loadbalancer.server.port=443
      - traefik.http.services.webdav.loadbalancer.serverstransport=insecureskipverify@file # See https://doc.traefik.io/traefik/routing/services/#insecureskipverify
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

Skip the verification of the self signed nginx cert in global Treafik configuration (eg. traefik_dynamic.yml). <br />
See [doc.traefik.io -> insecureSkipVerify](https://doc.traefik.io/traefik/routing/services/#insecureskipverify)

```yml
http:
  serversTransports:
    insecureskipverify:
      insecureSkipVerify: true
```
