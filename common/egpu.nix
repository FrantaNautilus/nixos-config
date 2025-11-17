{ config, pkgs, ... }:
let
amdGpuBusId = "PCI:199:0:0";
nvidiaGpuBusId = "PCI:99:0:0";
in
{
  # 1. Allow unfree packages for the Nvidia driver
  #nixpkgs.config.allowUnfree = true;

  # 2. Authorize the USB 4.0 / Thunderbolt eGPU
  # This rule automatically authorizes any Thunderbolt device upon connection.
  #services.udev.extraRules = ''
  #  ACTION=="add|change", SUBSYSTEM=="thunderbolt", ATTR{authorized}="1"
  #'';

  # 3. Enable OpenGL
  #hardware.opengl = {
  #  enable = true;
  #  # driSupport = true; # deprecated
  #  # driSupport32Bit = true; # deprecated
  #};

  # 4. Configure Xorg/X11
  # Even for offload, the "nvidia" driver is recommended here as
  # the PRIME config will handle using the iGPU for display.
  services.xserver.videoDrivers = [
    "amdgpu"  # example for AMD iGPU; use "modesetting" here instead if your iGPU is Intel
    "nvidia"
  ];

  hardware.nvidia.powerManagement = {
    enable = true;
    finegrained = true;
  };
  
  services.switcherooControl.enable = true;

  # 5. Configure the Nvidia driver for PRIME Offload
  hardware.nvidia = {
    # Enable modesetting
    modesetting.enable = true;

    ## Use the "stable" driver package
    #package = config.boot.kernelPackages.nvidiaPackages.stable;

    # Configure PRIME
    prime = {
      # Enable the offload (on-demand) mode
      offload = {
        enable = true;
        # This creates the 'nvidia-offload' command
        enableOffloadCmd = true;
      };

      # This is crucial for an eGPU
      allowExternalGpu = true;

      # === !! IMPORTANT !! ===
      # Replace these values with the Bus IDs you found in Step 1
      amdgpuBusId = amdGpuBusId; # Your AMD iGPU
      nvidiaBusId = nvidiaGpuBusId; # Your Nvidia eGPU
    };
  };
}
