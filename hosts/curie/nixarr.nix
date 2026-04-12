{
  pkgs,
  ...
}:
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

    jellyseerr.enable = true;

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
