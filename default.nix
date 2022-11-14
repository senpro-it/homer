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
          "homer:/www/assets"
        ];
        environment = {
          INIT_ASSETS = "0";
        };
        autoStart = true;
      };
    };
    systemd.services = {
      "podman-homer" = {
        postStart = ''
          ${pkgs.coreutils-full}/bin/printf '%s\n' "http:" \
          "  routers:" \
          "    homer:" \
          "      rule: \"Host(\`${cfg.traefik.fqdn}\`)\"" \
          "      service: \"homer\"" \
          "      entryPoints:" \
          "      - \"https2-tcp\"" \
          "      tls: true" \
          "  services:" \
          "    homer:" \
          "      loadBalancer:" \
          "        passHostHeader: true" \
          "        servers:" \
          "        - url: \"http://homer:8080\"" > $(${pkgs.podman}/bin/podman volume inspect traefik --format "{{.Mountpoint}}")/conf.d/apps-homer.yml
        '';
      };
    };
  };

}
