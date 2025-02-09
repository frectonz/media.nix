{  ... }:
let
  vars = import ./variables.nix;
in
{
  services.homepage-dashboard = {
    enable = true;
    listenPort = 80;

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
        "Jellyfin" = [
          {
            "Jellyfin" = {
              icon = "jellyfin.png";
              description = "Media streaming";
              href = "http://${vars.ip}:8096";
            };
          }
        ];
      }
    ];
  };
}
