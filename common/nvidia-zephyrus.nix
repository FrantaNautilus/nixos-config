{pkgs, ...}: {
  # Nvidia
  # hardware.nvidia.open = false;
  hardware.nvidia.powerManagement = {
    enable = true;
    finegrained = true;
  };
  hardware.nvidia.nvidiaSettings = true;
  hardware.nvidia-container-toolkit = {
    enable = true;
  };

  systemd.services.nvidia-pre-suspend = {
    description = "Unload nvidia_uvm before suspend";
    before = [ "sleep.target" ];
    wantedBy = [ "sleep.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/run/current-system/sw/bin/modprobe -r nvidia_uvm";
      RemainAfterExit = false;
    };
  };

  systemd.services.nvidia-post-resume = {
    description = "Reload nvidia_uvm after resume";
    after = [ "sleep.target" ];
    wantedBy = [ "sleep.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/run/current-system/sw/bin/modprobe nvidia_uvm";
      RemainAfterExit = false;
    };
  };

  systemd.services.nvidia-pre-hibernate = {
    description = "Unload nvidia_uvm before hibernate";
    before = [ "hibernate.target" ];
    wantedBy = [ "hibernate.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/run/current-system/sw/bin/modprobe -r nvidia_uvm";
      RemainAfterExit = false;
    };
  };

  systemd.services.nvidia-post-hibernate = {
    description = "Reload nvidia_uvm after hibernate";
    after = [ "hibernate.target" ];
    wantedBy = [ "hibernate.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/run/current-system/sw/bin/modprobe nvidia_uvm";
      RemainAfterExit = false;
    };
  };

  # Add CUDA support
  nixpkgs.config.cudaSupport = true;
  nixpkgs.config.cudnnSupport = true;

  environment.systemPackages = with pkgs; [
    # Nvidia CUDA
    cudaPackages.cudnn
    cudaPackages.cutensor
    cudaPackages.libcublas
    cudaPackages.libcusparse
    cudaPackages.libcusolver
    cudaPackages.libcurand
    cudaPackages.cuda_gdb
    cudaPackages.cuda_nvcc
    cudaPackages.cuda_cudart
    # https://github.com/nix-community/nix-ld?tab=readme-ov-file#my-pythonnodejsrubyinterpreter-libraries-do-not-find-the-libraries-configured-by-nix-ld
    (pkgs.writeShellScriptBin "python" ''
      export LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH
      export CC=${pkgs.gcc}/bin/gcc
      exec ${pkgs.python311}/bin/python "$@"
    '')
    (pkgs.writeShellScriptBin "uv" ''
      export LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH
      export CC=${pkgs.gcc}/bin/gcc
      exec ${pkgs.uv}/bin/uv "$@"
    '')
  ];
  
  environment.sessionVariables = {
    CC = "${pkgs.gcc}/bin/gcc";
  };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc
      stdenv.cc.cc.lib
      gcc
      zlib
      zstd
      curl
      openssl
      attr
      libssh
      bzip2
      libxml2
      acl
      libsodium
      util-linux
      xz
      systemd
      # Nvidia
      cudaPackages.cudnn
      cudaPackages.cutensor
      cudaPackages.libcublas
      cudaPackages.libcusparse
      cudaPackages.libcusolver
      cudaPackages.libcurand
      cudaPackages.cuda_gdb
      cudaPackages.cuda_nvcc
      cudaPackages.cuda_cudart
    ];
  };
  
  services = {
    envfs = {
      enable = true;
    };
  };
}
