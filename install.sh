#!/bin/sh
# baari installer — no Homebrew required.
#
#   curl --proto '=https' --tlsv1.2 -fsSL https://nauman.github.io/baari-cli-releases/install.sh | sh
#
# Downloads the latest release from github.com/nauman/baari-cli-releases,
# verifies its checksum, and installs the `baari` binary to a directory on
# your PATH. Source stays private; only compiled binaries are ever published
# here.
set -eu

REPO="nauman/baari-cli-releases"
BIN_NAME="baari"

info() { printf 'baari-install: %s\n' "$1"; }
fail() {
  printf 'baari-install: error: %s\n' "$1" >&2
  exit 1
}

detect_platform() {
  os="$(uname -s)"
  arch="$(uname -m)"

  case "$os" in
    Darwin) os="Darwin" ;;
    Linux) os="Linux" ;;
    *) fail "unsupported OS: $os (baari ships prebuilt binaries for macOS and Linux only)" ;;
  esac

  case "$arch" in
    x86_64 | amd64) arch="x86_64" ;;
    arm64 | aarch64) arch="arm64" ;;
    *) fail "unsupported architecture: $arch" ;;
  esac

  printf '%s_%s\n' "$os" "$arch"
}

install_dir() {
  if [ -n "${BAARI_INSTALL_DIR:-}" ]; then
    printf '%s\n' "$BAARI_INSTALL_DIR"
    return
  fi
  if [ -d "$HOME/.local/bin" ] || [ ! -d /usr/local/bin ] || [ ! -w /usr/local/bin ]; then
    printf '%s\n' "$HOME/.local/bin"
  else
    printf '%s\n' /usr/local/bin
  fi
}

main() {
  need_cmd() { command -v "$1" >/dev/null 2>&1 || fail "'$1' is required but not found"; }
  need_cmd curl
  need_cmd tar
  need_cmd uname
  need_cmd mktemp

  platform="$(detect_platform)"
  dest_dir="$(install_dir)"
  mkdir -p "$dest_dir"

  latest_url="https://github.com/${REPO}/releases/latest/download"
  archive="${BIN_NAME}_${platform}.tar.gz"

  work="$(mktemp -d)"
  trap 'rm -rf "$work"' EXIT

  info "downloading ${archive}..."
  curl --proto '=https' --tlsv1.2 -fsSL "${latest_url}/${archive}" -o "${work}/${archive}" \
    || fail "download failed — no release published yet for ${platform}?"

  curl --proto '=https' --tlsv1.2 -fsSL "${latest_url}/checksums.txt" -o "${work}/checksums.txt" \
    || fail "download failed for checksums.txt"

  ( cd "$work" && grep " ${archive}\$" checksums.txt | shasum -a 256 -c - >/dev/null 2>&1 ) \
    || fail "checksum verification failed for ${archive}"

  tar -xzf "${work}/${archive}" -C "$work" "$BIN_NAME"
  chmod +x "${work}/${BIN_NAME}"
  mv "${work}/${BIN_NAME}" "${dest_dir}/${BIN_NAME}"

  info "installed to ${dest_dir}/${BIN_NAME}"

  case ":$PATH:" in
    *":${dest_dir}:"*) ;;
    *) info "note: ${dest_dir} is not on your PATH — add it, e.g. export PATH=\"${dest_dir}:\$PATH\"" ;;
  esac

  "${dest_dir}/${BIN_NAME}" version 2>/dev/null || true
}

main "$@"
