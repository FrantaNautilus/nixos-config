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
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  #services.displayManager.gdm.enable = true;
  #services.desktopManager.gnome.enable = true;
  
  # Gnome extensions
  environment.systemPackages = with pkgs; [
    ghostty
  #  gnomeExtensions.dash-to-panel
  #  gnomeExtensions.removable-drive-menu
    gnomeExtensions.arcmenu
  #  gnomeExtensions.pano
  #  gnomeExtensions.espresso
  ];
}
