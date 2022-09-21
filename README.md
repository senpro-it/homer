# homer
Configuration snippet for NixOS to spin up a homer container using Podman.

## :tada: `Getting started`

Clone the repository into the directory `/srv/podman/homer`. The path can't be changed for now!

Add the following statement to your `imports = [];` in `configuration.nix` and do a `nixos-rebuild`:

```
/srv/podman/homer/default.nix {
  senpro.oci-containers.homer.traefik.fqdn = "<your-fqdn>";
}
```
