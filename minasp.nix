{ stdenv
, lib
, fetchFromGitHub
, emacs
, emacsPackages
, Mew-rev ? "v6.10"
, Mew-hash ? "sha256-p1QcnHoXdI4N7ewc5PQdq909wfKKiVFwdAyK6UPJUo0="
}: let

  mew-source = fetchFromGitHub {
    owner = "kazu-yamamoto";
    repo = "Mew";
    rev = Mew-rev;
    hash = Mew-hash;
  };

  mew-meta = with lib; {
    description = "Mew: Messaging in the Emacs World";
    homepage = "https://www.mew.org/";
    license = licenses.bsd3;
    inherit (emacs.meta) platforms;
  };

  minasp-version = "0.6.10";

  minasp-elisp = emacsPackages.trivialBuild {
    pname = "minasp-elisp";
    version = "${minasp-version}-${Mew-rev}";

    src = mew-source;

    buildFlags = [ "elisp" ];

    # Modified nixpkgs's pkgs/build-support/emacs/trivial.nix
    installPhase = ''
      runHook preInstall

      LISPDIR=$out/share/emacs/site-lisp/mew
      install -d $LISPDIR
      install elisp/*.el elisp/*.elc $LISPDIR
      emacs --batch -l package --eval "(package-generate-autoloads \"mew\" \"$LISPDIR\")"
      cp -r etc $LISPDIR/

      runHook postInstall
    '';

    meta = mew-meta;
  };

  minasp-utils = stdenv.mkDerivation {
    pname = "minasp-utils";
    version = "${minasp-version}-${Mew-rev}";

    src = mew-source;

    configureFlags = [ "--without-emacs" ];

    buildFlags = [ "bin" ];

    installTargets = [ "install-bin" ];

    meta = mew-meta;
  };

in {
  elisp = minasp-elisp;
  utils = minasp-utils;
}
