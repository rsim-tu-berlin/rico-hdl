{
  lib,
  nix-filter,
  rustPlatform,
  pkg-config,
  clang,
  llvmPackages,
  gdalMinimal,
  llvmPackages_latest,
  version ? "git",
}:
rustPlatform.buildRustPackage {
  pname = "rs-tensor-encoder";
  inherit version;

  src = nix-filter {
    root = ../.;
    include = ["src" "Cargo.lock" "Cargo.toml"];
  };
  cargoSha256 = "sha256-YnXRoxjovPXWyqZsDcduhNDpfRbDz5HNMGSeczQWakg=";
  nativeBuildInputs = [
    pkg-config
    clang
    llvmPackages.bintools
  ];
  buildInputs = [
    # rustc & cargo already added by buildRustPackage
    gdalMinimal
  ];
  BINDGEN_EXTRA_CLANG_ARGS = [
    ''
      -I"${llvmPackages_latest.libclang.lib}/lib/clang/${llvmPackages_latest.libclang.version}/include"''
  ];
  LIBCLANG_PATH =
    lib.makeLibraryPath
    [llvmPackages_latest.libclang.lib];
  meta = {
    description = "A deep-learning tensor encoder tool for remote sensing datasets.";
    homepage = "https://github.com/kai-tub/rs-tensor-encoder";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [kai-tub];
    mainProgram = "rs-tensor-encoder";
  };
}