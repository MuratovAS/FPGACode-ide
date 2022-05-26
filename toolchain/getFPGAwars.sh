#!/bin/sh
set -e -u

githubLatestTag() {
  latestUrl=$(curl "https://github.com/$1/releases/latest" -s -L -I -o /dev/null -w '%{url_effective}')
  printf "%s\n" "${latestUrl##*v}"
}

platform=''
machine=$(uname -m)

if [ "${GET_PLATFORM:-x}" != "x" ]; then
  platform="$GET_PLATFORM"
else
  case "$(uname -s | tr '[:upper:]' '[:lower:]')" in
    "linux")
      case "$machine" in
        "arm64"* | "aarch64"* ) platform='linux_aarch64' ;;
        "arm"* | "aarch"*) platform='linux_armv7l' ;;
        *"86") platform='linux_x86_64' ;;
        *"64") platform='linux_x86_64' ;;
        *"686") platform='linux_i686' ;;
      esac
      ;;
    "darwin") platform='darwin' ;;
    "msys"*|"cygwin"*|"mingw"*|*"_nt"*|"win"*)
      case "$machine" in
        *"86") platform='windows_x86' ;;
        *"64") platform='windows_amd64' ;;
      esac
      ;;
    esac
fi

if [ "x$platform" = "x" ]; then
cat << 'EOM'
  =========================
  COULD NOT DETECT PLATFORM
  =========================
  Export your selection as the GET_PLATFORM environment variable, and then
  re-run this script.
  For example:
    $ export GET_PLATFORM=linux64
  =========================
EOM
  exit 1
else
  printf "Detected platform: %s\n" "$platform"
fi

#if [ "x$platform" = "xwin64" ] || [ "x$platform" = "xwin32" ]; then
#  extension='zip'
#else
  extension='tar.gz'
#fi

for I; do
  TAG=$(githubLatestTag FPGAwars/$I)
  printf "Package: %s\n" "$I"
  printf "Latest Version: %s\n" "$TAG"
  printf "Downloading https://github.com/FPGAwars/$I/releases/download/v$TAG/$I-$platform-$TAG.$extension\n"
  curl -L "https://github.com/FPGAwars/$I/releases/download/v$TAG/$I-$platform-$TAG.$extension" > "$I.$extension"
  printf "\n"
done
