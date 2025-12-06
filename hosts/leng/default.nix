{
  lib,
  config,
  pkgs,
  inputs,
  private,
  ...
}: let
  miractl = inputs.miractl.defaultPackage.x86_64-linux;
  hostname = "leng";
  qemuUsers = private.qemuUsers;
  extraLocaleSettings = private.extraLocaleSettings;
  userName = private.userv.userName;
  userFullName = private.userv.userFullName;
  amdGpuPciPath = "0000:c7:00.0";
  nvidiaGpuPciPath = "0000:63:00.0";
  amdGpuFullDevPath = "/devices/pci0000:00/0000:00:08.1/0000:c7:00.0/drm/card1";
  nvidiaGpuFullDevPath = "/devices/pci0000:00/0000:00:01.2/0000:61:00.0/0000:62:00.0/0000:63:00.0/drm/card0";
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # Additional hardware specific configuration
    # https://github.com/NixOS/nixos-hardware
    ../../common/nix.nix
    ../../common/fhs_compat.nix
    ../../common/rocm.nix
    ../../common/nvidia.nix
    ../../common/egpu.nix
    ../../common/gnome.nix
    ../../common/virtualisation.nix
    ../../common/printer.nix
    (import ../../common/qemu.nix {inherit qemuUsers;})
    ../../common/sound.nix
    #../../common/stylix.nix
    #../../common/ai.nix
    ./packages.nix
  ];
  #nixpkgs.overlays = [
  #  (final: super: {
  #    makeModulesClosure = x:
  #    super.makeModulesClosure (x // { allowMissing = true; });
  #  })
  #];
  # Bootloader.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  #boot.kernelPackages = pkgs.linuxPackages_testing;
  #boot.kernelPackages = pkgs.linuxPackages_6_6;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [
    "mitigations=off"
    "transparent_hugepage=always"
    "acpi_enforce_resources=lax"
    #"acpi_osi=!acpi_osi=\"Windows 2009\"" # Emulate Win7
    "acpi_osi=!\"acpi_osi=Windows 2015\"" # Emulate Win10
    # "acpi_osi=Linux" # Rarely works, but worth a try
    #"microcode.amd_sha_check=off"
    "amd_iommu=on"
    "amdgpu.cwsr_enable=0"
    "amdgpu.no_system_mem_limit=1"
    #"amdgpu.mcbp=0"
    #"amdgpu.runpm=0"
    #"amdgpu.mes=0" # amdgpu 0000:c7:00.0: amdgpu: MES failed to respond to msg=REMOVE_QUEUE
    "amdgpu.gpu_recovery=1"
    #"iommu=pt"
    "iommu=soft"
    #"mem_sleep_default=deep"
    "mem_sleep_default=s2idle"
    # Kernel params set according to https://github.com/kyuz0/amd-strix-halo-toolboxes
    #"amd_iommu=off"
    #"amdgpu.gttsize=131072"
    #"ttm.pages_limit=33554432"
    #"ttm.page_pool_size=33554432"
    #7/8
    "amdgpu.gttsize=114688"
    "ttm.pages_limit=29360128"
    "ttm.page_pool_size=29360128"
    #"acpi_sleep=nonvs"
    #"pci=no_d3_delay"
  ];
  #boot.initrd.kernelModules = [ "r8152" "mt7925e" ];
  # it87 according to https://discourse.nixos.org/t/best-way-to-handle-boot-extramodulepackages-kernel-module-conflict/30729
  boot.kernelModules = [
    #"coretemp"
    "it87"
    #"it87.force_id=0x8623" # it87: force chip id
    #"r8152"
    #"mt7925e"
  ];
  
  # default nixos behavior is to error if a kernel module is provided by more than one package.
  # but we're doing that intentionally, so inline the `pkgs.aggregateModules` call from 
  # <nixos/modules/system/boot/kernel.nix> but configured for out-of-tree modules to override in-tree ones
  #system.modulesTree = lib.mkForce [(
  #  (pkgs.aggregateModules
  #    # The list order matters: extraModulePackages comes FIRST
  #    ( config.boot.extraModulePackages ++ [ config.boot.kernelPackages.kernel.modules ] )
  #  ).overrideAttrs {
  #    # This allows your it87.ko.xz to override the in-kernel one
  #    ignoreCollisions = true;
  #  })
  #];
  #boot.extraModulePackages = with config.boot.kernelPackages; [
  # #it87
  # (it87.overrideAttrs (super: {
  #    postInstall = (super.postInstall or "") + ''
  #      find $out -name '*.ko' -exec xz {} \;
  #    '';
  # }))
  #];
  boot.extraModprobeConfig = ''
    options it87 force_id=0x8603 ignore_resource_conflict=1
  '';
  #powerManagement.resumeCommands = ''
  #  ${pkgs.kmod}/bin/modprobe -r mt7925e
  #  ${pkgs.kmod}/bin/modprobe mt7925e
  #'';
  
  
  #hardware.enableRedistributableFirmware = true;
  hardware.enableAllFirmware = true;
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

  users.users = {
    ${userName} = {
      name = userName;
      description = userFullName;
      isNormalUser = true;
      home = "/home/${userName}";
      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
        "render"
        "video"
      ];
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
    #inputs.plasma-manager.homeModules.plasma-manager
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
  environment.variables = {
    #SSH_ASKPASS_REQUIRE = "prefer";
    SSH_ASKPASS = pkgs.lib.mkForce "${pkgs.gcr_4}/libexec/gcr-ssh-askpass";
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
  networking.interfaces.wlp193s0.useDHCP = true;
  
  # Fix fan speed
  services.udev.extraRules = ''
    # Automatically authorize the eGPU
    #ACTION=="add|change", SUBSYSTEM=="thunderbolt", ATTR{authorized}="1"
    ACTION=="remove", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", RUN+="${pkgs.kmod}/bin/modprobe -r nvidia_drm nvidia_modeset nvidia_uvm nvidia"
    
    # Add rule for NVIDIA power management
    #ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030000", ATTR{power/control}="auto"
    #ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030200", ATTR{power/control}="auto"

    # === GNOME/GDM PRIMARY GPU FIX ===
    # Tag the internal AMD iGPU as the primary device for Mutter (Wayland)
    #SUBSYSTEM=="drm", KERNEL=="card*", DEVPATH=="*/${amdGpuPciPath}/drm/card*", TAG+="mutter-device-preferred-primary"
    SUBSYSTEM=="drm", KERNEL=="card*", DEVPATH=="${amdGpuFullDevPath}", TAG+="mutter-device-preferred-primary"

    # (Optional) Explicitly untag the eGPU to be safe
    #SUBSYSTEM=="drm", KERNEL=="card*", DEVPATH=="*/${nvidiaGpuPciPath}/drm/card*", TAG-="mutter-device-preferred-primary"
    SUBSYSTEM=="drm", KERNEL=="card*", DEVPATH=="${nvidiaGpuFullDevPath}", TAG-="mutter-device-preferred-primary"
    
    # Enable fan control
    SUBSYSTEM=="hwmon", RUN+="${pkgs.bash}/bin/bash -c 'chmod a+w /sys%p/pwm* || true'"
  '';
  
  systemd.services.ModemManager.enable = false;
  
  services.ucodenix = {
    enable = false;
    # cpuid -1 -l 1 -r | sed -n 's/.*eax=0x\([0-9a-f]*\).*/\U\1/p'
    cpuModelId = "00B70F00"; # Replace with your processor's model ID
  };
  
  services.acpid = {
    enable = true;
  };
  
  hardware.fancontrol = {
    enable = true;
    config = builtins.readFile(./pwmconfig.txt);
  };
  
  services.ollama = {
    enable = false;
    package = pkgs.ollama-vulkan;
    acceleration = "rocm";
    #user = "hudecvl199";
    home = "/home/hudecvl199/.ollama";
    #environmentVariables = {
    #  HCC_AMDGPU_TARGET = "gfx1031"; # used to be necessary, but doesn't seem to anymore
    #};
    # results in environment variable "HSA_OVERRIDE_GFX_VERSION=10.3.0"
    #rocmOverrideGfx = "10.3.0";
  };
  
  ## Force AMD iGPU as Primary Renderer
  # This tells the GLX/EGL stack to default to the Mesa driver (AMD/Intel)
  # instead of the Nvidia driver.
  #environment.sessionVariables = {
  #  __GLX_VENDOR_LIBRARY_NAME = "mesa";
  #};
  
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
  system.stateVersion = "25.05"; # Did you read the comment?
}
