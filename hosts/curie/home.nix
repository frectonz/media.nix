{ ... }:
{
  home.file = {
    ".config/hypr" = {
      source = ./files/hypr;
    };
    "wallpapers" = {
      source = ./files/wallpapers;
    };
  };

  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
