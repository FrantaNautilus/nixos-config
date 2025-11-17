{pkgs, ...}: {
  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # KDE
    krusader
    krename
    haruna
    # labplot # Currently broken
    kdePackages.krdc
    kdePackages.ksystemlog
    #kdePackages.libksysguard
    kdePackages.kcalc
    kdePackages.skanlite
    kdePackages.kalarm
    kdePackages.kleopatra
    kdePackages.korganizer
    kdePackages.kmail
    kdePackages.kontact
    kdePackages.kompare
    #kdePackages.calligra
    kdePackages.akregator
    kdePackages.ktorrent
    kdePackages.filelight
    #kdePackages.neochat
  ];
}
