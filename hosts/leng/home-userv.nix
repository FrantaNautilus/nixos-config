{
  config,
  pkgs,
  private,
  ...
}: let
  #hostname = "vineta";
  #qemuUsers = private.qemuUsers;
  #extraLocaleSettings = private.extraLocaleSettings;
  userName = private.userv.userName;
  #userFullName = private.userv.userFullName;
in {
  home.username = userName;
  home.homeDirectory = "/home/${userName}";

  # set cursor size and dpi for 4k monitor
  # xresources.properties = {
  #   "Xcursor.size" = 16;
  #   "Xft.dpi" = 172;
  # };
  # sops = {
  #   age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  #   defaultSopsFile = ../../secrets/secrets.yaml;
  #   #defaultSymlinkPath = "/run/user/1000/secrets";
  #   #defaultSecretsMountPoint = "/run/user/1000/secrets.d";

  #   secrets = {
  #     "qiskit-ibm" = {
  #       #owner = "${private.userv.userName}";
  #     };
  #     "pers-gitconfig" = {
  #       #owner = "${private.userv.userName}";
  #     };
  #     "work-gitconfig" = {
  #       #owner = "${private.userv.userName}";
  #     };
  #     "fn-gitconfig" = {
  #       #owner = "${private.userv.userName}";
  #     };
  #     "gitconfig" = {
  #       #owner = "${private.userv.userName}";
  #     };
  #   };
  # };
  # Packages that should be installed to the user profile.
  imports = [
    ../../home/userv/git.nix
    ../../home/userv/terminal.nix
    ../../home/userv/browser.nix
    ../../home/userv/vscode.nix
    ../../home/userv/packages.nix
    ../../home/userv/tex.nix
    ../../home/userv/gnome.nix
    ../../home/shell/shell.nix
    ../../private/userv-ssh.nix
    ../../home/shell/tui-tools.nix
    #../../home/kde/packages-kde.nix
    #../../home/userv/winapps.nix
  ];

  # XDG config
  #xdg.portal = {
  #  enable = true;
  #  extraPortals = [
  #    pkgs.xdg-desktop-portal-kde
  #    # pkgs.xdg-desktop-portal-gtk
  #  ];
  #  xdgOpenUsePortal = true;
  #};

  # home.file = {
  #   ".qiskit/qiskit-ibm.json" = {
  #     enable = true;
  #     source = config.sops.secrets."qiskit-ibm".path;
  #   };
  #   "Pers/.gitconfig.inc" = {
  #     enable = true;
  #     source = config.sops.secrets."pers-gitconfig".path;
  #   };
  #   "Work/.gitconfig.inc" = {
  #     enable = true;
  #     source = config.sops.secrets."work-gitconfig".path;
  #   };
  #   "Fn/.gitconfig.inc" = {
  #     enable = true;
  #     source = config.sops.secrets."fn-gitconfig".path;
  #   };
  #   ".gitconfig.inc" = {
  #     enable = true;
  #     source = config.sops.secrets."gitconfig".path;
  #   };
  # };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  
  home.stateVersion = "25.05";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
