{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable }:     let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      unstable-pkgs = nixpkgs-unstable.legacyPackages.${system};
    in {

    devShells.${system}.default = pkgs.mkShell {
      # hardeningDisable = [
      #   "pic"
      #   "pie"
      # ];

      buildInputs = with pkgs; [
        qmk
        clang-tools
        keymapviz
      ] ;

      shellHook = ''
        echo "Pulling git depenndencies"
        git submodule update --init --recursive
        export QMK_HOME="$(pwd)/qmk_firmware"
        export QMK_FIRMWARE="$(pwd)/qmk_firmware"
      '';
    };
  };
}
