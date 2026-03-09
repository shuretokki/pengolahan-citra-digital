{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs @ { flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
      ];

      perSystem = { system, ... }:
        let
          pkgs = import inputs.nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          opencvGtk = pkgs.opencv.override {
            enableGtk3 = true;
          };
          compress = pkgs.writeShellScriptBin "compress" ''
            if [ -z "$1" ]; then
              echo "Usage: compress <file.pdf>"
              exit 1
            fi
            ${pkgs.ghostscript}/bin/gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook \
               -dNOPAUSE -dQUIET -dBATCH -sOutputFile="''${1%.pdf}_sm.pdf" "''$1"
            echo "Compressed to ''${1%.pdf}_sm.pdf"
          '';
        in {
          packages.default = pkgs.stdenv.mkDerivation {
            pname = "pcd";
            version = "0.1.0";
            src = ./.;

            nativeBuildInputs = [ pkgs.meson pkgs.ninja pkgs.pkg-config ];
            buildInputs = [ pkgs.spdlog opencvGtk pkgs.gnuplot ];
          };

          devShells.default = pkgs.mkShell.override {
            stdenv = pkgs.clangStdenv;
          } {
            nativeBuildInputs = [ pkgs.meson pkgs.ninja pkgs.pkg-config ];
            buildInputs = [ pkgs.spdlog opencvGtk pkgs.gnuplot ];
            packages = with pkgs; [
              clang-tools gdb valgrind cppcheck ccache
              texlive.combined.scheme-full typst corefonts
              ghostscript compress gnuplot
            ];
            shellHook = ''
              export TYPST_FONT_PATHS="${pkgs.corefonts}/share/fonts/truetype"
            '';
          };
      };
    };
}
