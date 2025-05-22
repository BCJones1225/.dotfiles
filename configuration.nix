# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;

  networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  programs.nm-applet = {
    enable = true;
    indicator = true;
  };

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
    # font = "Lat2-Terminus16";
    # keyMap = "us";
    # useXkbConfig = true; # use xkb.options in tty.
  # };

  sops = {
    defaultSopsFile = /etc/nixos/secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    secrets = {
      "tt-rss/password" = { };
      "tt-rss/psql/password" = { };
    };
  };

  # services ={
  #   mastodon = {
  #     enable = true;
  #     localDomain = "social.geopoliticaloccult.net";
  #     configureNginx = true;
  #     smtp.fromAddress = "bryan@geopoliticaloccult.net";
  #     streamingProcesses = 3;
  #   };

  #   postgresqlBackup = {
  #     enable = true;
  #     databases = [ "mastodon" "tt_rss" ];
  #   };

  #   tt-rss = {
  #     enable = true;
  #     database = {
  #       type = "pgsql";
  #       passwordFile = config.sops.secrets."tt-rss/psql/password".path;
  #     };

  #     email = {
  #       fromAddress = "bryan@geopoliticaloccult.net";
  #       fromName = "Bryan at geopoliticaloccult.net";
  #     };

  #     virtualHost = "news.geopoliticaloccult.net";
  #     selfUrlPath = "https://news.geopoliticaloccult.net/";
  #   };

  #   postgresql.enable = true;

  #   nginx = {
  #     enable = true;
  #     recommendedTlsSettings = true;
  #     recommendedGzipSettings = true;
  #     recommendedOptimisation = true;
  #     recommendedZstdSettings = true;
  #     recommendedProxySettings = true;
  #     recommendedBrotliSettings = true;
  #     virtualHosts = {
  #       "social.geopoliticaloccult.net" = {
  #         enableACME = true;
  #         forceSSL = true;
  #       };

  #       "news.geopoliticaloccult.net" = {
  #         enableACME = true;
  #         forceSSL = true;
  #       };
  #     };
  #   };
  # };

  # security.acme = {
  #   acceptTerms = true;
  #   certs = {
  #     "social.geopoliticaloccult.net".email = "bryan@geopoliticaloccult.net";
  #     "news.geopoliticaloccult.net".email = "bryan@geopoliticaloccult.net";
  #   };
  # };

  # Enable the X11 windowing system.
  services = {
    xserver.enable = true;
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio = {
  #   enable = true;
  #   package = pkgs.pulseaudioFull;
  #   configFile = pkgs.writeText "default.pa" ''
  #     load-module module-switch-on-connect
  #     load-module module-bluetooth-policy
  #     load-module module-bluetooth-discover
  #     ## module fails to load with 
  #     ##   module-bluez5-device.c: Failed to get device path from module arguments
  #     ##   module.c: Failed to load module "module-bluez5-device" (argument: ""): initialization failed.
  #     # load-module module-bluez5-device
  #     # load-module module-bluez5-discover
  #   '';
  # };
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
  };

  services.blueman.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.bryancj = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  # programs.firefox.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    kitty brave rox-filer wofi waybar hyprpaper nerdfonts blueman xclip age
    mpv sops
  ];
  
  fonts.packages = with pkgs; [ nerdfonts ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs = {
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    chromium = {
      enable = true;
      extraOpts = {
        "BrowserSignin" = 0;
        "SyncDisabled" = false;
        "PasswordManagerEnabled" = true;
        "SpellcheckEnabled" = true;
        "SpellcheckLanguage" = [
          "en-US"
        ];
      };
    };

    bash = {
      completion.enable = true;
      blesh.enable = true;
      vteIntegration = true;
      enableLsColors = true;
    };
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 80 443 5432 9000 ];
  # networking.firewall.allowedUDPPorts = [ 80 443 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

}

