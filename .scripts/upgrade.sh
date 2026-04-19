#!/bin/bash

flatpak update
sudo dnf5 upgrade --refresh --offline
sudo fwupdmgr update
sudo dnf5 offline reboot
