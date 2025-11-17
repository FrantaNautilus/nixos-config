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

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  # Enable KDE suite - parts managed by nixOS not HM
  programs.kde-pim = {
    enable = true;
    kmail = true;
    kontact = true;
    merkuro = true;
  };
  programs.partition-manager = {
    enable = true;
    #package = pkgs.kdePackages.partitionmanager;
  };
  programs.kdeconnect = {
    enable = true;
    #package = pkgs.kdePackages.kdeconnect-kde;
  };
  environment.systemPackages = with pkgs; [
    # KDE
    supergfxctl-plasmoid
    application-title-bar
    kdePackages.kdepim-addons

    kdePackages.akonadi
    kdePackages.akonadi-mime
    #kdePackages.akonadi-notes
    kdePackages.akonadi-search
    kdePackages.akonadi-contacts
    kdePackages.akonadi-calendar
    kdePackages.akonadi-import-wizard
    kdePackages.akonadi-calendar-tools
    kdePackages.akonadiconsole
    kdePackages.kdepim-runtime
    kdePackages.messagelib
    kdePackages.qtsvg
    kdePackages.kwallet
    kwalletcli
    kdePackages.kwalletmanager
    kdePackages.kwallet-pam
    kdePackages.signon-kwallet-extension
  ];
  programs.ssh = {
    startAgent = true;
    enableAskPassword = true;
    askPassword = pkgs.lib.mkForce "${pkgs.kdePackages.ksshaskpass.out}/bin/ksshaskpass";
  };
  environment.variables = {
    SSH_ASKPASS_REQUIRE = "prefer";
  };
  # stylix.targets.qt = {
  #   enable = true;
  #   platform = "kde";
  # };

  security.pam.services.${private.userv.userName}.kwallet.enable = true;
}
