# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "starnix"; # Define your hostname. # CUSTOMIZED
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # ADDED

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp1s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # CUSTOMIZED
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  # CUSTOMIZED
  time.timeZone = "America/Los_Angeles";

  # ADDED, config for certain packages
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
  # CUSTOMIZED
  environment.systemPackages = with pkgs; [
    nixfmt

    vim
    neovim
    python37Packages.pynvim
    # needed by fzf or ctrlp (neo)vim plugins
      ripgrep
      fzy
      fd

    firefox

    gnome3.meld
    gnome3.gnome-tweak-tool
    gnome3.dconf-editor

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

  #ADDED
  programs.zsh.enable = true;
  programs.chromium.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # CUSTOMIZED
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false; # CUSTOMIZED

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # CUSTOMIZED
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true; # CUSTOMIZED
  services.xserver.layout = "us"; # CUSTOMIZED
  # services.xserver.xkbOptions = "eurosign:e";
  # services.xserver.xkbOptions = "ctrl:swapcaps"; # ADDED Doesn't seem to work, so instead we set it in gnome-tweak-tool for now.

  # Enable touchpad support.
  services.xserver.libinput.enable = true; # CUSTOMIZED

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # Enable the Gnome Desktop Environment. https://nixos.wiki/wiki/Gnome
  # TODO try Wayland instead of X11. See here: https://github.com/NixOS/nixpkgs/issues/32806#issuecomment-449987334
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = false;
  services.xserver.desktopManager.gnome3.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # CUSTOMIZED
  users.users.trusktr = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

}

