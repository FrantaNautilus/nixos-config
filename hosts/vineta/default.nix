{
  config,
  pkgs,
  inputs,
  private,
  ...
}: let
  miractl = inputs.miractl.defaultPackage.x86_64-linux;
  hostname = "vineta";
  qemuUsers = private.qemuUsers;
  extraLocaleSettings = private.extraLocaleSettings;
  userName = private.userv.userName;
  userFullName = private.userv.userFullName;
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # Additional hardware specific configuration
    # https://github.com/NixOS/nixos-hardware
    #nixos-hardware.nixosModules.common-cpu-intel
    ../../common/nix.nix
    ../../common/nvidia-zephyrus.nix
    ../../common/kde.nix
    ../../common/virtualisation.nix
    ../../common/printer.nix
    (import ../../common/qemu.nix {inherit qemuUsers;})
    ../../common/sound.nix
    #../../common/stylix.nix
    ../../common/ai.nix
    ./packages.nix
  ];

  # Bootloader.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [
    "mitigations=off"
    "transparent_hugepage=always"
  ];
  #powerManagement.cpuFreqGovernor = "ondemand";


  networking.hostName = hostname;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = private.timeZone;

  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = extraLocaleSettings;

  # Udev rules
  services.udev.packages = [miractl];

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519"];
    secrets = {
      "github/oauth_token" = {};
      "gitlab/oauth_token" = {};
      "winapps_compose" = {
        owner = "${private.userv.userName}";
        path = "/home/${private.userv.userName}/.config/winapps/compose.yaml";
        sopsFile = ../../secrets/winapps.yaml;
      };
      "winapps_config" = {
        owner = "${private.userv.userName}";
        path = "/home/${private.userv.userName}/.config/winapps/winapps.conf";
        sopsFile = ../../secrets/winapps.yaml;
      };
      "qiskit-ibm" = {
        owner = "${private.userv.userName}";
        path = "/home/${private.userv.userName}/.qiskit/qiskit-ibm.json";
      };
      "pers-gitconfig" = {
        owner = "${private.userv.userName}";
        path = "/home/${private.userv.userName}/Pers/.gitconfig.inc";
      };
      "work-gitconfig" = {
        owner = "${private.userv.userName}";
        path = "/home/${private.userv.userName}/Work/.gitconfig.inc";
      };
      "fn-gitconfig" = {
        owner = "${private.userv.userName}";
        path = "/home/${private.userv.userName}/Fn/.gitconfig.inc";
      };
      "gitconfig" = {
        owner = "${private.userv.userName}";
        path = "/home/${private.userv.userName}/.gitconfig.inc";
      };
    };
  };

  users.users = {
    ${userName} = {
      name = userName;
      description = userFullName;
      isNormalUser = true;
      home = "/home/${userName}";
      extraGroups = ["networkmanager" "wheel" "docker"];
      #packages = with pkgs; [
      #];
    };
  };

  home-manager.extraSpecialArgs = {
    inherit inputs;
    private = private;
  };
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  #home-manager.backupFileExtension = "bak";
  home-manager.sharedModules = [
    inputs.plasma-manager.homeModules.plasma-manager
    #inputs.sops-nix.homeManagerModules.sops
  ];
  home-manager.users = {
    ${private.userv.userName} = import ./home-userv.nix;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  services.pipewire.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = false;
  };

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  services.flatpak.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_USE_XINPUT2 = "1";
  };
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # TODO: create a separate module for networking
  networking.firewall.enable = true;
  networking.wireguard.enable = true; # make sure the wireguard kernel module is present
  networking.firewall.checkReversePath = false; # required for WG


  networking.useNetworkd = true; # Required for resolved integration
  #networking.networkmanager.enable = true;

  services.resolved.enable = true;
  #services.resolved.dns = [ ]; # Let VPN config override this
  #services.resolved.dnsStubListener = "yes"; # keep system compatibility
  services.resolved.dnsovertls = "false";
  services.resolved.dnssec = "false";
  #networking.useDHCP = false;
  networking.interfaces.wlp2s0.useDHCP = true;

  #TODO: figure out how to make zRAM work
  #zramSwap = {
  #  enable = true;
  #  algorithms = "lz4";
  #  memoryPercent = 200;
  #  priority = 100;
  #};

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
