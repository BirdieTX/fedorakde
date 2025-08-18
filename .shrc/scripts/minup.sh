#!/bin/bash

set -e

END='\033[0m\n'
RED='\033[0;31m'
GRN='\033[0;32m'
CYN='\033[0;36m'

printf $CYN"Checking for security updates and bug fixes ..."$END
OUT="RPM packages downloaded, run 'sysrb' to perform system upgrade ..."
sudo dnf upgrade --refresh --minimal --offline || OUT="Did not download RPM packages ..."
printf $CYN
echo $OUT
printf $END
fastfetch -c neofetch
