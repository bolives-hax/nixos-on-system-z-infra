{pkgs,...}: {
	services.hydra = {
		enable = true;
		hydraURL = "http://85.17.183.144:3000";
		buildMachinesFiles = [
		];
		useSubstitutes = true;
		notificationSender = "hydra@localhost";
	};
	environment.defaultPackages = [ pkgs.git ];
	services.nginx = {
		enable = true;
		virtualHosts = {
			"85.17.183.144" = {
				locations."~ /*" = {
					proxyPass = "http://85.17.183.144:3000";
				};
			};
		};
	};
	    nix.extraOptions = ''
    experimental-features = nix-command flakes
    '';
	nix.settings.allowed-uris = [
  "github:"
  "git+https://github.com/"
  "git+ssh://github.com/"
  "path:/etc/nixos/nixpkgs?lastModified=1725572005&narHash=sha256-67wqIbuU4kGjpGqwf2g9liJvxvFTDjoniqFAYhFERao%3D"
"path:"
];
}
