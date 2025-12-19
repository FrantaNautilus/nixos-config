{ config, pkgs, ... }:
let
amdGpuBusId = "PCI:199:0:0";
nvidiaGpuBusId = "PCI:99:0:0";
in
{
  # 1. Allow unfree packages for the Nvidia driver
  #nixpkgs.config.allowUnfree = true;

  # 2. Authorize the USB 4.0 / Thunderbolt eGPU
  #boot.kernelModules = [
  #  "thunderbolt"
  #];
  services.hardware.bolt = {
    enable = true;
    #authorize = "auto";  # auto-authorize attached GPUs
  };
  # This rule automatically authorizes any Thunderbolt device upon connection.
  #services.udev.extraRules = ''
  #  ACTION=="add|change", SUBSYSTEM=="thunderbolt", ATTR{authorized}="1"
  #'';
  
  services.udev.extraRules = ''
    # When the Nvidia PCI device is added, run nvidia-modprobe to create /dev/nvidia-uvm
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030000", RUN+="${pkgs.nvidia-modprobe}/bin/nvidia-modprobe -c0 -u"
  '';

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
  
  services.switcherooControl.enable = true;
  
  #environment.sessionVariables = {
  #  
  #};

  # 5. Configure the Nvidia driver for PRIME Offload
  # hardware.usb4.enable = true; # Hallucination
  hardware.nvidia = {
    # Enable modesetting
    modesetting.enable = true;
    powerManagement = {
      enable = true;
      finegrained = true;
    };
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
  # 7. Helper Script for Safe Removal
  # "Hot Unplug" is dangerous. You must unload the driver manually 
  # BEFORE pulling the cable to avoid a kernel panic.
  environment.systemPackages = [
    pkgs.nvidia-modprobe
    (pkgs.writeShellScriptBin "egpu-prepare-removal" ''
      echo "Stopping services accessing the GPU..."
      
      # Kill any stray processes using the Nvidia card
      # (Requires lsof or fuser, but nvidia-smi can sometimes do it)
      if command -v fuser >/dev/null; then
         sudo fuser -k -v /dev/nvidia*
      fi
      
      echo "Unloading Nvidia kernel modules..."
      sudo rmmod nvidia_drm
      sudo rmmod nvidia_modeset
      sudo rmmod nvidia_uvm
      sudo rmmod nvidia
      
      if [ $? -eq 0 ]; then
        echo "SUCCESS: You can now safely unplug the eGPU."
      else
        echo "ERROR: Could not unload modules. Check 'nvidia-smi' for stuck processes."
      fi
    '')
  ];
}
