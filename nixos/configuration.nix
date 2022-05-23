# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, lib, config, pkgs, ... }: {

  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware), use something like:
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # It's strongly recommended you take a look at
    # https://github.com/nixos/nixos-hardware
    # and import modules relevant to your hardware.

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix

    # You can also split up your configuration and import pieces of it here.
  ];

  # This will add your inputs as registries, making operations with them (such
  # as nix shell nixpkgs#name) consistent with your flake inputs.
  nix.registry = lib.mapAttrs' (n: v: lib.nameValuePair n { flake = v; }) inputs;

  # Will activate home-manager profiles for each user upon login
  # This is useful when using ephemeral installations
  environment.loginShellInit = ''
    [ -d "$HOME/.nix-profile" ] || /nix/var/nix/profiles/per-user/$USER/home-manager/activate &> /dev/null
  '';

  nix = {
    # Make sure we have at least nix 2.4
    # TODO: You can remove me if you're using NixOS 22.05+
    package = pkgs.nixFlakes;
    # Enable flakes and new 'nix' command
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    autoOptimiseStore = true;
  };

  # Remove if you wish to disable unfree packages for your system
  nixpkgs.config.allowUnfree = true;

  networking.hostName = "flores";
  
  time.timeZone = "Europe/Amsterdam";

  ### Boot Configuration ###
  boot = {
    cleanTmpDir = true;
    # initrd.checkJournalingFS = false; # for Virtualbox only
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        efiSupport = true;
        enable = true;
        enableCryptodisk = true;
        device = "nodev";
        # font = "${pkgs.nerdfonts}/share/fonts/truetype/NerdFonts/Fura Code Retina Nerd Font Complete Mono.ttf";
        # fontSize = 32;
        version = 2;
      };
      systemd-boot.enable = true;
    };
    initrd.luks.devices = {
      root = {
        device = "/dev/nvme0n1p2";
        preLVM = true;
      };
    };
    initrd.preLVMCommands = ''
      echo '--- OWNERSHIP NOTICE ---'
      echo 'This device is property of Lutz Go'
      echo 'If lost please contact lutz0go@gmail.com'
      echo '--- OWNERSHIP NOTICE ---'
    '';
  };

  users.users = {
    lgo = {
      # TODO: You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      # initialPassword = "correcthorsebatterystaple";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
      # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      extraGroups = [ "wheel" ];
    };
  };

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    # Forbid root login through SSH.
    permitRootLogin = "no";
    # Use keys only. Remove if you want to SSH using password (not recommended)
    passwordAuthentication = false;
  };
  
    # Enable the X11 windowing system.
  services.xserver.enable = true;


  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

}
