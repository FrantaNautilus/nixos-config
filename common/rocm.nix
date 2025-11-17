{pkgs, ...}: 
  let
    rocmAllPackages = with pkgs.rocmPackages; [
        # Core ROCm
        rocm-runtime
        rocm-device-libs
        rocm-core
        rocm-cmake
        rocm-smi
        rocminfo
        clr
        clr.icd

        # Basic HIP tools
        hip-common
        hipcc

        # Math libraries (core only)
        rocblas
        rocsparse
        rocrand
        
        # Development tools
        roctracer
        rocprofiler

        #clr
        #clr.icd
        #rocblas
        hipblas
        rpp
        rpp-hip
        rocwmma
      ];
   nvidiaPackage = pkgs.linuxPackages_latest.nvidiaPackages.stable;
  in
  {
  # AMD GPU
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      mesa                           # Mesa drivers for AMD GPUs
      vulkan-tools
      rocmPackages.clr               # Common Language Runtime for ROCm
      rocmPackages.clr.icd           # ROCm ICD for OpenCL
      rocmPackages.rocblas           # ROCm BLAS library
      rocmPackages.hipblas
      rocmPackages.rpp               # High-performance computer vision library
      rocmPackages.rpp-hip
      rocmPackages.rocwmma
      rocmPackages.rocm-runtime
      rocmPackages.rocm-device-libs
      rocmPackages.rocm-core
      rocmPackages.rocsparse
      rocmPackages.rocrand
      #amdvlk                         # AMDVLK Vulkan drivers
      nvtopPackages.amd              # GPU utilization monitoring
      #libdrm
    ];
  };
  
  environment.systemPackages = with pkgs; [
    rocmPackages.rocminfo
  ];

  # OpenCL
  hardware.amdgpu = {
    initrd.enable = true;
    opencl.enable = true;    
  };
  
  #services.xserver = {
  #  videoDrivers = [ "amdgpu" ];
  #  enableTearFree = true;
  #};
  
  # HIP fix
  systemd.tmpfiles.rules = 
  let
    rocmEnv = pkgs.symlinkJoin {
      name = "rocm-combined";
      paths = with pkgs; [ libdrm ] ++ rocmAllPackages;
    };
    drmEnv = pkgs.symlinkJoin {
      name = "drm-combined";
      paths = with pkgs; [ libdrm ];
    }; 
  in [
    "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
    "L+    /opt/amdgpu   -    -    -     -    ${drmEnv}"
  ];
  environment.variables = {
    ROCM_PATH = "/opt/rocm";                   # Set ROCm path
    HIP_VISIBLE_DEVICES = "0";                 # Use only the eGPU (ID 1)
    ROCM_VISIBLE_DEVICES = "0";                # Optional: ROCm equivalent for visibility
    ROCR_VISIBLE_DEVICES = "0";
    LD_LIBRARY_PATH = "/opt/rocm/lib:${nvidiaPackage}/lib:/run/current-system/sw/share/nix-ld/lib";         # Add ROCm libraries
    #HSA_OVERRIDE_GFX_VERSION = "11.0.0";       # Set GFX version override
    HSA_OVERRIDE_GFX_VERSION = "11.5.1";       # Set GFX version override
    
    #ROCM_PATH = "/run/current-system/sw";
    HIP_PATH = "/run/current-system/sw";
    HSA_PATH = "/run/current-system/sw";
    ROCM_INSTALL_DIR = "/run/current-system/sw";
    #HSA_OVERRIDE_GFX_VERSION = "11.5.1";
    #ROCR_VISIBLE_DEVICES = "0";
    #HIP_VISIBLE_DEVICES = "0";
    HSA_ENABLE_SDMA = "0";
    PYTORCH_ROCM_ARCH = "gfx1151"; # For PyTorch with ROCm
    #TORCH_BLAS_PREFER_HIPBLASLT="0"
  };

  # Create systemd service for ROCm initialization
  systemd.services.rocm-init = {
    description = "Initialize ROCm";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.rocmPackages.rocm-smi}/bin/rocm-smi";
    };
  };
  
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      rocmPackages.clr               # Common Language Runtime for ROCm
      rocmPackages.clr.icd           # ROCm ICD for OpenCL
      rocmPackages.rocblas           # ROCm BLAS library
      rocmPackages.hipblas
      rocmPackages.rpp               # High-performance computer vision library
      rocmPackages.rpp-hip
      rocmPackages.rocwmma
    ];
  };
}
