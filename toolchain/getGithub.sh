#!/bin/sh
set -e -u

githubLatestTag() {
  latestUrl=$(curl "https://github.com/$1/releases/latest" -s -L -I -o /dev/null -w '%{url_effective}')
  printf "%s\n" `echo $latestUrl | sed -n '{s@.*/@@; p}'`
}

platform=''
machine=$(uname -m)

if [ "${GET_PLATFORM:-x}" != "x" ]; then
  platform="$GET_PLATFORM"
else
  case "$(uname -s | tr '[:upper:]' '[:lower:]')" in
    "linux")
      case "$machine" in
        "arm64"* | "aarch64"* ) platform='aarch64-linux-gnu' ;;
        "arm"* | "aarch"*) platform='arm-linux-gnueabihf' ;;
        *"86") platform='x86_64-linux-gnu' ;;
        *"64") platform='x86_64-linux-gnu' ;;
      esac
      ;;
    "darwin") platform='x86_64-apple-darwin' ;;
    "msys"*|"cygwin"*|"mingw"*|*"_nt"*|"win"*)
      case "$machine" in
        *"86") platform='x86_64-w64-mingw32' ;;
        *"64") platform='x86_64-w64-mingw32' ;;
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
#  extension='tar.gz'
  extension=''
#fi


TAG=$(githubLatestTag $1)
OUTPUT_FILE=`echo "$2" | sed -n '{s@.*/@@; p}'`
printf "Package: %s\n" "$1"
printf "Latest Version: %s\n" "$TAG"
URL_FILE="https://github.com/$1/releases/download/$TAG/$OUTPUT_FILE-$platform-$TAG$extension"
printf "Downloading $URL_FILE"
curl -L "$URL_FILE" > "$2$extension"
printf "\n"

