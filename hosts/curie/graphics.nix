{ pkgs, ... }:
{
  # VAAPI for Intel HD 4000 (Ivy Bridge / Gen 7).
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-vaapi-driver # i965 — correct for Ivy Bridge
      intel-media-driver # iHD — harmless extra, future-proof
      libvdpau-va-gl
    ];
  };

  # Force i965; iHD doesn't support HD 4000 and would otherwise auto-pick.
  environment.sessionVariables.LIBVA_DRIVER_NAME = "i965";

  # Let the jellyfin user touch /dev/dri/renderD128.
  users.users.jellyfin.extraGroups = [
    "render"
    "video"
  ];
}
