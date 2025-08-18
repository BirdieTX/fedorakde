#!/bin/bash

set -e

END='\033[0m\n'
RED='\033[0;31m'
GRN='\033[0;32m'
CYN='\033[0;36m'

printf $CYN"Updating Flatpaks ..."$END
OUT='Flatpaks updated ...'
flatpak update || OUT="Did not update Flatpaks ..."
printf $CYN
echo $OUT
printf $END
printf $CYN"Updating repositories and downloading RPM packages ..."$END
OUT="RPM packages downloaded, run 'sysrb' to perform system upgrade ..."
sudo dnf offline-upgrade --refresh download || OUT="Did not download RPM packages ..."
printf $CYN
echo $OUT
printf $END
fastfetch -c neofetch
