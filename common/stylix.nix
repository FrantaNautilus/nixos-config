{
  pkgs,
  inputs,
  ...
}: let
  nix-wallpaper = "${inputs.nix-wallpaper.packages.${pkgs.system}.default.override {
    preset = theme.presetName;
    logoSize = 25;
  }}/share/wallpapers/nixos-wallpaper.png";
  themes = {
    eink = {
      presetName = "nix-emacs";
      polarity = "light";
      wallpaper = nix-wallpaper;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/harmonic16-light.yaml";
    };
    gruvbox-dark = {
      presetName = "gruvbox-dark";
      polarity = "dark";
      wallpaper = nix-wallpaper;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
    };
  };
  theme = themes.gruvbox-dark;
in {
  # Stylix Config
  stylix.enable = true;
  stylix.image = theme.wallpaper;
  stylix.polarity = theme.polarity;
  stylix.base16Scheme = theme.base16Scheme;

  stylix.cursor.package = pkgs.hackneyed;
  stylix.cursor.name = "Hackneyed";
  stylix.cursor.size = 24;

  stylix.fonts = {
    monospace = {
      package = pkgs.nerd-fonts.jetbrains-mono;
      #package = pkgs.nerd-fonts.jetbrains-mono;
      name = "JetBrainsMono Nerd Font Mono";
    };
    sansSerif = {
      package = pkgs.source-serif;
      name = "Source Serif 4";
    };
    serif = {
      package = pkgs.source-sans;
      name = "Source Sans 3";
    };
    emoji = {
      package = pkgs.noto-fonts-emoji;
      name = "Noto Color Emoji";
    };
  };
  stylix.targets.qt = {
    enable = true;
    platform = "kde6";
  };
}
