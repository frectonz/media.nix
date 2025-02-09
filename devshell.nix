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
      nixos-rebuild --flake .#curie --target-host ${connection} --build-host ${connection} switch
    '';
  };
in
pkgs.mkShell {
  packages = [ login switch ];
}
