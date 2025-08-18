#!/bin/bash

set -e

END='\033[0m\n'
RED='\033[0;31m'
GRN='\033[0;32m'
CYN='\033[0;36m'

printf $CYN"Rebooting system to perform offline upgrade ..."$END
OUT='System rebooting ...'
sudo dnf5 offline-upgrade reboot  || OUT="Failed to initialize offline upgrade ..."
printf $CYN
echo $OUT
printf $END