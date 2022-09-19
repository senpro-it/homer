{
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
}
