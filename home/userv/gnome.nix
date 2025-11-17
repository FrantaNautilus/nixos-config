{
  pkgs,
  private,
  ...
}: {
  programs.gnome-shell = {
    enable = true;
    #input.keyboard = {
    #  layouts = [{layout = "us";}] ++ private.userv.layoutsExtra;
    #};
  };
  services.gnome-keyring.enable = true;
  services.polkit-gnome.enable = true;
}
