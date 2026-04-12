{
  flake,
  inputs,
  ...
}:
{
  imports = [
    ./nix.nix
    ./shell.nix
    ./nixarr.nix
    ./openssh.nix
    ./dashboard.nix
    ./hardware-configuration.nix

    inputs.nur.modules.nixos.default
    inputs.nixarr.nixosModules.default
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

  nixpkgs.config.allowUnfree = true;

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "curie";
  networking.networkmanager.enable = true;

  time.timeZone = "Africa/Addis_Ababa";

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

  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchDocked = "ignore";
    HandleLidSwitchExternalPower = "ignore";
  };

  # Used by NixOS to handle state changes.
  system.stateVersion = "24.11";
}
