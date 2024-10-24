{
  pkgs ? import <nixpkgs> {}
}:

pkgs.mkShell {
  name = "latex-editor";

  buildInputs = with pkgs; [
    git
    gnumake
    texliveFull
    tex-fmt
  ];

  shellHook = ''
    export TEXMFHOME=$HOME/texmf

    # Run the Makefile update target
    echo "Running make update..."
    make update
  '';
}