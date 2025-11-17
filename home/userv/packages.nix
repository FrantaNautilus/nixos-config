{pkgs, ...}: {
  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    (brave.override {
      commandLineArgs = [
        "--enable-features=AcceleratedVideoEncoder,VaapiOnNvidiaGPUs,VaapiIgnoreDriverChecks,Vulkan,DefaultANGLEVulkan,VulkanFromANGLE"
        "--enable-features=VaapiIgnoreDriverChecks,VaapiVideoDecoder,PlatformHEVCDecoderSupport"
        "--enable-features=UseMultiPlaneFormatForHardwareVideo"
        "--ignore-gpu-blocklist"
        "--enable-zero-copy"
        "--ozone-platform=wayland"
      ];
    })
    # gimp3-with-plugins
    # scantailor-universal
    bat
    eza
    sioyek
    #jabref
    # libreoffice-qt6-fresh
    onlyoffice-desktopeditors
    freerdp
    texmacs
    # zettlr

    # shotcut

    # Security
    keepassxc
    fido2-manage

    # productivity
    # hugo # static site generator

    glow # markdown previewer in terminal

    # LSPs
    marksman # Markdown
    bash-language-server
  ];
}
