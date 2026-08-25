#!/bin/sh
# baari installer — no Homebrew required.
#
#   curl --proto '=https' --tlsv1.2 -fsSL https://nauman.github.io/baari/install.sh | sh
#
# Downloads the latest release from github.com/nauman/baari,
# verifies its checksum, and installs the `baari` binary to a directory on
# your PATH. Source stays private; only compiled binaries are ever published
# here.
#
# THIS IS ALSO THE UPGRADE PATH. Re-running it replaces an existing binary
# with the latest release and says which version it moved you from and to.
# `baari upgrade` runs exactly this script, so there is one code path for
# install and update rather than two that can rot apart.
#
# If you installed with Homebrew, use `brew upgrade nauman/tap/baari` instead;
# this script refuses to overwrite a Homebrew-managed binary.
set -eu

REPO="nauman/baari"
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

  # macOS ships `shasum` (perl); most Linux distros ship `sha256sum` and have no
  # `shasum` at all. Resolve the checker BEFORE using it, so a missing tool
  # reports itself instead of surfacing as "checksum verification failed" —
  # which reads like a tampered download rather than a missing dependency.
  if command -v sha256sum >/dev/null 2>&1; then
    sha_check() { sha256sum -c - >/dev/null 2>&1; }
  elif command -v shasum >/dev/null 2>&1; then
    sha_check() { shasum -a 256 -c - >/dev/null 2>&1; }
  else
    fail "need 'sha256sum' or 'shasum' to verify the download; install either and re-run"
  fi

  expected="$(grep " ${archive}\$" "${work}/checksums.txt" || true)"
  [ -n "$expected" ] || fail "no checksum listed for ${archive} in checksums.txt"

  ( cd "$work" && printf '%s\n' "$expected" | sha_check ) \
    || fail "checksum verification failed for ${archive} — refusing to install"

  tar -xzf "${work}/${archive}" -C "$work" "$BIN_NAME"
  chmod +x "${work}/${BIN_NAME}"

  # What is already there decides whether this is an install or an upgrade,
  # and whether it is ours to replace at all.
  target="${dest_dir}/${BIN_NAME}"
  previous=""
  if [ -e "$target" ]; then
    resolved="$target"
    if command -v readlink >/dev/null 2>&1; then
      resolved="$(readlink "$target" 2>/dev/null || printf '%s' "$target")"
    fi
    case "$resolved" in
      */Cellar/*|*/homebrew/*|*/linuxbrew/*)
        fail "$target is managed by Homebrew — upgrade with: brew upgrade nauman/tap/baari" ;;
    esac
    previous="$("$target" version 2>/dev/null | tr -d '\n' || true)"
  fi

  mv "${work}/${BIN_NAME}" "$target"
  installed="$("$target" version 2>/dev/null | tr -d '\n' || echo "$BIN_NAME")"

  # Never report "installed" for what was actually a no-op or a downgrade --
  # a silent success is indistinguishable from a broken update.
  if [ -z "$previous" ]; then
    info "installed ${installed} to ${target}"
  elif [ "$previous" = "$installed" ]; then
    info "already current: ${installed} (re-installed in place at ${target})"
  else
    info "upgraded ${previous} -> ${installed} at ${target}"
  fi

  case ":$PATH:" in
    *":${dest_dir}:"*) ;;
    *) info "note: ${dest_dir} is not on your PATH — add it, e.g. export PATH=\"${dest_dir}:\$PATH\"" ;;
  esac
}

main "$@"
