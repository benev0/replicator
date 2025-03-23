{ pkgs, inputs, ... }:
let
    pkgs-unstable = import inputs.nixpkgs-unstable { system = pkgs.stdenv.system; };
    spacetime_db = pkgs-unstable.rustPlatform.buildRustPackage rec {
        pname = "SpacetimeDB";
        version = "v1.0.0";

        # todo: spec rustc version & required extensions here:

        nativeBuildInputs = [
            pkgs-unstable.perl  # needed for openssl build
            pkgs.git            # needed for cli build script
            pkgs-unstable.llvmPackages.lld
        ];

        useFetchCargoVendor = true;

        src = pkgs-unstable.fetchFromGitHub {
            owner = "clockworklabs";
            repo = pname;
            # rev = "01c391f8a9cf6d2cdc4272237348019adb434d38";             # latest does not pass tests. so it crashes!? :(
            rev = version;
            hash = "sha256-jfkyTznQPTJyeI6YXcvVsNP35g0svoeiqflCmh5IWV0=";   # this was right for latest not sure why it did not fail on change
        };
        cargoHash = "sha256-tXhiS6fD89AUim9QjbV6RObu0VjAZKI3t9lsomp1koU=";
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