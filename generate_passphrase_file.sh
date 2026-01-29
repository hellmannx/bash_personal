#!/bin/bash

ENC=0
DECYRPT=0

while [[ $# -gt  0 ]]; do
  case "$1" in
    -e|--encrypt)
      FILENAME=$2
      echo "$FILENAME"
      ENC=1
      shift
      shift
      ;;
    -d|--decrypt)
      FILENAME=$2
      echo "$FILENAME"
      DECYRPT=1
      shift
      shift
      ;;
  esac
done

echo "debug echo filename $FILENAME"

if [[ $ENC -eq 0 && $DECYRPT -eq 0 ]]; then
  echo "process exits"
  exit

elif [[ $ENC -eq 1 && $DECYRPT -eq 0 ]]; then

  head -c 128 /dev/urandom > keyfile.bin

  chmod 600 keyfile.bin

  gpg -c \
    --cipher-algo AES256 \
    --passphrase-file keyfile.bin \
    --pinentry-mode loopback \
    --batch \
    $FILENAME 

elif [[ $ENC -eq 0 && $DECYRPT -eq 1 ]]; then

  gpg -d \
    --passphrase-file keyfile.bin \
    --pinentry-mode loopback \
    --batch \
    $FILENAME
    

else
  echo "There is a logical flaw"
  exit
fi





