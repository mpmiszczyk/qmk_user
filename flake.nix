{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # This input fetches a standard Git repository.
    # Since it has no 'flake.nix', Nix just provides its source path.
    qmk_firmware = {
      url = "github:qmk/qmk_firmware";
      flake = false;
    };
  };

  # We add 'qmk_firmware' to our function arguments.
  # Its value will be the path to the fetched source code.
  outputs = { self, nixpkgs, qmk_firmware }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.hello;

      devShells.${system}.default = pkgs.mkShell {
        # We set QMK_HOME to the source path of our input.
        # 'qmk_firmware' resolves to something like:
        # /nix/store/vx3b9h...-qmk_firmware
        QMK_HOME = qmk_firmware;

        packages = [
          pkgs.qmk
          pkgs.keymapviz
        ];

        shellHook = ''
          echo "✅ QMK Development Environment Ready"
          echo "📁 QMK Firmware source is at: $QMK_HOME"
        '';
      };
    };
}
