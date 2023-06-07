# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, outputs, lib, config, pkgs, ... }: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
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
    };
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
  };

  system.autoUpgrade = {
    enable = true;
    operation = "boot";
#    flake = "github:sbaue/nixos-config";
    flake = "/home/myown/.nixcfg";
  };
  
  networking.hostName = "nixos";
  
  zramSwap.enable = true;
  
  boot = {
    loader = {
      systemd-boot = { 
        enable = true;
        consoleMode = "auto";
        configurationLimit = 5;
        };
      efi = { 
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
    };
  };
  
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = { 
        swtpm.enable = true;
        ovmf.enable = true;
      };
    };
    podman = {
      enable = true;
      enableNvidia = true;
      autoPrune.enable = true;
      dockerCompat = true;
    };
  };

  networking = {
    nat.enable = true;
    networkmanager.enable = true;
   # interfaces.enp42s0.useDHCP = true;
   # interfaces.br0.useDHCP = true;
   # bridges = {
   # "br0" = {
   #   interfaces = [ "enp42s0" ];
   #   };
   # };
  };

  i18n = { 
    defaultLocale = "de_DE.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
    };
  };

  console.keyMap = "de";

  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.nvidia.modesetting.enable = true;

  services = {
    printing.enable = false;
    flatpak.enable = true;
    xserver = {
      enable = true;
      displayManager = {
        lightdm.enable = true;
        lightdm.greeters.slick.enable = true;
      };
      desktopManager.cinnamon.enable = true;
      videoDrivers = [ "nvidia" ];
      layout = "de";
      xkbVariant = "";
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };


 programs = {
    steam.enable = true;
    };
  

  environment = {
    systemPackages = with pkgs; [ virt-manager egl-wayland ];
    };

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    users = {
      # Import your home-manager configuration
      myown = import ../home-manager;
    };
  };

  users.users.myown = {
    isNormalUser = true;
    description = "Sebastian Bauer";
    extraGroups = [ "networkmanager" "wheel" "video" "libvirtd"];
  };

  system.stateVersion = "22.11";
}
