{pkgs, ...}: {
  # Firefox
  programs.librewolf = {
    #package = pkgs.librewolf;
    enable = false;
    # wrapperConfig = {
    #   pipewireSupport = true;
    # };
    nativeMessagingHosts = [
      pkgs.kdePackages.plasma-browser-integration
      pkgs.keepassxc
      #pkgs.jabref
    ];
    languagePacks = [
      "us"
      "cs-CZ"
    ];
    profiles = {
      Pers = {
        isDefault = true;
        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          plasma-integration
          keepassxc-browser
          darkreader
          firefox-color
        ];
        settings = {
          "widget.use-xdg-desktop-portal.file-picker" = 1;
        };
      };
    };
  };
}
