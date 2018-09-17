{ config, pkgs, ... }:

{

  # Version
  system.stateVersion = "17.09";

  # Imports
  imports = [
    ./conf/de.openbox.nix
    ./conf/development.nix
  ];

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Host
  networking.hostName = "nixos";

  # Groups
  users.groups = {
    audio.members = [ "bessonm" ];
  };

  # File System
  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/555500a3-99c6-4d8c-8500-70a0e966987f";
    fsType = "ext4";
  };

 fileSystems."/mnt/other" = {
    device = "/dev/disk/by-uuid/564b621e-62de-4a43-acba-bc50b3a1650b";
    fsType = "ext4";
  };

 fileSystems."/mnt/windows" = {
    device = "/dev/disk/by-uuid/60706E2E706E0ADC";
    fsType = "ntfs";
  };

  ## Specific ##

  networking.wireless.enable = false;
  networking.networkmanager.enable = true;

  # Audio
  hardware.pulseaudio.enable = true;

  # Graphics
  hardware.bumblebee = {
    enable = true;
    driver = "nvidia";
    connectDisplay = true;
  };

  services = {
    gnome3.gvfs.enable = true;

    # Compositing
    compton = {
      enable = true;
      backend = "glx";
      vSync = "opengl-swc";
      refreshRate = 0;
      extraOptions =
        ''
          glx-no-stencil = true;
          glx-copy-from-front = false;
          glx-swap-method = "undefined";
          paint-on-overlay = true;
          dbe = false;
        '';
    };

    # Screen
    redshift = {
      enable = true;
      latitude = "48.8502";
      longitude = "2.3488";
      brightness.day = "0.8";
      brightness.night = "0.8";
      temperature.day = 5700;
      temperature.night = 4200;
    };

    mpd = {
      enable = true;
      # dataDir = "/home/bessonm/.mpd";
      musicDirectory = "/home/bessonm/Music";
      group = "users";
      extraConfig =
        ''
          audio_output {
            type       "pulse"
            name       "pulse audio"
            device     "pulse"
            mixer_type "hardware"
          }

          audio_output {
            type   "fifo"
            name   "my_fifo"
            path   "/tmp/mpd.fifo"
            format "44100:16:2"
          }
        '';
    };
  };

  nixpkgs.config.zathura.useMupdf = true;

  environment.variables.GIO_EXTRA_MODULES = [ "${pkgs.gvfs}/lib/gio/modules" ];

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [

    alsaUtils
    zathura

    # X
    xorg.xbacklight
    xorg.xev
    xorg.xrandr

    # Graphics
    bumblebee

    # Screen
    redshift

    # Media
    beets
    clerk
    mpc_cli
    mpd
    mpv
    mpvc
    ncmpcpp

    # Torrent
    transmission-gtk

    # Virtualization
    virtualbox

  ];

  programs.zsh = {
    enableCompletion = true;
    enableAutosuggestions = true;
  };

}