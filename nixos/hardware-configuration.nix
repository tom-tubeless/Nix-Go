# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-label/flores";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd" ];
    };

  boot.initrd.luks.devices."flores_crypt".device = "/dev/disk/by-partlabel/flores";

  fileSystems."/nix" =
    { device = "/dev/disk/by-label/flores";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd" ];
    };

  fileSystems."/persist" =
    { device = "/dev/disk/by-label/flores";
      fsType = "btrfs";
      options = [ "subvol=persist" "compress=zstd" ];
    };

  fileSystems."/swap" =
    { device = "/dev/disk/by-label/flores";
      fsType = "btrfs";
      options = [ "subvol=swap" "noatime" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
    };

  swapDevices = [{
    device = "/swap/swapfile";
    size = 8192;
  }];

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = lib.mkDefault false;
  networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;
}
