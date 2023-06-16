# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, lib, config, pkgs, ... }: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
   #   allowUnfreePredicate = (_: true);
    };
  };

  home = {
    username = "myown";
    homeDirectory = "/home/myown";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home = { 
    packages = with pkgs; [ 
      distrobox 
      librewolf
      gh
      kate
#      krusader
      mullvad-browser
      tldr
    ];
    sessionVariables = {
      EDITOR = "hx";
    };
  };

  # Enable home-manager and git
  programs = { 
    home-manager.enable = true;
    librewolf = {
      enable = true;
      settings = {
        "privacy.resistFingerprinting.letterboxing" = true;
        "identity.fxaccounts.enabled" = true;
        "privacy.clearOnShutdown.history" = false;
        "services.sync.username" = "sbauer@posteo.de";
        "browser.startup.page" = 3;
        "intl.locale.requested" = "de,en-US";
        "intl.accept_languages" = "en-US,en";
        "signon.autofillForms" = true;
        "signon.rememberSignons" = true;
        "privacy.spoof_english" = 2;
        };
      };
    git = {
      enable = true;
      userName  = "sbaue";
      userEmail = "sbauer@posteo.de";
      };
    bash.enable = true;
    helix = {
      enable = true;
      settings = {
        theme = "onedarker";
      };
    };
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      plugins = with pkgs.vimPlugins; [
        vim-nix
      ];
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}
