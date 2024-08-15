{ pkgs ? (let lock = builtins.fromJSON (builtins.readFile ./flake.lock);
in import (builtins.fetchTarball {
  url =
    "https://github.com/NixOS/nixpkgs/archive/${lock.nodes.nixpkgs.locked.rev}.tar.gz";
  sha256 = lock.nodes.nixpkgs.locked.narHash;
}) { }) }:

let
  dependencies = with pkgs; [
    dotnetCorePackages.sdk_8_0
  ];
in pkgs.mkShell {
  name = "replicator devshell";
  buildInputs = [ pkgs.cargo pkgs.rustc ];
  packages = dependencies;
  shellHook = ''
    export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath dependencies}
    export PATH="/home/ben/.npm-global/bin:/home/ben/.npm-global:$PATH"
    export PATH="/home/ben/.cargo/bin:$PATH"
    echo "rust binaries on path"
  '';
}
