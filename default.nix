{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.senpro.oci-containers.homer;

in

{

  options = {
    senpro.oci-containers.homer.traefik.fqdn = mkOption {
      type = types.str;
      default = "homer.local";
      example = "example.example.com";
      description = ''
        Defines the FQDN under which the predefined container endpoint should be reachable.
      '';
    };
  };

  config = {
    virtualisation.oci-containers.containers = {
      homer = {
        image = "docker.io/b4bz/homer:latest";
        extraOptions = [
          "--net=proxy"
        ];
        volumes = [
          "/srv/podman/homer/volume.d/homer:/www/assets"
        ];
        environment = {
          INIT_ASSETS = "0";
        };
        autoStart = true;
      };
    };
    system.activationScripts = {
      makeHomerBindVolDirectories = ''
        mkdir -p /srv/podman/homer/volume.d/homer
      '';
      makeHomerTraefikConfiguration = ''
        printf '%s\n' \
        "http:"   \
        "  routers:"   \
        "    homer:" \
        "      rule: \"Host(\`${config.senpro.oci-containers.homer.traefik.fqdn}\`)\"" \
        "      service: \"homer\"" \
        "      entryPoints:" \
        "      - \"https2-tcp\"" \
        "      tls: true" \
        "  services:" \
        "    homer:" \
        "      loadBalancer:" \
        "        passHostHeader: true" \
        "        servers:" \
        "        - url: \"http://homer:8080\"" \
        > /srv/podman/traefik/volume.d/traefik/conf.d/homer.yml
      '';
    };
  };

}
