# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
   user="deuce";
in

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi"; # /boot will probably work too
    };
    grub = {                          # Using grub means first 2 lines can be removed
      enable = true;
      #device = ["nodev"];            # Generate boot menu but not actually installed
      devices = ["nodev"];            # Install grub
      efiSupport = true;
      useOSProber = true;             # Or use extraEntries like seen with Legacy
    };                                # OSProber will probably not find windows partition on first install
  };

  boot.initrd.kernelModules = [ "amdgpu" ];


  networking.hostName = "Alpha"; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.


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
    openssh = {
      enable =true;
       allowSFTP = true; 
    };
    xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];
      # displayManager = {
      #   sddm.enable = true;
      #   defaultSession = "none+bspwm";
      # };
      # desktopManager.xfce.enable = true;
      # windowManager.bspwm = {
      # enable = true;
      # # configFile = ./config/bspwmrc;
      # # sxhkd.configFile = ./config/sxhkdrc;
      # };
      layout = "us";
      xkbVariant = "";
          };
  };

 # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.windowManager.bspwm.enable = true; 
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "deuce";

  

 # Enable Security
  security.rtkit.enable = true;
  security.polkit.enable = true;

# Enable sound.
  sound = {                                # Deprecated due to pipewire
    enable = true;
    mediaKeys = {
      enable = true;
    };
  };
  
  hardware ={
     # Enable Sound
    pulseaudio = {
      enable = true;
    };
     # Video support
    opengl = {
      enable = true;
      driSupport32Bit = true;
      driSupport = true;
    };
    xone ={
      enable = true;
    };
  };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.deuce = {
    isNormalUser = true;
    description = "deuce";
    extraGroups = [  "sudo" "wheel""video""audio""camera""networkmanager""lp""scanner""kvm""libvirtd"]; # Enable ‘sudo’ for the user.
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

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:



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




 


  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}