{nixpkgs ? import <nixpkgs> {}}:
with nixpkgs; let
  dependencies = [
    git
    jdk21
    temurin-jre-bin-21
    maven
    coreutils
    bash
    gnugrep
  ];

  wrapper = writeShellScriptBin "bld-mvn-prjct" ''
    set -o errexit
    set -o nounset
    set -o pipefail

    export PATH="${lib.makeBinPath dependencies}"

    mvn clean package cargo:install
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