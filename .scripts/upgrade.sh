#!/bin/bash

flatpak update
sudo dnf5 upgrade --refresh --offline
sudo dnf5 offline reboot