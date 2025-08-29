#!/bin/bash

##############################################################################
# FILE: install.sh                                                           #
##############################################################################

#23456789012345678901234567890123456789012345678901234567890123456789012345678

#
# ABOUT: 
# This script installs the CODEXIUM software.
# This script should be run as root.
#

umask 0002 

DATE=$(date +Y%YM%mD%dh%Hm%M)

BASE="/www"
THIS_DIR=$(dirname $0)

source ${THIS_DIR}/help.include
source ${THIS_DIR}/display_functions.include

DisplaySection "CODEXium : Installation Started"
#
echo ""
#
if [[ $USER != "root" ]]
then
  DisplaySection "CODEXium : REQUIRED : ROOT"
  echo ""
  echo "Make sure you are the root user."
  echo "# sudo su -"
  echo "OR"
  echo "# su -"
  echo "OR"
  echo "Login as root"
  echo ""
  echo "EXITING"
  exit
fi

#
#X13# # Look for a loaded ssh key
#X13# #
#X13# ssh-add -l 2>/dev/null 1>&2
#X13# if (( $? ))
#X13# then
#X13#   #
#X13#   # ssh keyring not working and no key found
#X13#   #
#X13#   echo "WARNING: No key loaded"
#X13#   echo "HINT: ssh-agent bash # This will enable the keyring"
#X13#   echo "HINT: ssh-add ~/.ssh/CODEXium.key"
#X13#   echo "HINT: ssh-add -l # This should list the key just added"
#X13#   echo "OR"
#X13#   echo "HINT: git config core.sshcommand 'ssh -i ~/.ssh/CODEXium.key'"
#X13#   echo "HINT: check with \"git config --list\""
#X13#   echo ""
#X13#   echo "OK: CONTINUING: We will assume a key is configured."
#X13#   echo ""
#X13# fi

#
# Check Environment and Call Correct Installer
#
rpm --version 2>/dev/null 1>&2
# RPM will be 0 
# DEB will be 127
if (( $? )) 
then
  TYPE="DEB"
  #
  # Run "install_deb.sh"
  #
  #${THIS_DIR}/install_deb.sh | tee ${THIS_DIR}/OUTPUT_install_deb_${DATE}.txt
  echo ""
  echo "Debian will be supported soon."
  echo ""
else
  #
  # Run "install_rpm.sh"
  #
  TYPE="RPM"
  ${THIS_DIR}/install_rpm.sh | tee ${THIS_DIR}/OUTPUT_install_rpm_${DATE}.txt
fi
