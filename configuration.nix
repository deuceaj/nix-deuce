# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.blacklistedKernelModules = [ "radeon" ];

  networking.hostName = "Alpha"; # Define your hostname.
 
  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };



services = {
    xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];
      displayManager = {
        gdm.enable = true;
        # defaultSession = "none+bspwm";
      };
      desktopManager.gnome.enable = true;
      windowManager.bspwm = {
      enable = true;
      configFile = ./config/bspwmrc;
      sxhkd.configFile = ./config/sxhkdrc;
      };
      layout = "us";
      xkbVariant = "";
          };
  };
  
  # Enable CUPS to print documents.
  services.printing.enable = true;


# Video support
  hardware = {
      opengl.extraPackages = with pkgs; [
        amdvlk
        rocm-opencl-icd
        rocm-opencl-runtime
      ];
      opengl.extraPackages32 = with pkgs; [ ];
    };  

  # Enable Xbox support
  hardware.xone.enable = true;


  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    
  };



  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.deuce = {
    isNormalUser = true;
    description = "deuce";
    extraGroups = [  "sudo" "wheel""video""audio""camera""networkmanager""lp""scanner""kvm""libvirtd"]; 
    packages = with pkgs; [
    alacritty
    arandr
    bspwm
    btop
    cifs-utils
    cinnamon.nemo
    discord
    firefox-devedition-bin
    git
    libreoffice
    neofetch
    nitrogen
    neofetch
    neovim
    okular
    pavucontrol
    picom
    playerctl
    polkit_gnome
    polybar
    rofi
    rofi-calc
    sddm
    spotify
    steam
    sxhkd
    vscode
    xdg-utils
    vlc

    #Default from matthias
    libnotify
    xclip
    xorg.xrandr      
    networkmanagerapplet
    xorg.xev
    alsa-lib
    alsa-utils
    flac
    pulsemixer
    linux-firmware
    sshpass      
    lxappearance
    imagemagick
    flameshot
    partition-manager
    ];
    shell = pkgs.zsh; 
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;



  ######################
  # Program Setups
  ######################
  # Enable Corectrl
  programs.corectrl.enable = true;
  programs.corectrl.gpuOverclock.enable = true;
  programs.corectrl.gpuOverclock.ppfeaturemask = "0xffffffff";
  # KDE Partition Manager
  programs.partition-manager.enable = true;
  # Manages keys and such
  programs.gnupg.agent.enable = true;
  # Needed for anything GTK related
  programs.dconf.enable = true;


  ######################
  # Gnome Polkit for WM
  ######################
  systemd = {
  user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
  };
};

  #########################################
  # List services that you want to enable:
  #########################################

  services = {
    avahi = {                                   # Needed to find wireless printer
      enable = true;
      nssmdns = true;
      publish = {                               # Needed for detecting the scanner
        enable = true;
        addresses = true;
        userServices = true;
      };
    };
  
    openssh = {                             # SSH: secure shell (remote connection to shell of server)
      enable = true;                        # local: $ ssh <user>@<ip>
      allowSFTP = true;                     # SFTP: secure file transfer protocol (send file to server)
      # settings.passwordAuthentication = false;
     
    };

  };




 services.picom = {
    enable = true;
    settings = {
      animations = true;
      animation-stiffness = 300.0;
      animation-dampening = 35.0;
      animation-clamping = false;
      animation-mass = 1;
      animation-for-workspace-switch-in = "auto";
      animation-for-workspace-switch-out = "auto";
      animation-for-open-window = "slide-down";
      animation-for-menu-window = "none";
      animation-for-transient-window = "slide-down";
      corner-radius = 12;
      rounded-corners-exclude = [
        "class_i = 'polybar'"
        "class_g = 'i3lock'"
      ];
      round-borders = 3;
      round-borders-exclude = [];
      round-borders-rule = [];
      shadow = true;
      shadow-radius = 8;
      shadow-opacity = 0.4;
      shadow-offset-x = -8;
      shadow-offset-y = -8;
      fading = false;
      inactive-opacity = 0.8;
      frame-opacity = 0.7;
      inactive-opacity-override = false;
      active-opacity = 1.0;
      focus-exclude = [
      ];

      opacity-rule = [
        "100:class_g = 'i3lock'"
        "60:class_g = 'Dunst'"
        "100:class_g = 'Alacritty' && focused"
        "90:class_g = 'Alacritty' && !focused"
      ];

      blur-kern = "3x3box";
      blur = {
        method = "kernel";
        strength = 8;
        background = false;
        background-frame = false;
        background-fixed = false;
        kern = "3x3box";
      };

      shadow-exclude = [
        "class_g = 'Dunst'"
      ];

      blur-background-exclude = [
        "class_g = 'Dunst'"
      ];

      backend = "glx";
      vsync = false;
      mark-wmwin-focused = true;
      mark-ovredir-focused = true;
      detect-rounded-corners = true;
      detect-client-opacity = false;
      detect-transient = true;
      detect-client-leader = true;
      use-damage = true;
      log-level = "info";

      wintypes = {
        normal = { fade = true; shadow = false; };
        tooltip = { fade = true; shadow = false; opacity = 0.75; focus = true; full-shadow = false; };
        dock = { shadow = false; };
        dnd = { shadow = false; };
        popup_menu = { opacity = 1.0; };
        dropdown_menu = { opacity = 1.0; };
      };
    };
  };



  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  ];


  system.stateVersion = "22.11"; # Did you read the comment?

}