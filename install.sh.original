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

DATE=$(date +Y%Y.M%m.D%d.h%H.m%M)

BASE="/www"
CORE="${BASE}/CDX-CORE" # Contains base repo
EXTRAS="${BASE}/CDX-ADDON" # Contains multiple repos
PROD="${BASE}/codexium" # Is not a git repo

THIS_DIR=$(dirname $0)

ADDON=(
  "CDX-AddOn-Theme-Planets"
  "CDX-AddOn-Background-Space"
  "CDX-AddOn-Background-WWIFighter"
)

source ${THIS_DIR}/help.include
source ${THIS_DIR}/display_functions.include
source ${THIS_DIR}/packages.include # "${Packages[@]}" array


rpm --version 2>/dev/null 1>&2
# RPM will be 0 
# DEB will be 127
if (( $? )) 
then
  TYPE="DEB"
else
  TYPE="RPM"
fi

clear 2>/dev/null



DisplaySection "CODEXium : Installation Started"

echo ""

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
# Look for a loaded ssh key
#
ssh-add -l 2>/dev/null 1>&2
if (( $? ))
then
  #
  # ssh keyring not working and no key found
  #
  echo "ERROR: No key loaded"
  echo "HINT: ssh-agent bash # This will enable the keyring"
  echo "HINT: ssh-add github-provided-key"
  echo "HINT: ssh-add -l # This should list the key just added"
  echo "EXITING"
  exit 4
fi

DisplaySection "CODEXium : INSTALL"

echo ""
if [[ ${TYPE} == "DEB" ]]
then
  echo "INFO: This system is Debian based."
else
  echo "INFO: This system is RPM based."
fi
echo ""

#
# Installing Dependent Software
#
DisplaySection "CODEXium : Configure Environment : Libraries"
#
echo ""
echo -n "INSTALL: Install system libraries ? [y]/n : "
read ANSWER
if [[ ${ANSWER} == "n" ]]
then
  echo "Skipped install of system libraries."
  echo ""
  echo ""
else
  # packages.include has "${OS_Packages_DEB[@]}" and "${OS_Packages_RPM[@]}"
  if [[ ${TYPE} == "DEB" ]]
  then
    #
    # DEBIAN Based Package Manager
    #
    for PACK in "${OS_Packages_DEB[@]}"
    do
      apt install -y ${PACK}
    done
    #
    # a2enmod - enable module
    # a2dismod - disable module
    # Modules installed and available but not enabled are in /etc/apache2/mods-available/
    # Installing a package/module will automatically enable the module.
    # Install looks like ...
    # apt-get install libapache2-mod-<moduletobeinstalled>
    # Searching looks like ...
    # apt search libapache2-mod
    # List current modules ...
    # apache2ctl -M
    #
    # a2enmod ssl # Module is installed by default ... just needs to be enabled
    # a2enmod session # mod_session
    # a2enmod session_cookie # mod_session_cookie
    # a2enmod cgid # for generic CGI
    #
    for MODule in "${Apache2_Packages_DEB[@]}"
    do
      apt install -y libapache2-mod-${MODule}
    done
  else 
    #
    # RPM Based Package Manager
    #
    yum check-update
    for PACKage in "${OS_Packages_RPM[@]}"
    do
      yum install -y ${PACKage}
    done
    #
    # There is no Apache2_Packages_RPM because 
    # the packages are added at the OS level.
    #
  fi
fi


# 
# Configure Environment
#
getenforce 2>/dev/null 1>&2
if (( $? ))
then
  echo ""
  #
  # Skip ... SELinux is not installed
  # Ubuntu and SuSE and other Debians ... use AppArmor
  #
else
  DisplaySection "CODEXium : Configure Environment : SELinux"
  #
  echo ""
  echo -n "INSTALL: RECOMMEND: Disable SELinux: [y]/n : " 
  read ANSWER
  if [[ ${ANSWER} == "n" ]]
  then
    echo "Skipped recommended disabling of SELinux"
    echo ""
    echo ""
  else
    if [[ -f "/etc/selinux/config" ]]
    then 
      sed -i 's/SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
      sed -i 's/SELINUXTYPE=.*/SELINUXTYPE=targeted/' /etc/selinux/config
    else
      echo "SELINUX=disabled" >> /etc/selinux/config
      echo "SELINUXTYPE=targeted" >> /etc/selinux/config
    fi
    setenforce 0
    echo ""
  fi
fi


