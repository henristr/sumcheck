#!/bin/sh
set -e

REPO="henristr/sumcheck"
BIN="sumcheck"

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

case "$ARCH" in
  x86_64) ARCH="amd64" ;;
  aarch64|arm64) ARCH="arm64" ;;
  *) echo "Nicht unterstützte Architektur: $ARCH"; exit 1 ;;
esac

case "$OS" in
  linux|darwin) EXT="tar.gz" ;;
  *) echo "Für Windows bitte PowerShell-Befehl nutzen"; exit 1 ;;
esac

URL=$(curl -s "https://api.github.com/repos/$REPO/releases/latest" \
  | grep "browser_download_url.*${OS}_${ARCH}.${EXT}" \
  | cut -d '"' -f4)

echo "Lade $URL ..."
curl -sL "$URL" -o /tmp/$BIN.tar.gz
sudo tar -xzf /tmp/$BIN.tar.gz -C /usr/local/bin $BIN
rm /tmp/$BIN.tar.gz

echo "$BIN installiert nach /usr/local/bin/$BIN"
