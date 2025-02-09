{
  pkgs,
  flake,
  inputs,
  ...
}:
{
  imports = [
    ./nix.nix
    ./shell.nix
    ./sound.nix
    ./nixarr.nix
    ./openssh.nix
    ./hyprland.nix
    ./dashboard.nix
    ./hardware-configuration.nix

    inputs.nixarr.nixosModules.default
    inputs.home-manager.nixosModules.home-manager
  ];

  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keyFiles = [
    "${flake}/users/frectonz/authorized_keys"
  ];

  users.users.media = {
    isNormalUser = true;
    description = "media";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = [ ];
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.root = import ./home.nix;
  home-manager.users.media = import ./home.nix;
  home-manager.backupFileExtension = "backup";

  nixpkgs.config.allowUnfree = true;

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "curie";
  networking.networkmanager.enable = true;

  time.timeZone = "Africa/Addis_Ababa";

  fonts.packages = with pkgs; [ nerd-fonts.fira-code ];

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Used by NixOS to handle state changes.
  system.stateVersion = "24.11";
}
