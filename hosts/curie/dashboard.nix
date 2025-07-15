{ ... }:
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
              href = "http://curie:8096";
              widget = {
                type = "jellyfin";
                url = "http://curie:8096";
                key = "c6ab5aa650ac4e80ac571d5d14a88297";
                enableBlocks = true;
                enableNowPlaying = true;
                enableUser = true;
                showEpisodeNumber = true;
                expandOneStreamToTwoRows = true;
              };
            };
          }
          {
            "Jellyseerr" = {
              icon = "jellyseerr.png";
              description = "Media requests";
              href = "http://curie:5055";
              widget = {
                type = "jellyseerr";
                url = "http://curie:5055";
                key = "MTc1MDkyMzY3MzIyMTc0ZTA3MjYxLWFmZTItNDI0NS1iMGE2LTUzOTY5YjcwN2FkOQ==";
              };
            };
          }
          {
            "Transmission" = {
              icon = "transmission.png";
              description = "Handles torrent downloads";
              href = "http://curie:9091";
              widget = {
                type = "transmission";
                url = "http://localhost:9091";
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
              href = "http://curie:7878";
              widget = {
                type = "radarr";
                url = "http://curie:7878";
                key = "acfc274802fd46f8bbc5f1283f512259";
                enableQueue = true;
              };
            };
          }
          {
            "Sonarr" = {
              icon = "sonarr.png";
              description = "Automated TV show downloads";
              href = "http://curie:8989";
              widget = {
                type = "sonarr";
                url = "http://curie:8989";
                key = "03274698a7b14848938cf641cfd3b144";
              };
            };
          }
          {
            "Lidarr" = {
              icon = "lidarr.png";
              description = "Automated music downloads";
              href = "http://curie:8686";
              widget = {
                type = "lidarr";
                url = "http://curie:8686";
                key = "b310c4c8e6e142e2a0ef5d28e2efb89e";
              };
            };
          }
          {
            "Readarr" = {
              icon = "readarr.png";
              description = "Automated eBook and audiobook downloads";
              href = "http://curie:8787";
              widget = {
                type = "readarr";
                url = "http://curie:8787";
                key = "c56a8989505946bbb71f4b48ecf30b2d";
              };
            };
          }
          {
            "Prowlarr" = {
              icon = "prowlarr.png";
              description = "Index manager";
              href = "http://curie:9696";
              widget = {
                type = "prowlarr";
                url = "http://curie:9696";
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
