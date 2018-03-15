#!/bin/bash

CONNECTED=$(kdeconnect-cli --list-available --id-only 2>/dev/null)

if [ "$CONNECTED" ]
then
  echo 
else
  echo ""
fi
