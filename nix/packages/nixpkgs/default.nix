let
  overlay = self: super:
    {
      haskell = super.haskell // {
        packages = super.haskell.packages // {
          ghcjs = super.haskell.packages.ghcjs.extend (hself: hsuper: {
            # Doctest fails to build with a strange error.
            doctest = null;

            # These have test suites which hang indefinitely.
            scientific = super.haskell.lib.dontCheck hsuper.scientific;
            tasty-quickcheck = super.haskell.lib.dontCheck hsuper.tasty-quickcheck;
          });
        };
      };
    };

  nixpkgs-source = builtins.fetchTarball {
    url = "https://releases.nixos.org/nixos/18.09/nixos-18.09.1922.97e0d53d669/nixexprs.tar.xz";
    sha256 = "0jl72zcsap4xjh483mjyvhmim45ghklw3pqr8mp0khwvh83422z6";
  };
in
  import nixpkgs-source {
    overlays = [overlay];
  }
