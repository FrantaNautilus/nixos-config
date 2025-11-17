{pkgs, ...}: {
  fonts.packages = with pkgs; [
    fira
    fira-code
    fira-math
    fira-mono
    monaspace
    iosevka-bin
    #source-code-pro
    source-sans
    source-serif
    nerdfonts
  ];
}
