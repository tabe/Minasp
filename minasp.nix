{ stdenv
, lib
, buildEnv
, fetchFromGitHub
, emacs
, emacsPackages
}: let

  mew-source = fetchFromGitHub {
    owner = "kazu-yamamoto";
    repo = "Mew";
    rev = "f46b06dba0c7f0aa371be30d704b6d9ba30a8321";
    hash = "sha256-y3/ged8wRNPcGF5smpHc66Eubdrnj/9SF6MobzQBAF0=";
  };

  mew-version = "6.9";

  mew-meta = with lib; {
    description = "Mew: Messaging in the Emacs World";
    homepage = "https://www.mew.org/";
    license = licenses.bsd3;
    inherit (emacs.meta) platforms;
  };

  minasp-elisp = emacsPackages.trivialBuild {
    pname = "minasp-elisp";
    version = mew-version;

    src = mew-source;

    sourceRoot = "source/elisp";

    meta = mew-meta;
  };

  minasp-utils = stdenv.mkDerivation {
    pname = "minasp-utils";
    version = mew-version;

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
