{qemuUsers, ...}: {
  programs.virt-manager = {
    enable = true;
    #package = pkgs.virt-manager-qt;
  };

  users.groups.libvirtd.members = qemuUsers;

  virtualisation.libvirtd.enable = true;

  virtualisation.spiceUSBRedirection.enable = true;
}
