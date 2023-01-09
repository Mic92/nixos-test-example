{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  outputs = { self, nixpkgs, ...}: let
    # expose systems for `x86_64-linux` and `aarch64-linux`
    forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" ];
  in {
    nixosModules.hello-world-server = import ./hello-world-server.nix;
    checks = forAllSystems (system: let
      checkArgs = {
        # reference to nixpkgs for the current system
        pkgs = nixpkgs.legacyPackages.${system};
        # this gives us a reference to our flake but also all flake inputs
        inherit self;
      };
    in {
      # import our test
      hello-world-server = import ./tests/hello-world-server.nix checkArgs;
    });
  };
}
