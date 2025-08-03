#!/bin/sh

##############################################################################
### FILE: update.sh                                                        ###
##############################################################################
#
# ABOUT: 
# This script updates the CODEXium software.
# This script should be run as root.
#


umask 0002 # Copying with different umask settings will create a git diff

DATE=$(date +Y%Y.M%m.D%d.h%H.m%M)

BASE="/www"
CORE="${BASE}/CDX-CORE" # Contains base repo
EXTRAS="${BASE}/CDX-ADDON" # Contains multiple repos
PROD="${BASE}/codexium" # Is not a git repo
THIS_DIR=$(dirname $0)

source ${THIS_DIR}/display_functions.include
source ${THIS_DIR}/packages.include # "${Packages[@]}" array

clear

if [[ $USER != "root" ]]
then
       #123456789012345678901234567890123456789012345678901234567890123456789012345678
  echo "##############################################################################"
  echo "###                              CODEXium                                 ####"
  echo "##############################################################################"
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

if [[ -d ${PROD} ]]
then
  echo ""
else
  echo "The base directory of ${PROD} does NOT exist!"
  echo "Run the install script \"install.sh\""
  exit 9
fi
  

#
# Update Dependent Software
#
echo "##############################################################################"
echo "###                              CODEXium                                 ####"
echo "##############################################################################"
echo ""
echo ""
echo -n "UPDATE: system libraries [y]/n : "
read ANSWER
if [[ ${ANSWER} == "n" ]]
then
  echo "Skipped update of system libraries."
else
  for ITEM in "${Packages[@]}"
  do
    echo ""
    echo "UPDATE: Package: ${ITEM}"
    yum update -y ${ITEM}
  done
fi


#
# Install Git Repo for Base Codeset
#
#echo "##############################################################################"
#echo "###                              CODEXium                                 ####"
#echo "##############################################################################"
echo ""
echo ""
echo -n "UPDATE: CODEXium core code [y]/n : "
read ANSWER 
if [[ ${ANSWER} == "n" ]]
then
  echo "Skipped CODEXium core code update."
else
  #
  # Check for an ssh key
  #
  ssh-add -l 2>/dev/null
  if (( $? ))
  then
    echo ""
    echo "ERROR: No ssh key loaded."
    echo ""
    echo "NOTE: Please run \"ssh-agent bash\" followed by \"ssh-add [provided download key]\"."
    echo "NOTE: You can confirm your key is loaded with \"ssh-add -l\"."
    echo ""
    echo "EXITING"
    echo ""
    exit 6
  fi
  echo ""
  cd ${CORE}
    git config --global --add safe.directory ${CORE}
    git pull
  cd - 1>/dev/null
  echo ""
  echo "DONE: Updated CODEXium core code."
  echo ""
  DisplayLineStart "INSTALL: Copying from ${CORE} to ${PROD}"
  cp -rp ${CORE}/* ${PROD}
  DisplayLineEnd
fi

#
# Install Add-Ons
#
#echo "##############################################################################"
#echo "###                              CODEXium                                 ####"
#echo "##############################################################################"

echo ""
echo -n "UPDATE: CODEXium Add-On \"CDX-AddOn-Theme-Planets\" [y]/n : "
read ANSWER 
if [[ ${ANSWER} == "n" ]]
then
  echo "Skipped CODEXium Add-On \"CDX-AddOn-Theme-Planets\"."
else
  echo ""
  cd ${EXTRAS}/CDX-AddOn-Theme-Planets
    #
    git pull
    #
    if (( $? ))
    then
      echo "Failed to update code for Add-On \"CDX-AddOn-Theme-Planets\"."
      exit 4
    fi
  cd - 1>/dev/null
  #
  echo ""
  DisplayLineStart "UPDATE: running install script"
  ${EXTRAS}/CDX-AddOn-Theme-Planets/install.sh
  DisplayLineEnd
  #
  echo ""
  echo "DONE: Updated CDX-AddOn-Theme-Planets."
  echo ""
fi


echo ""
echo -n "UPDATE: CODEXium Add-On \"CDX-AddOn-Background-Space\" [y]/n : "
read ANSWER 
if [[ ${ANSWER} == "n" ]]
then
  echo "Skipped CODEXium Add-On \"CDX-AddOn-Background-Space\"."
else
  echo ""
  cd ${EXTRAS}/CDX-AddOn-Background-Space
    #
    git pull
    #
    if (( $? ))
    then
      echo "Failed to update code for Add-On \"CDX-AddOn-Background-Space\"."
      exit 4
    fi
  cd - 1>/dev/null
  #
  echo ""
  DisplayLineStart "UPDATE: running install script"
  ${EXTRAS}/CDX-AddOn-Background-Space/install.sh
  DisplayLineEnd
  #
  echo ""
  echo "DONE: Updated CDX-AddOn-Background-Space."
  echo ""
fi


echo ""
echo -n "UPDATE: CODEXium Add-On \"CDX-AddOn-Background-WWIFighter\" [y]/n : "
read ANSWER 
if [[ ${ANSWER} == "n" ]]
then
  echo "Skipped CODEXium Add-On \"CDX-AddOn-Background-WWIFighter\"."
else
  echo ""
  cd ${EXTRAS}/CDX-AddOn-Background-WWIFighter
    #
    git pull
    #
    if (( $? ))
    then
      echo "Failed to update code for Add-On \"CDX-AddOn-Background-WWIFighter\"."
      exit 4
    fi
  cd - 1>/dev/null
  #
  echo ""
  DisplayLineStart "UPDATE: running install script"
  ${EXTRAS}/CDX-AddOn-Background-WWIFighter/install.sh
  DisplayLineEnd
  #
  echo ""
  echo "DONE: Updated CDX-AddOn-Background-WWIFighter."
  echo ""
fi

echo ""
echo "DONE."
echo ""
