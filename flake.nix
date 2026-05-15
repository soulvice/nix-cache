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

    niri-flake = {
      url = "github:soulvice/niri-flake";
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

    # -- MISC PACKAGES ---------------------------
    # --------------------------------------------
    sf-mono-liga-src = {
      url = "github:shaunsingh/SFMono-Nerd-Font-Ligaturized";
      flake = false;
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
      niri-flake,
      sf-mono-liga-src,
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

      } 
      // lib.mapAttrs' (n: v: lib.nameValuePair "vicinae-ext-${n}" v) vicinae-extensions-soulvice.packages.${system}
      // {
        sf-mono-liga-bin = pkgs.stdenvNoCC.mkDerivation rec {
          pname = "sf-mono-liga-bin";
          version = "dev";
          src = sf-mono-liga-src;
          dontConfigure = true;
          installPhase = ''
            mkdir -p $out/share/fonts/opentype
            cp -R $src/*.otf $out/share/fonts/opentype/
          '';

          nativeBuildInputs = with pkgs; [ unzip ];

          meta = with lib; {
            description = "Patched SF Mono fonts for programming";
            homepage = "https://github.com/shaunsingh/SFMono-Nerd-Font-Ligaturized";
            license = licenses.mit;
            maintainers = [ maintainers.soulvice ];
          };
        };
      };

      devShells.${system}.default = pkgs.mkShell {
        packages = [ ];
      };

      homeModules = {
        niri = niri-flake.homeModules.niri;
        vicinae = vicinae.homeManagerModules.default;
      };

      nixosModules = {
        niri = niri-flake.nixosModules.niri;
      };

      overlays = {
        vicinae = vicinae.overlays.default;
        niri = niri.overlays.default;
        niri-mainline = niri-mainline.overlays.default;
        ghostty = ghostty.overlays.default;
      };
    };
}