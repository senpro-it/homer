# homer
Configuration snippet for NixOS to spin up a homer container using Podman.

## :tada: `Getting started`

Create needed working directories with the following command:

```
mkdir -p /srv/podman/homer/volume.d/homer
```

Place the file `homer.yml` under `/srv/podman/traefik/volume.d/traefik/conf.d` (will be automated in future!):

```
http:
  routers:
    homer:
      rule: "Host(`<hostname>`)"
      service: "homer"
      entryPoints:
      - "https2-tcp"
      tls: true
  services:
    homer:
      loadBalancer:
        passHostHeader: true
        servers:
        - url: "http://homer:8080"
```
