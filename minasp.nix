{ stdenv
, lib
, fetchFromGitHub
, emacs
, emacsPackages
, Mew-rev ? "v6.9"
, Mew-hash ? "sha256-2iWcsfHRgDpY402Hk/YL6+4vmrstF+yywLAdwEQr9Pg="
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

  minasp-version = "0.1.0";

  minasp-elisp = emacsPackages.trivialBuild {
    pname = "minasp-elisp";
    version = minasp-version;

    src = mew-source;

    sourceRoot = "source/elisp";

    meta = mew-meta;
  };

  minasp-utils = stdenv.mkDerivation {
    pname = "minasp-utils";
    version = minasp-version;

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
