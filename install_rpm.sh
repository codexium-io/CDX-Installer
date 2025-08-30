#!/bin/bash

##############################################################################
# FILE: install_rpm.sh                                                       #
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
CORE="${BASE}/CDX-CORE" 

(( OPTION_WSL = 0 )) 
(( OPTION_HTTP = 0 ))
(( OPTION_HTTPS = 0 ))

THIS_DIR=$(dirname $0)

#OLD-KEEP# EXTRAS="${BASE}/CDX-ADDON" 
#OLD-KEEP# ADDON=(
#OLD-KEEP#   "CDX-AddOn-Theme-Planets"
#OLD-KEEP#   "CDX-AddOn-Background-Space"
#OLD-KEEP#   "CDX-AddOn-Background-WWIFighter"
#OLD-KEEP# )

source ${THIS_DIR}/help.include
source ${THIS_DIR}/display_functions.include
source ${THIS_DIR}/packages_rpm.include # "${Packages[@]}" array


#
# START
#
# clear 2>/dev/null
DisplaySection "CODEXium : RPM Installation Started"
echo ""

#
# START : Install Packages
#
DisplaySection "CODEXium : Configure Environment : Libraries"
#
echo ""
echo -n "INSTALL: Install system libraries ? [y]/n : "
read ANSWER
if [[ ${ANSWER} == "n" ]]
then
  echo "[SKIPPED]"
else
  #
  # packages_rpm.include has "${OS_Packages_RPM[@]}"
  #
  # RPM Based Package Manager
  #
  # dnf check-update
  #
 (( PkgNotInstalled = 1 ))
  for PACKage in "${OS_Packages_RPM[@]}"
  do
    dnf install -y ${PACKage}
    wait
    #
    # Verify it installed
    #
    PkgNotInstalled=$( rpm -q ${PACKage} 2>/dev/null 1>&2 )
    if (( PkgNotInstalled ))
    then
      echo "ERROR: Package ${PACKage} not installed"
      echo "ERROR: It may be there is no access to an EPEL-like repo."
      echo "ERROR: It may be a problem with the upstream repo."
      echo "ERROR: Investigate with a Linux Admin."
      exit 78
    fi
    (( PkgNotInstalled = 1 ))
  done
fi
#
# END : Install Packages
#

#
# Check for git software
#
echo ""
DisplaySection "Checking for git software"
if [[ ! -f /usr/bin/git ]]
then 
  echo "INFO: Looks like you don't have the \"git\" versioning software."
  echo "INFO: We'll try to install it."
  DisplayLineStart "Installing \"git\""
  dnf install git
  if (( $? ))
  then
    echo "OOPS: Looks like we can't install."
    echo "Contact your administrator."
    echo "EXITING: exit 5"
    exit 5
  else
    DisplayLineEnd
  fi
else
  echo "OK: Git is installed."
  DisplayLineEnd
fi
echo ""


# 
# START: Configure OS Security
#
getenforce 2>/dev/null 1>&2
if (( $? ))
then
  echo "INFO: SELinux does not appear to be installed."
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
    echo "[SKIPPED]"
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
# END: Configure OS Security 
#


#
# START: Install Software
#
DisplaySection "CODEXium : Install Software : CORE"
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
echo -n "INSTALL: CODEXium CORE Repo [y]/n : "
read ANSWER 
if [[ ${ANSWER} == "n" ]]
then
  echo "[SKIPPED]"
  echo ""
