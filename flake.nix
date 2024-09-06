{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    dec.url = "github:bolives-hax/nixos-remote-luks-decryptor/debug";
  };

  outputs = { self, nixpkgs, dec }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hardware-configuration.nix
        ./modules/nix.nix
        #./modules/hydra.nix
        dec.nixosModules.default
        {
          boot.kernelParams = [ "console=ttyS0,115200n8" ];
          boot.loader.grub.extraConfig =
            "\n   serial --speed=115200 --unit=0 --word=8 --parity=no --stop=1\n   terminal_input serial\n   terminal_output serial\n ";

          #boot.initrd.luks.devices."nixos" = {
          #	device = "/dev/md/md_root";
          #	keyFile = "/luks-keyfile";
          #};
          boot.initrd.services.swraid = {
            enable = true;
            mdadmConf = ''
              		ARRAY /dev/md/md_root metadata=1.2 name=s26508:md_root UUID=a452695c:5f0b1a14:b9e67879:007b6dab
                 		'';

          };
          boot.loader.grub.devices = [
            "/dev/disk/by-id/ata-TOSHIBA_DT01ACA200_Z795VYJAS"
            "/dev/disk/by-id/ata-TOSHIBA_DT01ACA200_Z795W36AS"
            "/dev/disk/by-id/ata-TOSHIBA_DT01ACA200_Z796D73AS"
            "/dev/disk/by-id/ata-TOSHIBA_DT01ACA200_Z796GV4AS"
          ];

          remote_decryptor = {
            listen = {
              address = "85.17.183.144";
              gateway = "85.17.183.190";
              subnetMask = "255.255.255.192";
              interface = "eth0";
            };
            wireguard = {
              enable = true;
              tunnel = {
                local = {
                  mask = 31;
                  ip = "10.0.0.4";
                };
                peers = [{
                  address = "10.0.0.5";
                  pubkey = "bMzomqOVBFv42pryyN+nUTGT6/I/X1UXvZX7PqZqfn8=";
                }];
              };
              # pub: ufs7Mz6sHTgGvj8L+SB4gWqd1DMn3q0FrPguDe9MlWI=
              privateKey = "/etc/wireguard/wg0-initrd.priv";
            };
            ssh = {
              authorizedKeys = [
                "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCYdEdmbD/hFDNhv1kBSQhfsIpb8jOQwiIGzfJkCjBchDs3uvsYYDj8imUThrSr4zn/P5/dcSuMFvFlx/CcCWx5/KMNxgArXb6PzYzRKfyzKtsKjZtQIaO4c/7fm9BzO9HuWFZzd3FCxqKbBUxYRMWDV8catvIDxD50Se5hPrTd7vQPFpKVf7MmLnLpNcn894WTSN86U5pZkXDrDxOWyv+lhbPzPgyXnQTWWTUlA9p4bU3tSi5iQBiH36voIbKckOIB2+m2dLBbNFs5B6d0SJDpH/xFCN/xqmpinGCNoRLqk0bKnfW4vKBVJ2h0YC0MJA9q+FjmAwCxC10azHNk8MFU2QlOawWp6gRimdmKcHc4DOcqt3ldeHOVORELy01Yy+FU0aOLHBaepSh8eB0GVjFHna4dexJ/rEzOa3ibYUSAcPN35wE0DsjZ981UjlouDl/isCm7nhqxg1j6Yt17rwySGnC8rswtMJ6qYAosrnIDV8rSOJuGArFk6635mHcCfzM= flandre@nixos"

                "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCWG77EEgzdtf06bEGQRILRSqA3tSMlYjoh1mY0BZm21mhFb9JiEOIDoQ8ruMXEwASrWcFUo7a6ADpNWRrp8hNjrbHjukSQmReqT4ZPShrOpfy7O96+JiGZAN0mt2reLJ3t+vFyqP+rFTRQ3yOpCRVNJBNjJVymTKhVLYx9llJJP3VSy72rDZGEWt7ZJdINEwGYULHyribG/i2HRuG+xvVkqMDAp6Y12efln8de2zyDU7y0bE1mTU4Dd8WoXYQau1QNnGgddG2nwT11oS20550153hRbZOOJM6ExLqXHHeTCbS/ipNpRCMpcL+dcJBW2sMaMvyEB5FvMyh3yHJQaxmJcPG8yZK7y2oZrdaRMb08UNd84RhCW0dwXE9tZtGZHE6iCxM6v5U7RC3XHVD3xLu+VCl04idG88mBcOE4M576U+agLQbH78+h9D/ydGnYlZTo1WHScK5Qclh0Oiam8YDt+kFvHwnsxkfDCsA3ZBZj9LUOsCicYDSO8pSXWfeBCAU= root@m3-small-x86-01"
              ];
              hostKeys = [
                "/etc/secrets/initrd/ssh_host_rsa_key"
                "/etc/secrets/initrd/ssh_host_ed25519_key"
              ];
            };
          };
        }
        {
          services.openssh.enable = true;
          users.users.flandre = {
            isNormalUser = true;
            extraGroups = [ "wheel" ];
            password = "flandre";
            openssh.authorizedKeys.keys = [
              "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCYdEdmbD/hFDNhv1kBSQhfsIpb8jOQwiIGzfJkCjBchDs3uvsYYDj8imUThrSr4zn/P5/dcSuMFvFlx/CcCWx5/KMNxgArXb6PzYzRKfyzKtsKjZtQIaO4c/7fm9BzO9HuWFZzd3FCxqKbBUxYRMWDV8catvIDxD50Se5hPrTd7vQPFpKVf7MmLnLpNcn894WTSN86U5pZkXDrDxOWyv+lhbPzPgyXnQTWWTUlA9p4bU3tSi5iQBiH36voIbKckOIB2+m2dLBbNFs5B6d0SJDpH/xFCN/xqmpinGCNoRLqk0bKnfW4vKBVJ2h0YC0MJA9q+FjmAwCxC10azHNk8MFU2QlOawWp6gRimdmKcHc4DOcqt3ldeHOVORELy01Yy+FU0aOLHBaepSh8eB0GVjFHna4dexJ/rEzOa3ibYUSAcPN35wE0DsjZ981UjlouDl/isCm7nhqxg1j6Yt17rwySGnC8rswtMJ6qYAosrnIDV8rSOJuGArFk6635mHcCfzM= flandre@nixos"
              "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCWG77EEgzdtf06bEGQRILRSqA3tSMlYjoh1mY0BZm21mhFb9JiEOIDoQ8ruMXEwASrWcFUo7a6ADpNWRrp8hNjrbHjukSQmReqT4ZPShrOpfy7O96+JiGZAN0mt2reLJ3t+vFyqP+rFTRQ3yOpCRVNJBNjJVymTKhVLYx9llJJP3VSy72rDZGEWt7ZJdINEwGYULHyribG/i2HRuG+xvVkqMDAp6Y12efln8de2zyDU7y0bE1mTU4Dd8WoXYQau1QNnGgddG2nwT11oS20550153hRbZOOJM6ExLqXHHeTCbS/ipNpRCMpcL+dcJBW2sMaMvyEB5FvMyh3yHJQaxmJcPG8yZK7y2oZrdaRMb08UNd84RhCW0dwXE9tZtGZHE6iCxM6v5U7RC3XHVD3xLu+VCl04idG88mBcOE4M576U+agLQbH78+h9D/ydGnYlZTo1WHScK5Qclh0Oiam8YDt+kFvHwnsxkfDCsA3ZBZj9LUOsCicYDSO8pSXWfeBCAU= root@m3-small-x86-01"
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIXTaFR70HlHfuK5nbJSXBFnNZC2oq3a/FjylUPivH7y root@m3-small-x86-01"
            ];
          };
          networking.defaultGateway = {
            address = "85.17.183.190";
            interface = "eth0";
          };
          networking.interfaces = {
            eth0 = {
              ipv4 = {
                addresses = [{
                  address = "85.17.183.144";
                  prefixLength = 26;
                }];
              };
            };
          };
        }
      ];
    };
  };
}
