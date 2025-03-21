{
  description = "A Nix Flake for PiDP-10 utility software.";

  # This can and should be modified if you want to use a
  # different channel.
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });

      # Change the below values for your own setup!
      pidpremote = "XXX.XXX.XXX.XXX";
      piuser = "pi";
    in
      {
        packages = forAllSystems (system:
          let
            pkgs = nixpkgsFor.${system};

            stdBuild = "make -j $NIX_BUILD_CORES $pname";
            stdInstall = "mkdir -p $out/bin; mv $pname $out/bin";
          in
            (with pkgs;
              {
                dp3300 = stdenv.mkDerivation {
                  pname = "dp3300";
                  version = "1.0";
                  src = fetchgit {
                    url = "https://github.com/aap/vt05";
                    sha256 = "sha256-4k90WvcBChZi3zHiCreWNVEEy2qmlG/dBQz2Uqv/GYM=";
                  };
                  nativeBuildInputs = [ gnumake SDL2 ];
                  buildPhase = stdBuild;
                  installPhase = stdInstall;
                };

                imlac = stdenv.mkDerivation rec {
                  pname = "imlac";
                  version = "1.0";
                  src = fetchFromGitHub {
                    owner = "open-simh";
                    repo = "simh";
                    rev = "master";
                    hash = "sha256-e0S/qz38WDCY3sCAsOXsQfyQ/IwRZwM0G7uRdV64QxY=";
                  };
                  doCheck = true;
                  nativeBuildInputs = [
                    SDL2
                    SDL2_image
                    SDL2_mixer
                    SDL2_net
                    SDL2_ttf
                    iconv
                    libpcap
                    libpng
                    pcre
                    pkg-config
                    which
                    xorg.libX11
                    xorg.libXft
                    zlib
                  ];
                  LIBRARIES = "/lib:${SDL2}/lib:${SDL2_ttf}/lib:${libpng}/lib:${SDL_net}/lib:${SDL_image}/lib:${SDL_mixer}/lib:${libpcap}/lib:${pcre}/lib:${xorg.libX11}/lib:${xorg.libXft}/lib";
                  NIX_LDFLAGS = "-lm -lz";
                  buildPhase = ''
                    substituteInPlace makefile --replace-quiet '/sbin/ldconfig' 'ldconfig'
                    substituteInPlace makefile --replace-quiet 'grep -A 10' 'grep -A 100'
                    make imlac
                  '';
                  imlacSimh = writeText "imlac.simh" ''
                    attach -u tty 12345,connect=${pidpremote}:10003;notelnet
                    set rom type=stty
                    load -s TARGET
                    reset
                    go
                  '';
                  installPhase = ''
                    mkdir -p $out/bin

                    # There has GOT to be a better way to do this, but the issue
                    # is if TARGET is set in the variable above, it will point to
                    # the wrong place after the symlinkJoin.
                    cat ${imlacSimh} | sed "s,TARGET,$out/ssv22.iml," > $out/imlac.simh
                    cp imlac/tests/ssv22.iml $out/ssv22.iml

                    cp BIN/imlac $out/bin
                  '';
                };

                sty = stdenv.mkDerivation {
                  pname = "sty";
                  version = "0.9";
                  src = fetchgit {
                    url = "https://github.com/obsolescence/pidp10";
                    sha256 = "sha256-EPp6ziR5CaTFzigoLLew8fGjBNy9h8SKi6VsEEiu01Q=";
                  };
                  buildInputs = [
                    xorg.libX11
                    xorg.libXft
                  ];
                  nativeBuildInputs = [
                    fontconfig
                    freetype
                    gnumake
                    pkg-config
                    SDL2
                    SDL2_image
                    SDL2_mixer
                    SDL2_ttf
                  ];
                  patchPhase = ''
                    # For our first order of business, the sounds
                    # have to live somewhere, but we have no /opt.
                    SRC=src/sty33
                    NIX_DEST=$out/sounds

                    # Since the WAV locations were hard-coded,
                    # we need to update them.
                    sed -i "s,/opt/pidp10/bin/sounds,$NIX_DEST,g" $SRC/sounds.c

                    # And now to do some dodgy things to config.mk.
                    sed -i 's/-lrt//' $SRC/config.mk

                    # This seems to only affect the Mac environment.
                    if [ ${system} == "aarch64-darwin" ]; then
                      sed -i 's/,--allow-shlib-undefined//' $SRC/config.mk
                    fi

                    sed -i -e 's/PKG_CONFIG = pkg-config//; /# Customize below to fit your system/a\' \
                    -e 'PKG_CONFIG = pkg-config \
                    CFLAGS := $(CFLAGS) `$(PKG_CONFIG) --cflags sdl2 SDL2_image SDL2_mixer SDL2_ttf` \
                    LDFLAGS := $(LDFLAGS) `$(PKG_CONFIG) --libs sdl2 SDL2_image SDL2_mixer SDL2_ttf`' $SRC/config.mk
                  '';
                  buildPhase = ''
                    mkdir -p $NIX_DEST

                    cd $SRC
                    cp sounds/*.wav $NIX_DEST

                    make -j $NIX_BUILD_CORES
                  '';
                  installPhase = stdInstall;
                };

                supdup = stdenv.mkDerivation {
                  pname = "supdup";
                  version = "1.0";
                  src = fetchgit {
                    url = "https://github.com/PDP-10/supdup";
                    sha256 = "sha256-5ep1/czMay3hq1VFD75ljVvSgcHMVEJJx3tyfv0ywaI=";
                  };
                  nativeBuildInputs = [ gnumake ncurses pkg-config ];
                  buildPhase = stdBuild;
                  installPhase = stdInstall;
                };

                tek4010 = stdenv.mkDerivation {
                  pname = "tek4010";
                  version = "1.0";
                  src = fetchgit {
                    url = "https://github.com/rricharz/Tek4010";
                    sha256 = "sha256-4QTbCR+AC8dp9eIOfqoQWRh8JmU3Ivce3HEQT1qWoSw=";
                  };
                  nativeBuildInputs = [ cairo gnumake gtk3 pkg-config ];
                  buildPhase = stdBuild;
                  installPhase = stdInstall;
                };

                tvcon = stdenv.mkDerivation {
                  pname = "tvcon";
                  version = "1.0";
	                src = fetchgit {
	                  url = "https://github.com/aap/pdp11";
                    sha256 = "sha256-qLRuIzE+r/8L7J/IqVNZ5EX5rblpLxp+aOcTdCkxsuc=";
                  };
                  nativeBuildInputs = [ gnumake SDL2 SDL2_net ];
                  prePatch = "cd tvcon";
                  buildPhase = stdBuild;
                  installPhase = stdInstall;
                };

                vt52 = stdenv.mkDerivation {
                  pname = "vt52";
                  version = "1.0";
                  src = fetchgit {
                    url = "https://github.com/aap/vt05";
                    sha256 = "sha256-4k90WvcBChZi3zHiCreWNVEEy2qmlG/dBQz2Uqv/GYM=";
                  };
                  nativeBuildInputs = [ gnumake SDL2 ];
                  buildPhase = stdBuild;
                  installPhase = stdInstall;
                };

                rpdp = pkgs.writeShellScriptBin "rpdp" ''
echo "remote connection to ${pidpremote}"

if [ $# -eq 0 ]; then
    echo "ssh into ${pidpremote}. Assumes the PDP-10 simulation is indeed running."
    echo "opening virtual screen terminal, Ctrl-A d to leave."
    ssh -t ${piuser}@${pidpremote} 'pdp'
else
    case $1 in
        con)
            nohup sty -e telnet ${pidpremote} 1025 > /dev/null 2>&1 &
            ;;
        telcon)
            nohup xterm -e "telnet ${pidpremote} 1025" > /dev/null 2>&1 &
            ;;
        vt52)
            nohup vt52 -B telnet ${pidpremote} 10018 > /dev/null 2>&1 &
            ;;
        tvcon)
            nohup tvcon -2BS ${pidpremote} > /dev/null 2>&1 &
            ;;
        imlac)
            echo "ITS tip: don't forget to enter :tctyp oimlac after logging in"
            nohup imlac ${self.packages.${system}.imlac}/imlac.simh > /dev/null 2>&1 &
            ;;
        tek)
            nohup tek4010 -b9600 telnet ${pidpremote} 10017 > /dev/null 2>&1
            ;;
        dp3300)
            nohup dp3300 -a -B telnet ${pidpremote} 10020 > /dev/null 2>&1 &
            ;;
        *)
            echo rpdp for remote PiDP-10. Options are:
            echo  [con telcon vt52 tvcon tek dp3300 imlac]
            echo when run without options,
            echo  pdp brings you into simh - Ctrl-A d to leave.
            echo
            echo edit flake.nix to change hostname and username
            echo for your PiDP-10.
            ;;
    esac
fi
                '';

                nix-rpdp = symlinkJoin {
                  name = "nix-rpdp";
                  paths = [
                    inetutils

                    self.packages.${system}.dp3300
                    self.packages.${system}.imlac
                    self.packages.${system}.rpdp
                    self.packages.${system}.sty
                    self.packages.${system}.supdup
                    self.packages.${system}.tek4010
                    self.packages.${system}.tvcon
                    self.packages.${system}.vt52
                  ];
                };

                default = self.packages.${system}.nix-rpdp;
              }));
      };
}