else
  #
  # Load the Key for this "Installer" Repo
  # This will allow for future updates to the Installer repo.
  #
  # git config core.sshCommand 'ssh -i ~/.ssh/CODEXium_Installer.key' 
  #
  git config core.sshCommand 'ssh -i ~/.ssh/CODEXium-CORE.key'
  #
  # Download the software and deploy it
  #
  echo ""
  DisplaySection "Install CORE Software [requires a licensed ssh key]"
  echo ""
  if [[ ! -d ${CORE} ]]
  then
    #
    # MAIN
    #
    git config --global safe.directory ${CORE}
    git config --global core.fileMode true
    git config --global core.sshCommand 'ssh -i ~/.ssh/CODEXium-CORE.key -o StrictHostKeyChecking=no'
    git clone git@github.com:codexium-io/CDX-CORE.git ${CORE}
    if (( $? ))
    then
      echo ""
      echo "ERROR: unable to clone"
      echo "EXITING : 13"
      echo ""
      exit 13
    else
      echo ""
      DisplayLineStart "Cloning CDX-CORE to ${BASE}"
      DisplayLineEnd
      echo ""
    fi
  else
    echo "WARNING: It looks like CDX-CORE exists."
    echo "WARNING: To update the repo run the following."
    echo "WARNING: cd /www/CDX-CORE/ && git pull"
    echo "WARNING: If you need to re-install ..."
    echo "WARNING: 1] Backup the \"/NOTE/\" directory."
    echo "WARNING: 2] Backup the /www/htpasswd-*.txt files."
    echo "WARNING: 3] Remove the repo ... \"rm -rf /www/CDX-CORE\""
    echo "WARNING: 4] Rerun this script."  
    echo "WARNING: 5] Restore \"/NOTE/\" and \"htpasswd-*.txt\"."  
    echo "EXITTING"
    exit 86
  fi

  #
  # Copy user/password files up one dir
  #
  DisplaySection "Establish Credential Files"
  echo ""
  for AuthGroup in users editors admins
  do
    if [[ ! -f ${BASE}/htpasswd-${AuthGroup}.txt ]]
    then
      cp ${CORE}/htpasswd-${AuthGroup}.txt ${BASE} 
      echo "FILE COPIED: \"htpasswd-${AuthGroup}.txt\" to ${BASE}"
    else
      echo "FILE EXISTS: \"htpasswd-${AuthGroup}.txt\" ... [SKIPPED]"
    fi
  done
  echo ""
  echo "NOTE: The included credential files are for reference."
  echo "NOTE: Please also see the file \"Users_and_Passwords.txt\""
  echo "NOTE: You will want to edit these files for specific usernames and passwords."
  echo "NOTE: Delete the file \"Users_and_Passwords.txt\" when you are finished adding a few users."
  #
  # NOTE:
  # Git permissions are effective when a single user is used.
  # However, when using a different user like "root" the permissions
  # resort to the user's git/umask settings at time of checkin.
  #
  echo ""
  DisplaySection "Setting Ownership"
  echo ""
  DisplayLineStart "Setting user:group to apache:apache on ${CORE}"
  chown -R apache:apache ${CORE}
  DisplayLineEnd
  #X15# DisplayLineStart "Changing permissions on ${CORE}/NOTE"
  #X15# chmod 775 ${CORE}/NOTE
  #X15# find ${CORE}/NOTE -type d -exec chmod 775 {} \;
  #X15# find ${CORE}/NOTE -type f -exec chmod 444 {} \;
  #X15# DisplayLineEnd
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
  echo "[SKIPPED]"
  echo ""
