{nixpkgs ? import <nixpkgs> {}}:
with nixpkgs; let
  dependencies = [
    jdk11
    maven
    coreutils
  ];

  wrapper = writeShellScriptBin "bld-mvn-prjct" ''
    set -o errexit
    set -o nounset
    set -o pipefail

    export PATH="${lib.makeBinPath dependencies}"

    mvn compile
  '';
in
  stdenv.mkDerivation {
    name = "bld-mvn-prjct";

    installPhase = ''
      mkdir -p $out/bin
      install ${wrapper}/bin/* $out/bin
    '';

    src = ./.;
  }
