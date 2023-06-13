# This file defines overlays
{ inputs, ... }:
{
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs { pkgs = final; };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
#    krusader = prev.krusader.overrideAttrs (old: {
#      src = prev.fetchurl {
#      url = "mirror://kde/stable/krusader/2.8.0/krusader-2.8.0.tar.xz";
#      hash = "sha256-jkzwWpMYsLwbCUGBG5iLLyuwwEoNHjeZghKpGQzywpo=";
#      };
#    });
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
