{ pkgs, ... }:
{
  home.file = {
    ".config/hypr" = {
      source = ./files/hypr;
    };
    "wallpapers" = {
      source = ./files/wallpapers;
    };
  };

  programs.firefox.enable = true;

  programs.mpv = {
    enable = true;
    scripts = [ pkgs.mpvScripts.mpris ];
  };

  home.packages = with pkgs; [ playerctl ];

  services.playerctld = {
    enable = true;
  };

  programs.alacritty = {
    enable = true;
    settings = {
      window.padding = {
        x = 10;
        y = 10;
      };

      font.size = 16.0;
      font.bold.family = "FiraCode Nerd Font";
      font.italic.family = "FiraCode Nerd Font";
      font.normal.family = "FiraCode Nerd Font";

      # Colors (Ayu Dark)
      colors = {
        primary = {
          background = "#000000";
          foreground = "#B3B1AD";
        };
        normal = {
          black = "#01060E";
          red = "#EA6C73";
          green = "#91B362";
          yellow = "#F9AF4F";
          blue = "#53BDFA";
          magenta = "#FAE994";
          cyan = "#90E1C6";
          white = "#C7C7C7";
        };
        bright = {
          black = "#686868";
          red = "#F07178";
          green = "#C2D94C";
          yellow = "#FFB454";
          blue = "#59C2FF";
          magenta = "#FFEE99";
          cyan = "#95E6CB";
          white = "#FFFFFF";
        };
      };
    };
  };

  home.sessionVariables = {
    SHELL = "fish";
    TERMINAL = "alacritty";
  };

  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
