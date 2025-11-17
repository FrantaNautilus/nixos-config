{pkgs, ...}: {
  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.printing.drivers = [pkgs.samsung-unified-linux-driver];

  imports = [
    ./avahi.nix
  ];
}
