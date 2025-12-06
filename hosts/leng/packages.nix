{
  pkgs,
  inputs,
  ...
}: let
  miractl = inputs.miractl.defaultPackage.x86_64-linux;
  mogan = inputs.mogan.packages.x86_64-linux.default;
in {
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    lm_sensors
    gnome-boxes
    wget
    gnumake
    pandoc
    manuskript
    neovim
    # WinApps
    #inputs.winapps.packages.${system}.winapps
    #inputs.winapps.packages.${system}.winapps-launcher # optional
    #Other
    miractl
    file
    which
    tree
    usbutils
    gnused
    gnutar
    gawk
    zstd
    gnupg
    age
    git-agecrypt
    #agebox
    sops
    ssh-to-age
    #mogan
    #inputs.mogan
    ffmpeg-full
    #((pkgs.ffmpeg-full.override { withUnfree = true; }).overrideAttrs (_: { doCheck = false; }))
    #(pkgs.ffmpeg-full.override { withUnfree = true; })
    graphviz
    mission-center
    rocmPackages.rocm-smi
    #klavaro
    # LLMs
    crush
    sillytavern
    aichat
    llm
    llm-ls
    goose-cli
    #lmstudio
    #mcphost
  ];
}
