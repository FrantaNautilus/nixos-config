{pkgs, ...}: let
  combined_tex = pkgs.texlive.combine {
    inherit
      (pkgs.texlive)
      scheme-medium
      collection-fontsrecommended
      collection-fontsextra
      dvisvgm
      dvipng # for preview and export as html
      wrapfig
      amsmath
      ulem
      hyperref
      capt-of
      biber
      exam
      qcircuit
      xypic
      multirow
      bbm
      ;
    #(setq org-latex-compiler "lualatex")
    #(setq org-preview-latex-default-process 'dvisvgm)
  };
in {
  home.packages = with pkgs; [
    combined_tex

    # LSPs
    texlab
    # ltex-ls-plus # Grammar #unstable
  ];
}
