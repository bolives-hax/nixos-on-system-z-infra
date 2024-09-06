{ pkgs, ... }: {
  environment.defaultPackages = with pkgs; [
    git # do via programs.git
    nixfmt
    neovim # use vim module instead
  ];
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
}
