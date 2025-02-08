{ pkgs, ... }:
{
  users.users.root.shell = pkgs.fish;
  programs.fish = {
    enable = true;
  };

  programs.starship = {
    enable = true;
  };

  programs.command-not-found.enable = false;

  environment.systemPackages = [
    pkgs.duf
    pkgs.lsd
    pkgs.vim
    pkgs.btop
  ];
}
