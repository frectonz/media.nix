{
  pkgs,
  ...
}:
let
  seerr = pkgs.seerr.overrideAttrs {
    postBuild = ''
      # Clean up broken symlinks left behind by `pnpm prune`
      find node_modules -type l ! -exec test -e {} \; -delete
    '';
  };
in
{
  nixarr = {
    enable = true;

    mediaDir = "/data/media";
    stateDir = "/data/media/.state/nixarr";

    jellyfin.enable = true;
    lidarr.enable = true;
    prowlarr.enable = true;
    radarr.enable = true;
    readarr.enable = true;
    sonarr.enable = true;

    jellyseerr = {
      enable = true;
      package = seerr;
    };

    transmission = {
      enable = true;
      extraAllowedIps = [ "100.*.*.*" ];
      extraSettings = {
        rpc-host-whitelist = "curie";
      };
    };
  };

  services.flaresolverr = {
    enable = true;
    package = pkgs.nur.repos.xddxdd.flaresolverr-21hsmw;
  };
}
