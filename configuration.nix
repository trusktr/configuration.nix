# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # slient boot
  boot.plymouth.enable = true;

  networking = {
    hostName = "starnix";
    networkmanager.enable = true;

    # Open ports in the firewall.
    # firewall.allowedTCPPorts = [ ... ];
    # firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    firewall.enable = false;
  };

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # config for certain packages
  nixpkgs.config = {
    allowUnfree = true;

    # Firefox and Chromium settings from https://nixos.wiki/wiki/Chromium
    firefox = {
      enableGoogleTalkPlugin = true;
      enableAdobeFlash = true;
      enableGnomeExtensions = true;
    };
    chromium = {
      enablePepperFlash = true; # Chromium removed support for Mozilla (NPAPI) plugins so Adobe Flash no longer works 
    };

  };

  # List packages installed in system profile. To search, run:
  # $ nix search <term>
  environment.systemPackages = with pkgs; [
    nixfmt

    # sources .envrc files if present when entering a directory (if explicitly
    # allowed for that directory).
    # Nix lorri uses this to automatically run a nix-shell based on shell.nix.
    direnv

    vim
    neovim
    python37Packages.pynvim
    # needed by fzf or ctrlp (neo)vim plugins
      ripgrep
      fzy
      fd

    firefox
    chromium

    gnome3.meld
    gnome3.gnome-tweak-tool
    gnome3.dconf-editor
    gnome3.gnome-shell-extensions

    # needed to connect to Velodyne's GlobalProtect VPN 
    openconnect

    wget
    curl
    git
    libnotify
    gimp
    zeromq
    xvfb_run
    htop
    blender
    #slack # broken, causes bug: https://discourse.nixos.org/t/5477
    #spotify
    file # file command for getting info about a file
    # Node.js, https://nixos.wiki/wiki/Node.js
    nodejs_latest
    # VS Code without proprietary MS stuff, https://nixos.wiki/wiki/Vscode
    vscodium
  ];

  programs.zsh.enable = true;
  programs.chromium.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplipWithPlugin ];
  hardware.sane.extraBackends = [ pkgs.hplipWithPlugin ];

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # uses direnv to load a nix-shell if there is a shell.nix when entering a
  # directory.
  services.lorri.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
    xkbOptions = "ctrl:swapcaps";

    # Enable touchpad support.
    libinput.enable = true;

    # Enable the KDE Desktop Environment.
    # displayManager.sddm.enable = true;
    # desktopManager.plasma5.enable = true;

    # Enable the Gnome Desktop Environment. https://nixos.wiki/wiki/Gnome
    # TODO try Wayland instead of X11. See here: https://github.com/NixOS/nixpkgs/issues/32806#issuecomment-449987334
    displayManager.gdm.enable = true;
    displayManager.gdm.wayland = true;
    desktopManager.gnome3.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    users = {
      trusktr = {
        isNormalUser = true;
        extraGroups = [
	  "wheel" # Enable ‘sudo’ for the user.
	  "networkmanager"
	  "adbusers" # access to Android devices
	];
      };
    };
    defaultUserShell = pkgs.zsh;
  };


  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
}

