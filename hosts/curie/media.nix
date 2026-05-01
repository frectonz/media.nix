{
  lib,
  pkgs,
  perSystem,
  ...
}:
let
  mediaDir = "/data/media";
  stateDir = "${mediaDir}/.state/nixarr";

  jellyfinDir = "${stateDir}/jellyfin";
  sonarrDir = "${stateDir}/sonarr";
  radarrDir = "${stateDir}/radarr";
  lidarrDir = "${stateDir}/lidarr";
  readarrDir = "${stateDir}/readarr";
  prowlarrDir = "${stateDir}/prowlarr";
  jellyseerrDir = "${stateDir}/jellyseerr";
  transmissionDir = "${stateDir}/transmission";
  torrentsDir = "${mediaDir}/torrents";

  # UIDs/GIDs match nixarr so existing on-disk file ownership stays valid.
  uids = {
    jellyfin = 146;
    sonarr = 274;
    radarr = 275;
    lidarr = 306;
    readarr = 250;
    transmission = 70;
    prowlarr = 293;
    jellyseerr = 262;
  };
  gids = {
    media = 169;
    prowlarr = 287;
    jellyseerr = 250;
  };
in
{
  users.groups = {
    media.gid = gids.media;
    prowlarr.gid = gids.prowlarr;
    jellyseerr = {
      gid = gids.jellyseerr;
    };
  };

  users.users = {
    jellyfin = {
      isSystemUser = true;
      group = "media";
      uid = uids.jellyfin;
    };
    sonarr.uid = uids.sonarr;
    radarr.uid = uids.radarr;
    lidarr.uid = uids.lidarr;
    readarr = {
      isSystemUser = true;
      group = "media";
      uid = uids.readarr;
      home = readarrDir;
    };
    transmission.uid = uids.transmission;
    prowlarr = {
      isSystemUser = true;
      group = "prowlarr";
      uid = uids.prowlarr;
    };
    jellyseerr = {
      isSystemUser = true;
      group = "jellyseerr";
      uid = uids.jellyseerr;
    };
  };

  systemd.tmpfiles.rules = [
    # Media root
    "d '${mediaDir}'            0775 root         media - -"

    # Service state dirs
    "d '${jellyfinDir}'         0700 jellyfin     root - -"
    "d '${jellyfinDir}/log'     0700 jellyfin     root - -"
    "d '${jellyfinDir}/cache'   0700 jellyfin     root - -"
    "d '${jellyfinDir}/data'    0700 jellyfin     root - -"
    "d '${jellyfinDir}/config'  0700 jellyfin     root - -"
    "d '${sonarrDir}'           0700 sonarr       media - -"
    "d '${radarrDir}'           0700 radarr       media - -"
    "d '${lidarrDir}'           0700 lidarr       media - -"
    "d '${readarrDir}'          0700 readarr      root - -"
    "d '${prowlarrDir}'         0700 prowlarr     root - -"
    "d '${jellyseerrDir}'       0700 jellyseerr   root - -"
    "d '${transmissionDir}'                             0750 transmission media - -"
    "d '${transmissionDir}/.config'                     0750 transmission media - -"
    "d '${transmissionDir}/.config/transmission-daemon' 0750 transmission media - -"

    # Media library
    "d '${mediaDir}/library'             0775 root media - -"
    "d '${mediaDir}/library/shows'       0775 root media - -"
    "d '${mediaDir}/library/movies'      0775 root media - -"
    "d '${mediaDir}/library/music'       0775 root media - -"
    "d '${mediaDir}/library/books'       0775 root media - -"
    "d '${mediaDir}/library/audiobooks'  0775 root media - -"

    # Torrents
    "d '${torrentsDir}'             0755 transmission media - -"
    "d '${torrentsDir}/.incomplete' 0755 transmission media - -"
    "d '${torrentsDir}/.watch'      0755 transmission media - -"
    "d '${torrentsDir}/manual'      0755 transmission media - -"
    "d '${torrentsDir}/lidarr'      0755 transmission media - -"
    "d '${torrentsDir}/radarr'      0755 transmission media - -"
    "d '${torrentsDir}/sonarr'      0755 transmission media - -"
    "d '${torrentsDir}/readarr'     0755 transmission media - -"
  ];

  services.jellyfin = {
    enable = true;
    user = "jellyfin";
    group = "media";
    openFirewall = true;
    dataDir = "${jellyfinDir}/data";
    configDir = "${jellyfinDir}/config";
    cacheDir = "${jellyfinDir}/cache";
    logDir = "${jellyfinDir}/log";
  };
  systemd.services.jellyfin.serviceConfig.IOSchedulingPriority = 0;

  services.sonarr = {
    enable = true;
    user = "sonarr";
    group = "media";
    openFirewall = true;
    dataDir = sonarrDir;
  };

  services.radarr = {
    enable = true;
    user = "radarr";
    group = "media";
    openFirewall = true;
    dataDir = radarrDir;
  };

  services.lidarr = {
    enable = true;
    user = "lidarr";
    group = "media";
    openFirewall = true;
    dataDir = lidarrDir;
  };

  services.readarr = {
    enable = true;
    user = "readarr";
    group = "media";
    openFirewall = true;
    dataDir = readarrDir;
  };

  services.prowlarr = {
    enable = true;
    openFirewall = true;
  };
  # Setting User/Group to a real user disables DynamicUser; force ExecStart so
  # prowlarr writes to the existing state path on /data/media. nixpkgs's
  # StateDirectory=prowlarr stays — it just creates an unused /var/lib/prowlarr.
  systemd.services.prowlarr.serviceConfig = {
    User = "prowlarr";
    Group = "prowlarr";
    ExecStart = lib.mkForce "${lib.getExe pkgs.prowlarr} -nobrowser -data=${prowlarrDir}";
    ReadWritePaths = [ prowlarrDir ];
  };

  # Jellyseerr unit — mirrors nixarr's: fixed user, custom CONFIG_DIRECTORY,
  # uses pkgs.seerr (the maintained fork).
  systemd.services.jellyseerr = {
    description = "Jellyseerr, a requests manager for Jellyfin";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    environment = {
      PORT = "5055";
      CONFIG_DIRECTORY = jellyseerrDir;
    };
    serviceConfig = {
      Type = "exec";
      StateDirectory = "jellyseerr";
      DynamicUser = false;
      User = "jellyseerr";
      Group = "jellyseerr";
      ExecStart = lib.getExe pkgs.seerr;
      Restart = "on-failure";

      ProtectHome = true;
      PrivateTmp = true;
      PrivateDevices = true;
      ProtectHostname = true;
      ProtectClock = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectKernelLogs = true;
      ProtectControlGroups = true;
      NoNewPrivileges = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      RemoveIPC = true;
      PrivateMounts = true;
      ProtectSystem = "strict";
      ReadWritePaths = [ jellyseerrDir ];
    };
  };
  networking.firewall.allowedTCPPorts = [ 5055 ];

  services.transmission = {
    enable = true;
    package = pkgs.transmission_4;
    user = "transmission";
    group = "media";
    home = transmissionDir;
    openPeerPorts = true;
    openRPCPort = true;
    settings = {
      download-dir = torrentsDir;
      incomplete-dir-enabled = true;
      incomplete-dir = "${torrentsDir}/.incomplete";
      watch-dir-enabled = true;
      watch-dir = "${torrentsDir}/.watch";

      umask = "002";

      rpc-bind-address = "0.0.0.0";
      rpc-port = 9091;
      rpc-whitelist-enabled = true;
      rpc-whitelist = "127.0.0.1,192.168.*,10.*,100.*.*.*";
      rpc-host-whitelist = "curie";
      rpc-authentication-required = false;

      blocklist-enabled = true;
      blocklist-url = "https://github.com/Naunter/BT_BlockLists/raw/master/bt_blocklists.gz";

      peer-port = 50000;
      dht-enabled = true;
      pex-enabled = true;
      utp-enabled = false;
      encryption = 1;
      port-forwarding-enabled = false;

      anti-brute-force-enabled = true;
      anti-brute-force-threshold = 10;

      message-level = 3;
    };
  };
  systemd.services.transmission.serviceConfig.IOSchedulingPriority = 7;

  services.flaresolverr = {
    enable = true;
    package = perSystem.self.flaresolverr-21hsmw;
  };
}
