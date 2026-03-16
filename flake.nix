{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # -- Niri --------------------------- 
    # --------------------------------------------
    niri = {
      url = "github:soulvice/niri";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri-mainline = {
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
    { 
      nixpkgs, 
      niri, 
      niri-mainline, 
      vicinae, 
      vicinae-extensions-soulvice, 
      ghostty, 
      ... 
    }: let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      lib = nixpkgs.lib;
    in {
      packages.${system} = {
        # -- Niri -----------------------------------------------
        niri = niri.packages.${system}.niri;
        niri-mainline = niri-mainline.packages.${system}.niri;

        # -- Vicinae --------------------------------------------
        vicinae = vicinae.packages.${system}.default;

        # -- Ghostty --------------------------------------------
        ghostty = ghostty.packages.${system}.default;

      } // lib.mapAttrs' (n: v: lib.nameValuePair "vicinae-ext-${n}" v) vicinae-extensions-soulvice.packages.${system};

      devShells.${system}.default = pkgs.mkShell {
        packages = [ ];
      };
    };
}