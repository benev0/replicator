{ pkgs ? import <nixpkgs> { config.allowUnfree = true; } }:
with pkgs;
let
    dotnet-combined = (with dotnetCorePackages; combinePackages [
      sdk_8_0
    ]).overrideAttrs (finalAttrs: previousAttrs: {
      # This is needed to install workload in $HOME
      # https://discourse.nixos.org/t/dotnet-maui-workload/20370/2

      postBuild = (previousAttrs.postBuild or '''') + ''
         for i in $out/sdk/*
         do
           i=$(basename $i)
           length=$(printf "%s" "$i" | wc -c)
           substring=$(printf "%s" "$i" | cut -c 1-$(expr $length - 2))
           i="$substring""00"
           mkdir -p $out/metadata/workloads/''${i/-*}
           touch $out/metadata/workloads/''${i/-*}/userlocal
        done
      '';
    });
    dependencies = with pkgs; [
      dotnet-combined
    ];

in mkShell {
  name = "replicator devshell";
  packages = dependencies;
  buildInputs = with pkgs; [ cargo rustc rustfmt rustPackages.clippy lld_19 llvm_19 rustup];
  RUST_BACKTRACE = 1;
  shellHook = ''
    export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath dependencies}
    export PATH="/home/ben/.npm-global/bin:/home/ben/.npm-global:$PATH"
    export PATH="/home/ben/.cargo/bin:$PATH"
    echo "rust binaries on path"
  '';
  DOTNET_ROOT = "${dotnet-combined}";
}