#
# Install Git Repos for Base Codeset
#
DisplaySection "CODEXium : Install Software : Core"
#
echo ""
DisplayLineStart "Establishing directory \"${BASE}\"."
if [[ ! -d ${BASE} ]]
then
  mkdir ${BASE}
fi
DisplayLineEnd
#
echo ""
echo -n "INSTALL: Core Repo [y]/n : "
read ANSWER 
if [[ ${ANSWER} == "n" ]]
then
  echo "Skipped CODEXium Base Install."
  echo ""
else
  echo ""
  #
  ssh-add -l 2>/dev/null 1>&2
  KEY_STATUS=$?
  if (( KEY_STATUS == 2 ))
  then
    echo "ERROR: The root account has no SSH key loaded."
    echo "ERROR: Load the SSH-key needed for GitHub access."
    echo "HINT: ssh-agent bash"
    echo "HINT: ssh-add github-key-codexium.key"
    echo "EXITING"
    echo ""
    exit 5
  fi
  #
  if [[ -d ${PROD} ]]
  then 
    # Backup
    DisplayLineStart "Backing up existing directory ${PROD}"
    mv ${PROD} ${PROD}.backup.${DATE}
    DisplayLineEnd
  fi
  DisplayLineStart "Creating ${PROD}"
  mkdir -p ${PROD}
  DisplayLineEnd
  echo ""

  #
  # Check for git
  #
  echo ""
  DisplayLineStart "Checking for git software"
  if [[ ! -f /usr/bin/git ]]
  then 
    echo "ERROR: Install package \"git-core\" ... e.g. \"yum -y install git-core\"."
    echo "EXITING: exit 5"
    exit 5
  fi
  DisplayLineEnd


  #
  # Get the software and deploy it
  #
  echo ""
  DisplaySection "Obtain Software [requires a licensed ssh key]"
  echo ""
  if [[ ! -d ${CORE} ]]
  then
    echo ""
    echo "Cloning CDX-CORE to ${BASE}"
    echo ""
    git clone git@github.com:ostrom-science/CDX-CORE.git ${CORE}
    if (( $? ))
    then
      echo ""
      echo "ERROR: unable to clone"
      echo "EXITING : 13"
      echo ""
      exit 13
    fi
  else
    echo "NOTE: It looks like CDX-CORE exists."
    echo "We will copy over the code from the existing CDX-CORE" 
  fi
  #
  # Copy Software
  #
  echo ""
  DisplaySection "Copying Software"
  echo ""
  cp -rp ${CORE}/* ${PROD} 
  #
  # Move user/password files up one dir
  #
  echo "Moving user/password files to ${BASE}"
  cp ${CORE}/htpasswd-*.txt ${BASE} 
  cp ${CORE}/Users_and_Passwords.txt ${BASE}
  echo "DONE."
  echo ""
  echo "The credential files have been moved."
  echo "The credential files are for reference."
  echo "Please also see the file \"Users_and_Passwords.txt\""
  echo "You will want to edit these files for specific usernames"
  echo "You should not store clear text passwords."
  echo "Delete the file \"Users_and_Passwords.txt\" when you are finished adding a few users."
  echo ""
  
  #
  # NOTE:
  # Git permissions are effective when a single user is used.
  # However, when using a different user like "root" the permissions
  # resort to the user's git/umask settings at time of checkin.
  #
  echo ""
  if [[ ${TYPE} == "RPM" ]]
  then
    DisplayLineStart "Setting user:group to apache:apache on ${PROD}"
    chown -R apache:apache ${PROD}
    DisplayLineEnd
  else
    DisplayLineStart "Setting user:group to www-data:www-data on ${PROD}"
    chown -R www-data:www-data ${PROD}
    DisplayLineEnd
  fi
  DisplayLineStart "Changing permissions on ${PROD}/NOTE"
  chmod 775 ${PROD}/NOTE
  find ${PROD}/NOTE -type d -exec chmod 775 {} \;
  find ${PROD}/NOTE -type f -exec chmod 555 {} \;
  DisplayLineEnd
  echo ""
fi

echo ""

#
# Install Git Repos for Extras/AddOn's
#
DisplaySection "CODEXium : Install Software : Extras"
#
echo ""
echo -n "INSTALL: AddOn Repos [y]/n : "
read ANSWER
if [[ ${ANSWER} == "n" ]]
then
  echo "Skipped CODEXium AddOn Install."
  echo ""
else
  echo ""
  DisplayLineStart "Creating Dir: ${EXTRAS}"
  mkdir -p ${EXTRAS} 2>/dev/null
  DisplayLineEnd
  echo ""
  echo "INSTALLING ADDON REPOS"
  for AddOn in "${ADDON[@]}"
  do
    echo ""
    echo -n "INSTALL: ${AddOn} [y]/n : "
    read ANSWER
    if [[ ${ANSWER} == "n" ]]
    then
      echo "Skipped ${AddOn}"
      echo ""
    else 
      echo ""
      echo "Cloning ${AddOn} to ${EXTRAS}/${AddOn}"
      echo ""
      if [[ -d "${EXTRAS}/${AddOn}" ]]
      then 
        echo "SKIPPING DOWNLOAD/clone: Looks like this was already installed."
        echo ""
      else
        #
        git clone git@github.com:ostrom-science/${AddOn}.git ${EXTRAS}/${AddOn} 
        #
        if (( $? ))
        then
          echo ""
          echo "Unable to clone ${AddOn} (may not have license/key)"
          echo ""
          continue
        else
          echo ""
          DisplayLineStart "SUCCESS: Cloned ${AddOn} to ${EXTRAS}/${AddOn}"
          DisplayLineEnd
        fi
      fi
      echo ""
      DisplayLineStart "INSTALL: Running install.sh script for ${AddOn}"
      ${EXTRAS}/${AddOn}/install.sh
      DisplayLineEnd
      echo ""
      # NOTE: Set permissions from git # DisplayLineStart "Setting permissions to 775 on ${PROD}"
      # NOTE: Set permissions from git # chmod -R 775 ${PROD}
      # NOTE: Set permissions from git # DisplayLineEnd
      if [[ ${TYPE} == "RPM" ]]
      then
        DisplayLineStart "Setting user:group to apache:apache on ${PROD}"
        chown -R apache:apache ${PROD}
        DisplayLineEnd
        echo ""
      else
        DisplayLineStart "Setting user:group to www-data:www-data on ${PROD}"
        chown -R www-data:www-data ${PROD}
        DisplayLineEnd
        echo ""
      fi
    fi
  done
fi

echo ""

#
# Install Apache Configs
#
DisplaySection "CODEXium : Install Software : Apache Setup"
#
echo ""
echo -n "INSTALL: Setup Apache Configuration ? [y]/n : "
read ANSWER
if [[ ${ANSWER} == "n" ]]
then
  echo "Skipped Webserver configuration"
  echo ""
else
  echo -n "Backing Up Config httpd.conf ..."
  cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.backup_${DATE} 2>/dev/null
  echo "DONE."
  echo ""
  if [[ -f "/etc/httpd/conf/httpd.conf.backup_${DATE}" ]]
  then
    echo "Successfully backed up httpd.conf"
  else
    echo "ERROR: Unable to create backup of httpd.conf"
    exit 
  fi
  echo "Installing Webserver Configs ..."
  echo ""
  echo "WARNING: Do you want to copy over the main config \"httpd.conf\" ?"
  echo "WARNING: You should NOT copy over an existing main config."
  echo "WARNING: If this is a server that is dedicated to CODEXium, you can proceed."
  echo -n "Continue ? [y]/n : "
  echo ""
  read ANSWER
  if [[ ${ANSWER} == "n" ]]
  then
    # echo "Do you to modify the main config \"httpd.conf\" ? y/[n] : "
    # read ANSWER
    # if [[ ${ANSWER} == "y" ]]
    # then
    #   echo "" >> /etc/httpd/conf/httpd.conf
    #   echo "Include conf/codexium.conf" >> /etc/httpd/conf/httpd.conf
    #   echo "" >> /etc/httpd/conf/httpd.conf
    # else 
    #   echo "Skipped mod-only website config \"httpd.conf\""
    #   echo ""
    # fi
    echo "Skipped copy of main config \"httpd.conf\" for https/443."
  else 
    DisplayLineStart "Copying httpd.conf"
    cp ${PROD}/httpd.conf /etc/httpd/conf/httpd.conf
    DisplayLineEnd
    echo ""
  fi
  #
  echo ""
  echo "Pick a configuration option : "
  echo -n "1.) http/80 ... Enter "
  echo -e "\"\e[7m80\e[0m\""
  echo -n "2.) https/443 ... Enter "
  echo -e "\"\e[7m443\e[0m\""
  read ANSWER
  if [[ ${ANSWER} == "443" || ${ANSWER} == "2" ]]
  then
    echo -n "Do you want to copy the website config \"codexium_443.conf\" ? [y]/n : "
    read ANSWER
    if [[ ${ANSWER} == "n" ]]
    then
      echo "Skipped website config \"codexium_443.conf\""
      echo ""
    else 
      echo "cp ${PROD}/codexium_443.conf /etc/httpd/conf/codexium.conf"
      cp ${PROD}/codexium_443.conf /etc/httpd/conf/codexium.conf
      echo "DONE."
      echo ""
    fi
    #
    echo -n "Copy the website SSL certs ? [y]/n : "
    read ANSWER
    if [[ ${ANSWER} == "n" ]]
    then
      echo "Skipped copying certs"
      echo ""
    else 
      DisplayLineStart "Copying SSL Certs"
      mkdir /etc/httpd/certs 2>/dev/null
      cp ${PROD}/etc_httpd_certs__sts_ssl.crt /etc/httpd/certs/demo_cdx_wiki_ssl.crt
      cp ${PROD}/etc_httpd_certs__sts_ssl.key /etc/httpd/certs/demo_cdx_wiki_ssl.key
      DisplayLineEnd
    fi
  else
    # http/80
    echo -n "Do you want to copy the website config \"codexium_80.conf\" ? [y]/n : "
    read ANSWER
    if [[ ${ANSWER} == "n" ]]
    then
      echo "Skipped website config \"codexium_80.conf\""
      echo ""
    else 
      echo "cp ${PROD}/codexium_80.conf /etc/httpd/conf/codexium.conf"
      cp ${PROD}/codexium_80.conf /etc/httpd/conf/codexium.conf
      echo "DONE."
      echo ""
    fi
  fi
fi

#
# WSL Configuration
#
echo ""
DisplaySection "WSL Setup"
echo ""
echo -n "Is this a WSL host/deployment? y/[n] : "
read ANSWER
if [[ "${ANSWER}" == "n" ]]
then
  echo "Skipping."
else
  DisplayLineStart "Creating WSL config file /etc/wsl.conf on host"
  echo "[boot]" > /etc/wsl.conf 
  echo "systemd=true" >> /etc/wsl.conf 
  echo "[automount]" >> /etc/wsl.conf 
  echo "options = \"metadata\"" >> /etc/wsl.conf 
  DisplayLineEnd
  echo ""
  echo "You may need to terminate the WSL VM host and restart."
  echo "This will force the correct reading of the configs."
fi

#
# Configure Default Apache Configs
#
DisplaySection "CODEXium : Install Software : Domain"
#
echo ""
echo "The default domain is \"demo.cdx.wiki\" ."
echo "This domain is set to localhost/127.0.0.1 ."
echo "You can change the domain by running \"change_site_name.sh\"."
echo -n "Do you accept the default domain ? [y]/n : "
read ANSWER
if [[ "${ANSWER}" == "n" ]]
then
  ${THIS_DIR}/change_site_name.sh
else
  echo "Accepted default domain."
  echo ""
fi

#
# Start Apache
#
DisplaySection "Starting Apache"
#
echo ""
DisplayLineStart "Enabling httpd"
systemctl enable httpd
if (( $? ))
then
  echo "ERROR: Unable to enable Apache/httpd service."
else
  DisplayLineEnd
fi
#
echo ""
DisplayLineStart "Stopping httpd"
systemctl stop httpd
if (( $? ))
then
  echo "ERROR: Unable to stop Apache/httpd service."
else
  DisplayLineEnd
fi
#
echo ""
DisplayLineStart "Starting httpd"
systemctl start httpd
if (( $? ))
then
  echo "ERROR: Unable to start Apache/httpd service."
else
  DisplayLineEnd
fi

#
# Last Comments
#
echo ""
DisplaySection "DON'T PANIC"
echo ""
echo "NOTES on WSL Deployment:"
echo ""
echo "You may have recieved one or more of the following messages:"
echo ""
echo "[1] System has not been booted with systemd as init system (PID 1). Can't operate."
echo "[2] Failed to connect to bus: Host is down"
echo "[3] Couldn't find an alternative telinit implementation to spawn."
echo ""
echo "Do not panic."
echo ""
echo "You will need to terminate the WSL VM host and restart."
echo "This will force the correct reading of the configs."
echo "To terminate a WSL host, it will look something like the following:"
echo ""
echo "POWERSHELL> wsl -t <Your Linux Distro>"
echo ""


DisplaySection "FINISHED"
