{pkgs, ...}: {

  environment.systemPackages = with pkgs; [
    # https://github.com/nix-community/nix-ld?tab=readme-ov-file#my-pythonnodejsrubyinterpreter-libraries-do-not-find-the-libraries-configured-by-nix-ld
    (pkgs.writeShellScriptBin "python" ''
      export LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH
      export CC=${pkgs.gcc}/bin/gcc
      exec ${pkgs.python311}/bin/python "$@"
    '')
    (pkgs.writeShellScriptBin "uv" ''
      export LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH
      export CC=${pkgs.gcc}/bin/gcc
      exec ${pkgs.uv}/bin/uv "$@"
    '')
  ];

  environment.sessionVariables = {
    CC = "${pkgs.gcc}/bin/gcc";
  };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc
      stdenv.cc.cc.lib
      gcc
      glib
      zlib
      zstd
      curl
      openssl
      attr
      libssh
      bzip2
      libxml2
      acl
      libsodium
      util-linux
      xz
      systemd
      udev
      dbus
      mesa
      libglvnd
    ];
  };
  
  services = {
    envfs = {
      enable = true;
    };
  };
}
