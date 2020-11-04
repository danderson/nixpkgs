{ pkgs, lib, buildGoModule, fetchFromGitHub, yarn2nix-moretea, ... }:
buildGoModule rec {
  pname = "influxdb";
  version = "2.0.0-rc.3";
  
  src = fetchFromGitHub {
    owner = "influxdata";
    repo = pname;
    rev = "v${version}";
    sha256 = "0gvpx6nxl1rba3idhw4w8vq29zm81v3f0wfnyl44qb2a6p8fjins";
  };

  yarnCache = yarn2nix-moretea.importOfflineCache (yarn2nix-moretea.mkYarnNix {
    yarnLock = "${src}/ui/yarn.lock";
  });

  nativeBuildInputs = with pkgs; [ pkg-config breezy protobuf yarn rustc yarn2nix less git nodejs ];

  vendorSha256 = "1xwc1yqg9c361ml3d0bah5spcdqgkdql3p9gzq28i79nhpk10hpf";

  postConfigure = ''
    export HOME=$PWD/yarn_home
    yarn config --offline set yarn-offline-mirror ${yarnCache}
    ${yarn2nix-moretea.fixup_yarn_lock}/bin/fixup_yarn_lock ui/yarn.lock
    sed -i -e 's/yarn/yarn --offline --frozen-lockfile --ignore-scripts/g' ui/Makefile ui/package.json
    yarn bin
    export PATH=`pwd`/node_modules/.bin:$PATH
  '';

  # preBuild = ''
  #   (cd ui && yarn --offline --frozen-lockfile --ignore-engines --ignore-scripts build)
  # '';

  buildPhase = ''
    make
  '';
    
  doCheck = false;
}
