{pkgs, private, ...}: {
  services.xserver = {
    # Enable the X11 windowing system.
    # You can disable this if you're only using the Wayland session.
    enable = true;
    # Configure keymap in X11
    xkb = {
      layout = "us";
      variant = "";
    };
    # Enable touchpad support (enabled default in most desktopManager).
    #libinput.enable = true;
  };

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  
  # Gnome extensions
  environment.systemPackages = with pkgs; [
    ffmpegthumbnailer # for Nautilus previews
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-vaapi
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-bad
    #gst_all_1.icamerasrc-ipu6epmtl
    ghostty
    refine
  #  gnomeExtensions.dash-to-panel
  #  gnomeExtensions.removable-drive-menu
    gnomeExtensions.arcmenu
  #  gnomeExtensions.pano
  #  gnomeExtensions.espresso
  ];
}
