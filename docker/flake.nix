{
	description = "Flake for setting up Docker and Docker Compose";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
	};

	outputs = { self, nixpkgs }:
		let
			system = "x86_64-linux";
			pkgs = import nixpkgs { inherit system; };
		in
			{
			packages.${system}.default = pkgs.buildEnv {
				name = "docker-env";
				paths = with pkgs; [
					docker
					d:ocker-compose
				];
			};
		};
}
