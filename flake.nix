{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # -- Niri --------------------------- 
    # --------------------------------------------
    niri-custom = {
      url = "github:soulvice/niri";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:niri-wm/niri";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # -- Vicinae & Extensions --------------------
    # --------------------------------------------
    vicinae = {
      url = "github:vicinaehq/vicinae";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vicinae-extensions-soulvice = {
      url = "github:soulvice/vicinae-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # -- Ghostty Terminal ------------------------
    # --------------------------------------------
    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, niri, niri-custom, vicinae, vicinae-extensions-soulvice, ghostty,  ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages.${system} = {
        niri-default = niri-custom.packages.${system}.niri;
        niri-mainline = niri.packages.${system}.niri;

        vicinae = vicinae.packages.${system}.vicinae;
        vicinae-ext = vicinae-extensions-soulvice.packages.${system};

        ghostty = ghostty.packages.${system}.default;

        # TODO: add more packages here
      };

      devShells.${system}.default = pkgs.mkShell {
        packages = [ ];
      };
    };
}