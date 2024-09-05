
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    dec.url = "github:bolives-hax/nixos-remote-luks-decryptor/debug";
  };

  outputs = {self,nixpkgs,dec}: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
	  ./hardware-configuration.nix
        dec.nixosModules.default
        {
	 boot.kernelParams = [ "console=ttyS0,115200n8" ];
 boot.loader.grub.extraConfig = "
   serial --speed=115200 --unit=0 --word=8 --parity=no --stop=1
   terminal_input serial
   terminal_output serial
 ";

	#boot.initrd.luks.devices."nixos" = {
	#	device = "/dev/md/md_root";
	#	keyFile = "/luks-keyfile";
	#};
	 boot.initrd.services.swraid = {
    		enable = true;
		mdadmConf = ''
		ARRAY /dev/md/md_root level=raid0 num-devices=4 metadata=1.2 name=s26508:md_root UUID=a452695c:5f0b1a14:b9e67879:007b6dab
   devices=/dev/sda3,/dev/sdb3,/dev/sdc3,/dev/sdd3
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
                peers = [
                  {
                    address = "10.0.0.5";
                    pubkey = "bMzomqOVBFv42pryyN+nUTGT6/I/X1UXvZX7PqZqfn8=";
                  }
                ];
              };
              # pub: ufs7Mz6sHTgGvj8L+SB4gWqd1DMn3q0FrPguDe9MlWI=
              privateKey = "/etc/wireguard/wg0-initrd.priv";
            };
            ssh = {
              authorizedKeys = [
                "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCYdEdmbD/hFDNhv1kBSQhfsIpb8jOQwiIGzfJkCjBchDs3uvsYYDj8imUThrSr4zn/P5/dcSuMFvFlx/CcCWx5/KMNxgArXb6PzYzRKfyzKtsKjZtQIaO4c/7fm9BzO9HuWFZzd3FCxqKbBUxYRMWDV8catvIDxD50Se5hPrTd7vQPFpKVf7MmLnLpNcn894WTSN86U5pZkXDrDxOWyv+lhbPzPgyXnQTWWTUlA9p4bU3tSi5iQBiH36voIbKckOIB2+m2dLBbNFs5B6d0SJDpH/xFCN/xqmpinGCNoRLqk0bKnfW4vKBVJ2h0YC0MJA9q+FjmAwCxC10azHNk8MFU2QlOawWp6gRimdmKcHc4DOcqt3ldeHOVORELy01Yy+FU0aOLHBaepSh8eB0GVjFHna4dexJ/rEzOa3ibYUSAcPN35wE0DsjZ981UjlouDl/isCm7nhqxg1j6Yt17rwySGnC8rswtMJ6qYAosrnIDV8rSOJuGArFk6635mHcCfzM= flandre@nixos"
                "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDQBYWXJmnnhhQlkn0yht1vAZRk023hWlUDtWX3uKsEq2mz6oo91vMhkUMg68FMUxC6nrkursCJJHfAW44wG2kXVYqutHPMa1kD5ZoSDxy/ijt6mWqH9j5xbPjeMzNG++YJf3iYtlc+3MYsdc8mH87k4dJbH+ByVZEud2+tUOqeQcEreQpXDoKJNx+lEqSvBBbIh02ORZqkznSko20nUt9x8YEP4BIvlEkSK7Ka89nnAd33qFKH+OQAun0lz/PL2yWvhMPtyzJW8zmbnnULH/H6MzzWcZwAIiMEiEWkMwIVDtmpSO2u4UYWXpQ3SSKh7uPuudynemMpBCCVQ39naGW1XA0RmmnOPnQWak5aCKNbze61mxAADYrDfj34/RENsQGSf9p8pDG3yoErrHOrDvvM9bC5jp2FOxrocpnwKRmI+y7Q0orAjTVStNSdlmiPXAMLjYQUjK4/9mzjDFkCquuQhQHW20lxWKd7cwTqNOhHi3SFBdANOq5fOtrWdbQLT9U= root@c3-small-x86-01"
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
                "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDQBYWXJmnnhhQlkn0yht1vAZRk023hWlUDtWX3uKsEq2mz6oo91vMhkUMg68FMUxC6nrkursCJJHfAW44wG2kXVYqutHPMa1kD5ZoSDxy/ijt6mWqH9j5xbPjeMzNG++YJf3iYtlc+3MYsdc8mH87k4dJbH+ByVZEud2+tUOqeQcEreQpXDoKJNx+lEqSvBBbIh02ORZqkznSko20nUt9x8YEP4BIvlEkSK7Ka89nnAd33qFKH+OQAun0lz/PL2yWvhMPtyzJW8zmbnnULH/H6MzzWcZwAIiMEiEWkMwIVDtmpSO2u4UYWXpQ3SSKh7uPuudynemMpBCCVQ39naGW1XA0RmmnOPnQWak5aCKNbze61mxAADYrDfj34/RENsQGSf9p8pDG3yoErrHOrDvvM9bC5jp2FOxrocpnwKRmI+y7Q0orAjTVStNSdlmiPXAMLjYQUjK4/9mzjDFkCquuQhQHW20lxWKd7cwTqNOhHi3SFBdANOq5fOtrWdbQLT9U= root@c3-small-x86-01"
            ];
          };
          networking.defaultGateway = {
            address = "85.17.183.190";
            interface = "eth0";
          };
          networking.interfaces = {
            eth0 = {
              ipv4 = {
                addresses = [
                  {
                    address = "85.17.183.144";
                    prefixLength = 26;
                  }
                ];
              };
            };
          };
        }
      ];
    };
  };
}
