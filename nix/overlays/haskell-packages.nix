pkgsFinal: pkgsPrev:

let
  overrideHaskellPackages = attrs:
    import ../lib/override-haskell-packages.nix attrs pkgsFinal pkgsPrev;

  dereference = path:
    let
      dirname = builtins.dirOf path;
      basename = builtins.baseNameOf path;
    in
    pkgsPrev.runCommandLocal "dereference-${basename}" { } ''
      cd ${dirname}
      ${pkgsFinal.coreutils}/bin/cp -r --dereference ${basename} $out
    '';

in
overrideHaskellPackages {
  packages = {
    "sidekick" = dereference ../../sidekick;
    "sidekick-ghci" = dereference ../../sidekick-ghci;

    "optics" = "0.4";
    "optics-core" = "0.4";
    "optics-extra" = "0.4";
    "optics-th" = "0.4";
  };

  overrideCabal = {
    # TODO: Fix tests failing in Nix
    "sidekick-ghci" = old: { doCheck = false; };

    "streamly-fsnotify" = old: {
      broken = false;
      jailbreak = true;
    };
  };

  hackage = {
    rev = "feae602db08e48b1d1a716fc9c4c8348aa5df17a";
    sha256 = "0m7qr2nmfj6lbf9h6wfyapphcqwarqw3319zkdxqwzhbis81hlcb";
  };
}
