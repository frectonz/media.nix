{
  pkgs,
  ...
}:
let
  jellyseerr = pkgs.jellyseerr.overrideAttrs {
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
    transmission.enable = true;
    lidarr.enable = true;
    prowlarr.enable = true;
    radarr.enable = true;
    readarr.enable = true;
    sonarr.enable = true;
    jellyseerr.enable = true;

    jellyseerr.package = jellyseerr;
  };

  services.flaresolverr = {
    enable = true;
    package = pkgs.nur.repos.xddxdd.flaresolverr-21hsmw;
  };
}
