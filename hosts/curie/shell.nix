{ pkgs, ... }:
{
  users.users.root.shell = pkgs.fish;
  users.users.media.shell = pkgs.fish;

  programs.fish = {
    enable = true;
    shellAliases = {
      ls = "lsd --group-directories-first -al";
      cp = "cp -i";
      mv = "mv -i";
      rm = "rm -i";
      cat = "bat";
      df = "duf";
      nix-shell = "nix-shell --command fish";
    };
    shellAbbrs = {
      lg = "lazygit";

      addall = "git add .";
      branches = "git branch";
      commit = "git commit -m";
      remotes = "git remote";
      clone = "git clone";
      pull = "git pull origin";
      push = "git push origin";
      pushup = "git push -U origin main";
      stat = "git status";

      dev = "nix develop -c fish";
    };
  };

  programs.starship = {
    enable = true;
  };

  programs.command-not-found.enable = false;

  environment.systemPackages = [
    pkgs.duf
    pkgs.lsd
    pkgs.vim
    pkgs.git
    pkgs.bat
    pkgs.btop
    pkgs.helix
    pkgs.direnv
    pkgs.sendme
    pkgs.ripgrep
    pkgs.lazygit
  ];
}
