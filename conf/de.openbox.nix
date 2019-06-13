{ config, pkgs, ... }:

let
  username = (import ../variables.nix).username;
in
{

  imports = [
    ./x.nix
    ./compositing.nix
  ];

  services.xserver.displayManager.slim = {
    enable = true;
    defaultUser = "${username}";
    autoLogin = false;
  };

  services.xserver.windowManager.openbox.enable = true;

  environment.systemPackages = with pkgs; [

    # Window Manager
    openbox obconf

    # Theme (GTK+)
    adapta-gtk-theme
    arc-theme
    materia-theme
    numix-gtk-theme
    numix-sx-gtk-theme
    paper-gtk-theme

    # Icons
    arc-icon-theme
    numix-icon-theme
    numix-icon-theme-circle
    numix-icon-theme-square
    paper-icon-theme
    papirus-icon-theme

    # Cursors
    numix-cursor-theme

    # Panel
    polybar

    # Colors
    pywal

    # Lock
    i3lock-color

    # Wallpaper
    feh

    # Applications

    # App launcher
    albert

    # Browser
    google-chrome

    # File explorer
    pcmanfm lxmenu-data gvfs

    # Terminal emulator
    termite

  ];
}
