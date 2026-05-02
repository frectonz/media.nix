{ flake, ... }:
{
  imports = [
    flake.inputs.nix-index-database.nixosModules.nix-index
  ];

  programs.nix-index-database.comma.enable = true;
}
