{ pkgs, ... }:
let
  dashboard = pkgs.runCommand "dashboard" { } ''
    mkdir -p $out
    cp ${./dashboard.html} $out/index.html
  '';
in
{
  services.caddy = {
    enable = true;
    virtualHosts.":80".extraConfig = ''
      root * ${dashboard}
      file_server
    '';
  };

  networking.firewall.allowedTCPPorts = [ 80 ];
}
