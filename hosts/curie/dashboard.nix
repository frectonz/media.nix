{ ... }:
let
  vars = import ./variables.nix;
in
{
  services.homepage-dashboard = {
    enable = true;
    listenPort = 80;
    openFirewall = true;

    widgets = [
      {
        resources = {
          cpu = true;
          disk = "/";
          memory = true;
          cputemp = true;
          uptime = true;
          units = "metric";
        };
      }
      {
        datetime = {
          text_size = "xl";
          format.timeStyle = "short";
        };
      }
    ];

    settings = {
      title = "Curie";
      background = {
        image = "https://images.pexels.com/photos/16824570/pexels-photo-16824570.jpeg";
        blur = "sm";
        saturate = 50;
        brightness = 50;
        opacity = 50;
      };
      theme = "dark";
      color = "slate";
      headerStyle = "boxedWidgets";
    };

    services = [
      {
        "Media Services" = [
          {
            "Jellyfin" = {
              icon = "jellyfin.png";
              description = "Media streaming";
              href = "http://${vars.ip}:8096";
              widget = {
                type = "jellyfin";
                url = "http://${vars.ip}:8096";
                key = "07102904fd674a639c07275e9102d968";
                enableBlocks = true;
                enableNowPlaying = true;
                enableUser = true;
                showEpisodeNumber = true;
                expandOneStreamToTwoRows = true;
              };
            };
          }
          {
            "Transmission" = {
              icon = "transmission.png";
              description = "Handles torrent downloads";
              href = "http://${vars.ip}:9091";
              widget = {
                type = "transmission";
                url = "http://${vars.ip}:9091";
              };
            };
          }
        ];
      }
      {
        "Arr Services" = [
          {
            "Radarr" = {
              icon = "radarr.png";
              description = "Automated movie downloads";
              href = "http://${vars.ip}:7878";
              widget = {
                type = "radarr";
                url = "http://${vars.ip}:7878";
                key = "acfc274802fd46f8bbc5f1283f512259";
                enableQueue = true;
              };
            };
          }
          {
            "Sonarr" = {
              icon = "sonarr.png";
              description = "Automated TV show downloads";
              href = "http://${vars.ip}:8989";
              widget = {
                type = "sonarr";
                url = "http://${vars.ip}:8989";
                key = "03274698a7b14848938cf641cfd3b144";
              };
            };
          }
          {
            "Lidarr" = {
              icon = "lidarr.png";
              description = "Automated music downloads";
              href = "http://${vars.ip}:8686";
              widget = {
                type = "lidarr";
                url = "http://${vars.ip}:8686";
                key = "b310c4c8e6e142e2a0ef5d28e2efb89e";
              };
            };
          }
          {
            "Readarr" = {
              icon = "readarr.png";
              description = "Automated eBook and audiobook downloads";
              href = "http://${vars.ip}:8787";
              widget = {
                type = "readarr";
                url = "http://${vars.ip}:8787";
                key = "c56a8989505946bbb71f4b48ecf30b2d";
              };
            };
          }
          {
            "Bazarr" = {
              icon = "bazarr.png";
              description = "Automated subtitle downloads";
              href = "http://${vars.ip}:6767";
              widget = {
                type = "bazarr";
                url = "http://${vars.ip}:6767";
                key = "e93c0a805c819bdc073392c21b8c9b09";
              };
            };
          }
          {
            "Prowlarr" = {
              icon = "prowlarr.png";
              description = "Index manager";
              href = "http://${vars.ip}:9696";
              widget = {
                type = "prowlarr";
                url = "http://${vars.ip}:9696";
                key = "dbfb8b7ec76b481885c7ad136fd61d80";
              };
            };
          }
        ];
      }
    ];
  };

  systemd.services.homepage-dashboard.serviceConfig.AmbientCapabilities = "cap_net_bind_service";
}
