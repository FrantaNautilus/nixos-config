{
  config,
  private,
  ...
}: let
  #hostname = "vineta";
  #qemuUsers = private.qemuUsers;
  #extraLocaleSettings = private.extraLocaleSettings;
  userName = private.userv.userName;
  #userFullName = private.userv.userFullName;
  sops = config.home-manager.users.${private.userv.userName}.sops;
in {
  sops.secrets = {
    "winapps_compose" = {
      #owner = "${private.userv.userName}";
      #path = "/home/${private.userv.userName}/.config/winapps/compose.yaml";
      sopsFile = ../../secrets/winapps.yaml;
    };
    "winapps_config" = {
      #owner = "${private.userv.userName}";
      path = "/home/${private.userv.userName}/.config/winapps/winapps.conf";
      sopsFile = ../../secrets/winapps.yaml;
    };
  };
  xdg.configFile = {
    "winapps/winapps.conf" = {
      enable = true;
      source = sops.secrets."winapps_config".path;
    };
    "winapps/compose.yaml" = {
      enable = true;
      source = sops.secrets."winapps_compose".path;
    };
  };
}
