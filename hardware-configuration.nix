# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "ehci_pci" "ahci" "uhci_hcd" "sd_mod" "e1000" "e1000e" ];
  boot.initrd.kernelModules = [
  "e1000"
  "e1000e"
  "raid1"
  "raid10"
  "raid0"
  "linear"
  "raid456"
  "multipath"
  "sd_mod"
  "scsi_mod"
  "dm_mod"
  "dm_crypt"
  "ahci"
  "ehci_hcd"
  ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/57b91b2f-33ea-4055-badc-9a9a48b623fe";
      fsType = "btrfs";
      options = [ "subvol=root" ];
    };

  #boot.initrd.luks.devices."root".device = "/dev/md127";

  fileSystems."/torrents" =
    { device = "/dev/disk/by-uuid/57b91b2f-33ea-4055-badc-9a9a48b623fe";
      fsType = "btrfs";
      options = [ "subvol=torrents" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/57b91b2f-33ea-4055-badc-9a9a48b623fe";
      fsType = "btrfs";
      options = [ "subvol=nix" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/57b91b2f-33ea-4055-badc-9a9a48b623fe";
      fsType = "btrfs";
      options = [ "subvol=home" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/0370-7FCF";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno0.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}