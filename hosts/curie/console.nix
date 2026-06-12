{
  lib,
  pkgs,
  ...
}:
{
  # Show btop on the laptop screen; a normal login is still on tty2+ (Alt+F2).
  boot.kernelParams = [ "consoleblank=0" ];

  # logind spawns autovt@tty1 even with getty@tty1 off; mask both.
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  systemd.services.btop-tty1 = {
    description = "btop system monitor on tty1";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-user-sessions.service" ];
    serviceConfig = {
      ExecStart = lib.getExe pkgs.btop;
      Type = "idle";
      Restart = "always";
      RestartSec = 2;
      StandardInput = "tty";
      StandardOutput = "tty";
      TTYPath = "/dev/tty1";
      TTYReset = true;
      TTYVHangup = true;
      TTYVTDisallocate = true;
      Environment = [
        "TERM=linux"
        "HOME=/root"
        # btop refuses to start without a UTF-8 locale
        "LANG=en_US.UTF-8"
      ];
    };
  };
}
