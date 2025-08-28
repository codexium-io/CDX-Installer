#!/bin/sh

#
# ABOUT: 
# This script configures CODEXium software.
# This script should be run as root.
# Run this script from the install directory that 
# was downloaded by the deployment key.
#
# After you run this the site name should be changed.
#

DEBUG=0
DATE=$(date +Y%Y.M%m.D%d.h%H.m%M)
BASE="/www"
CORE="${BASE}/CDX-CORE"
THIS_DIR=$(dirname $0)

source ${THIS_DIR}/display_functions.include

#clear

DisplaySection "# CODEXium : Change Site Name"
DisplayBlockLine "#"
DisplayBlockLine "# This script will change your site name."
DisplayBlockLine "#"
DisplayBlockLine "# e.g."
DisplayBlockLine "# \"demo.cdx.wiki\" to \"accounting.somecoolsite.com\""
DisplayBlockLine "#"
DisplayBlockLine "# If you make a mistake, rerun this script"
DisplayBlockLine "# or edit \"codexium.conf\""
DisplayBlockFill
#
# Get new name
#
echo ""
echo "CONFIGURE: Enter the host/DNS/domain you own/control : "
echo -n "DOMAIN : "
read DOMAIN
echo "You have entered the name >>>${DOMAIN}<<<."
echo -n "Continue ? : [any key]"
read ANYKEY
#
# Backup Current Config
#
DisplayLineStart "Backup website config"
cp /etc/httpd/conf/codexium.conf /etc/httpd/conf/codexium_conf.backup_${DATE}
DisplayLineEnd
#
# Update codexium.conf
#
echo ""
echo -n "Continue ? : [any key]"
read ANYKEY
echo ""
DisplayLineStart "Modifying codexium.conf"
COMMAND_STRING="sed -i 's/^ServerName.*/ServerName ${DOMAIN}/g' /etc/httpd/conf/codexium.conf"
echo "${COMMAND_STRING}"
eval ${COMMAND_STRING}
DisplayLineEnd
echo ""
#
# Restart Webserver
#
echo ""
echo "NOTE: Manually Restart the webserver"
echo ""
echo "#> systemctl restart httpd"
echo "OR"
echo "#> systemctl stop httpd"
echo "#> systemctl start httpd"
echo ""

DisplaySection "# Finished"
