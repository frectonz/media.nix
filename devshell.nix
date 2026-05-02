{ pkgs }:
let
  vars = import ./hosts/curie/variables.nix;
  connection = "root@${vars.ip}";

  login = pkgs.writeShellApplication {
    name = "server-login";
    text = ''
      ssh -i .ssh/id_ed25519 ${connection}
    '';
  };

  switch = pkgs.writeShellApplication {
    name = "server-switch";
    text = ''
      nh os switch .#curie --target-host ${connection} --build-host ${connection} --elevation-strategy none
    '';
  };
in
pkgs.mkShell {
  packages = [
    pkgs.nh
    pkgs.nixos-rebuild
    login
    switch
  ];

  NIX_SSHOPTS = "-i .ssh/id_ed25519";
}
