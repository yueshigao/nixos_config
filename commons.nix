{ config, pkgs, ... }:

let
  username = (import ./variables.nix).username;
in
{

  nixpkgs.config.allowUnfree = true;
  system.autoUpgrade.enable = true;

  time.timeZone = "Europe/Paris";

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "fr";
    defaultLocale = "fr_FR.UTF-8";
  };

  fonts = {
    enableDefaultFonts = true;
    enableFontDir = true;
    fonts = with pkgs; [
      dina-font
      emojione
      fira-code
      fira-code-symbols
      font-awesome-ttf
      font-awesome_5
      hasklig
      proggyfonts
    ];
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [

    direnv
    mkpasswd
    neofetch
    powertop
    tmux
    unar
    unzip
    vim
    wget
    zip
    zsh

    antibody

  ];

  boot.plymouth.enable = true;
  services.openssh.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
  };

  users.defaultUserShell = pkgs.zsh;

  users.extraUsers.${username} = {
     isNormalUser = true;
     uid = 1160;
     initialPassword = "changeme";
     createHome = true;
     home = "/home/${username}";
     extraGroups = [ "${username}" "wheel" "networkmanager" ];
  };

}
