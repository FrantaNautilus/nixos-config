{pkgs, ...}: {
  nix = {
    settings = {
      # Enable experimental features
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
      cores = 0;
      max-jobs = "auto";
      substituters = [
        "https://cache.nixos.org"
        "https://cuda-maintainers.cachix.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1d";
    };
  };

  environment.systemPackages = with pkgs; [
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nh
    nix-output-monitor
    alejandra
    direnv

    # LSPs
    nixd
    nil
  ];
}