else
  echo ""
  DisplayLineStart "Backing Up Config httpd.conf ..."
  cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.backup_${DATE} 2>/dev/null
  DisplayLineEnd
  if [[ -f "/etc/httpd/conf/httpd.conf.backup_${DATE}" ]]
  then
    echo "Successfully backed up httpd.conf"
  else
    echo "ERROR: Unable to create backup of httpd.conf"
    echo "EXITTING:77"
    exit 77 
  fi
  echo ""
  echo "Installing Webserver Configs ..."
  echo ""
  echo "WARNING: Do you want to copy over the main config \"httpd.conf\" ?"
  echo "WARNING: Generally, you should NOT copy over an existing main config."
  echo "WARNING: If this is a server that is dedicated to CODEXium, you can proceed."
  echo ""
  echo -n "Continue ? [y]/n : "
  read ANSWER
  if [[ ${ANSWER} == "n" ]]
  then
    echo "[SKIPPED]"
  else 
    echo ""
    DisplayLineStart "Copying httpd.conf"
    cp ${CORE}/httpd.conf /etc/httpd/conf/httpd.conf
    DisplayLineEnd
    echo ""
  fi
  #
  (( NotDone = 1 ))
  while (( NotDone ))
  do
    echo ""
    echo "IMPORTANT: PLEASE READ CAREFULLY"
    echo ""
    echo "Pick a configuration option : "
    echo ""
    echo "[1] http/80 running on Metal"
    #echo -e "\"\e[7mHOST:80\e[0m\""
    echo "[2] http/80 running on Microsoft/WSL"
    echo "[3] https/443 running on Metal"
    echo ""
    echo -n "OPTION : "
    read ANSWER
    if [[ ${ANSWER} == "1" || ${ANSWER} == "2" || ${ANSWER} == "3" ]] 
    then
      (( NotDone = 0 ))
    fi
  done
  #
  echo ""
  echo "You selected option \"${ANSWER}\""
  echo ""

  if [[ ${ANSWER} == "3" ]]
  then
    echo -n "Do you want to copy the website config \"codexium_443.conf\" ? [y]/n : "
    read ANSWER
    if [[ ${ANSWER} == "n" ]]
    then
      echo "[SKIPPED]"
      echo ""
    else 
      echo "cp ${CORE}/codexium_443.conf /etc/httpd/conf/codexium.conf"
      cp ${CORE}/codexium_443.conf /etc/httpd/conf/codexium.conf
      echo "DONE."
      echo ""
    fi
    #
    echo -n "Copy the website SSL certs ? [y]/n : "
    read ANSWER
    if [[ ${ANSWER} == "n" ]]
    then
      echo "[SKIPPED]"
      echo ""
    else 
      DisplayLineStart "Copying SSL Certs"
      mkdir /etc/httpd/certs 2>/dev/null
      cp ${CORE}/etc_httpd_certs__sts_ssl.crt /etc/httpd/certs/demo_cdx_wiki_ssl.crt
      cp ${CORE}/etc_httpd_certs__sts_ssl.key /etc/httpd/certs/demo_cdx_wiki_ssl.key
      DisplayLineEnd
      echo ""
    fi
  elif [[ ${ANSWER} == "1" || ${ANSWER} == "2" ]]
  then
    # HOST:80 OR WSL:80
    (( OPTION_WSL = 1 ))
    echo -n "Do you want to copy the website config \"codexium_80.conf\" ? [y]/n : "
    read ANSWER
    if [[ ${ANSWER} == "n" ]]
    then
      echo "[SKIPPED]"
      echo ""
    else 
      echo ""
      DisplayLineStart "Copying Config"
      #echo "cp ${CORE}/codexium_80.conf /etc/httpd/conf/codexium.conf"
      cp ${CORE}/codexium_80.conf /etc/httpd/conf/codexium.conf
      DisplayLineEnd
      echo ""
    fi
  fi
  if [[ ${ANSWER} == "2" ]]
  then
    #
    # WSL Configuration
    #
    (( OPTION_WSL = 1 ))
    echo ""
    DisplaySection "WSL Setup"
    echo ""
    DisplayLineStart "Creating WSL config file /etc/wsl.conf on host"
    echo "[boot]" > /etc/wsl.conf 
    echo "systemd=true" >> /etc/wsl.conf 
    echo "[automount]" >> /etc/wsl.conf 
    echo "options = \"metadata\"" >> /etc/wsl.conf 
    DisplayLineEnd
    echo ""
    echo "You may need to terminate the WSL VM host and restart."
    echo ""
  fi
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
  echo -n "Do you want to configuring the domain ? [y]/n : "
  read ANSWER
  if [[ "${ANSWER}" == "n" ]]
  then
    echo "Domain unchanged."
    echo "[SKIPPED]"
    echo ""
  else
    ${THIS_DIR}/change_site_name.sh
  fi 
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

if (( OPTION_WSL ))
then
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
fi 

echo ""

DisplaySection "FINISHED"

echo ""
