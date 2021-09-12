#!/bin/bash
#
# See https://github.com/nextcloud/desktop/issues/1011
#
############################################
# Adjust the following to suit your needs
WALLET="kdewallet"   # Name of wallet storing nextcloud client password
MAX_TRIES=2          # Max. number of tries to ask for password
############################################
i=0
while [ $i -lt $MAX_TRIES ]; do
  ((i++))
  open=`qdbus org.kde.kwalletd5 /modules/kwalletd5 isOpen "$WALLET" | grep true`
  if [ -n "$open" ]; then
    break
    nohup nextcloud >> /dev/null 2>&1
  fi
  qdbus org.kde.kwalletd5 /modules/kwalletd5 open "$WALLET" 0 "nextcloud-client-starter" > /dev/null
done
