{
  description = "Flake for setting up default sini-horse machine";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux"; # Adjust if needed (e.g., "aarch64-linux" for ARM)
      pkgs = import nixpkgs { inherit system; };
      # Override nnn to compile with O_NERD=1
      nnn-nerd = pkgs.nnn.overrideAttrs (oldAttrs: {
        makeFlags = (oldAttrs.makeFlags or []) ++ [ "O_NERD=1" ];
      });
    in
    {
      packages.${system}.default = pkgs.buildEnv {
        name = "sini-horse-env";
        paths = with pkgs; [
          zellij
          fish
          lazydocker
          lazygit
          neovim
          nnn-nerd
	  gcc
	  fzf
	  jq
          fd
        ];
      };
    };
}
