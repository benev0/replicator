{ pkgs, inputs, ... }:
let
    pkgs-unstable = import inputs.nixpkgs-unstable { system = pkgs.stdenv.system; };
    spacetime_db = pkgs-unstable.rustPlatform.buildRustPackage rec {
        pname = "SpacetimeDB";
        version = "v1.0.0";

        # todo: spec rustc explicitly & required extensions

        nativeBuildInputs = [
            pkgs-unstable.perl              # needed for openssl build
            pkgs.git                        # needed for cli build script
            pkgs-unstable.llvmPackages.lld  # no clue why the linker is needed as a dev input
        ];

        useFetchCargoVendor = true;

        src = pkgs-unstable.fetchFromGitHub {
            owner = "clockworklabs";
            repo = pname;
            rev = version;
            hash = "sha256-L3D7DfMQNuoZ/twAsrK20royIGp6PXCAFZKnb0PgSu0=";
        };
        cargoHash = "sha256-eOZRp3LRbQzHfT+evKY55ifevX+ki9oT5B7vZs3ym+c=";
    };
in
{
    languages = {
        rust = {
            enable = true;
            channel = "nightly";
            targets = [ "wasm32-unknown-unknown" ];
        };
    };

    packages = [
        spacetime_db
    ];

    # initial install requires spacetime to be added to user paths
    enterShell = ''
        echo "shell ready"
        export PATH="/home/ben/.local/bin:$PATH"
    '';

    cachix.enable = false;
}