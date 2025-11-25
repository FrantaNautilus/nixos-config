{pkgs, ...}:
let
   # Change according to the driver used: stable, beta
   nvidiaPackage = pkgs.linuxPackages_latest.nvidiaPackages.stable;
   allCudaPackages = with pkgs; [
     # Nvidia CUDA
     cudaPackages.cudatoolkit
     cudaPackages.cudnn
     cudaPackages.libcutensor
     cudaPackages.libcublas
     cudaPackages.libcusparse
     cudaPackages.libcusolver
     cudaPackages.libcurand
     cudaPackages.cuda_gdb
     cudaPackages.cuda_nvcc
     cudaPackages.cuda_cudart
   ];
in
{
  boot.initrd.availableKernelModules = [
    "nvidia"
    "nvidia_uvm"
    "nvidia_modeset"
    "nvidia_drm"
  ];
  
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
      #nvidiaPackages.stable.vulkan-driver
    ];
    #extraPackages32 = [ pkgs.pkgsi686.nvidiaPackages.stable.vulkan-driver ];
  };
  
  # Nvidia
  hardware.nvidia = {
    open = true;
    #powerManagement = {
    #  enable = true;
    #  finegrained = true;
    #};
    nvidiaSettings = true;
    #nvidia-container-toolkit = {
    #  enable = true;
    #};
    package = nvidiaPackage;
  };
  services.xserver.videoDrivers = [ "nvidia" ];

  # Add CUDA support
  nixpkgs.config.cudaSupport = true;
  nixpkgs.config.cudnnSupport = true;

  environment.variables = {
    CUDA_PATH="${pkgs.cudatoolkit}";
    EXTRA_LDFLAGS="-L/lib -L${nvidiaPackage}/lib";
    EXTRA_CCFLAGS="-I/usr/include";
  };

  environment.systemPackages = allCudaPackages; 
  #with pkgs; [ 
    # https://github.com/nix-community/nix-ld?tab=readme-ov-file#my-pythonnodejsrubyinterpreter-libraries-do-not-find-the-libraries-configured-by-nix-ld
    #(pkgs.writeShellScriptBin "python" ''
    #  export LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH
    #  export CC=${pkgs.gcc}/bin/gcc
    #  exec ${pkgs.python312}/bin/python "$@"
    #'')
    #(pkgs.writeShellScriptBin "uv" ''
    #  export LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH
    #  export CC=${pkgs.gcc}/bin/gcc
    #  exec ${pkgs.uv}/bin/uv "$@"
    #'')
  #];

  programs.nix-ld = {
    enable = true;
    libraries = allCudaPackages;
  };
}
