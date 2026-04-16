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

  systemd.services.dufs = {
    description = "Dufs file server";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.dufs}/bin/dufs / -p 5000 -A";
      Restart = "on-failure";
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    5000
  ];
}
