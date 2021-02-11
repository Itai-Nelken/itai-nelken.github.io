#!/bin/bash

function error() {
  echo -e "$(tput setaf 1)$(tput bold)$1$(tput sgr 0)"
}

# flags. default is to update with extra output and ask to exit.
if [[ "$1" == "--version" ]] || [[ "$1" == "-v" ]]; then
  echo -e "
  $(tput setaf 9)###############################################
  $(tput setaf 9)#$(tput setaf 4)$(tput bold)add-repo.sh version 1.0 by Itai-Nelken | 2021$(tput sgr 0)$(tput setaf 9)#
  $(tput setaf 9)###############################################$(tput sgr 0)
  "
  exit 0
elif [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
  echo -e "
    $(tput setaf 6)$(tput bold)USAGE:$(tput sgr 0)
    $(tput bold)intended usage:$(tput sgr 0)
    wget -qO- https://itai-nelken.github.io/my-repo/add-repo.sh | sudo bash

    $(tput setaf 6)$(tput bold)Extra commands that have no use:$(tput sgr 0)
    --version or -v - print version and exit.
    --help or -h - print this help and exit.
  "
  exit 0
fi

#check that script is being run as root
if [ ! "$EUID" = 0 ]; then
    error "The script wasn't run as root!"
    echo "$(tput bold)you NEED to run this script as root!$(tput sgr 0)"
    exit 1
fi

#check if host system is ARM
ARCH="`uname -m`"
if [[ "$ARCH" != "armv7l" ]] && [[ "$ARCH" != "aarch64" ]]; then
  error "ERROR: This script is only intended for arm devices!"
  exit 1
fi

echo -e "$(tput setaf 6)adding repo...$(tput sgr 0)"
echo ' + echo "deb [trusted=yes] https://itai-nelken.github.io/my-repo/ /" | tee -a /etc/apt/sources.list > /dev/null'
echo "deb [trusted=yes] https://itai-nelken.github.io/my-repo/ /" | tee -a /etc/apt/sources.list > /dev/null
echo -e "$(tput setaf 6)running apt update...$(tput sgr 0)"
echo " + sudo apt update"
sudo apt update
echo -e "$(tput setaf 2)DONE!$(tput sgr 0)"
echo -e "$(tput setaf 6)$(tput bold)ALL APPS$(tput sgr 0)"
echo " - hello-world"
echo "   * print hello world on the screen, written in c."
echo " - count100"
echo "   * count to 100 and back and print the output on the screen, written in c."
echo " - qemu2deb"
echo "   * compile, install, and package into a deb the latest version of QEMU, written in bash."
echo " - pi-temp"
echo "   * print current the Raspberry Pi's CPU temperature, updates in 1 second intervals. written in bash."
echo " - cpu-clock"
echo "   * print current the Raspberry Pi's CPU clock speed, updates in 1 second intervals. written in bash."