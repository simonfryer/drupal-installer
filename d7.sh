#!/usr/bin/env bash

# Set default stuff we need for this to work properly
set -o errexit
set -o pipefail
set -o nounset
#set -o xtrace

# Declare colours to change output colour
red=`tput setaf 1`
yellow=`tput setaf 3`;
green=`tput setaf 2`;
clear=`tput sgr0`;

# Get the full path of where we currently are
FULL_PATH=${PWD##*/}

# Allow user to overrwite the destination folder
while getopts "d:" OPTION
do
  case $OPTION in
   d)
      FULL_PATH=$OPTARG
     ;;
  esac
done

# Get the folder name of where we are installing, rather then the whole path
INSTALL_FOLDER=${FULL_PATH##*/}

echo "${green}"
echo "============================================"
echo ""
echo "Begin install"
echo ""
echo "============================================"
echo "${clear}"

# Check if the folder we are trying to install to is empty. If it isn't, GIT will error and throw us out
if find "$FULL_PATH" -mindepth 1 -print -quit | grep -q .; then
    echo "${red}The folder is not empty, please specify an empty directory!${clear}"
    exit 0
fi

echo "Drupal 7 in Itomic format will be installed too the directory; " ${FULL_PATH}

# Ask if the database needs to be created
read -rep $"Create the database for you? (y/n) " CREATE_DB

if [ "${CREATE_DB}" == 'y' ]; then
	# If it does, set the mysql database name based of the folder, and inform user what it will be called
	echo "${yellow}The database will created for you. If it fails, you may need to create it yourself through 'mysqladmin' or software such as Heidi or Sequel Pro."
	MYSQL_DB=${INSTALL_FOLDER}
	echo "${green}The database will be called: ${MYSQL_DB}"
else 
	# Notify the user the database won't be created and they need one existing to continue
	echo "${yellow}The database will not be created for you, please enter the details of an existing database when prompted."
fi

# Grab MySQL details
if ! [ ${MYSQL_USER+_} ]; then
	read -rep $"${yellow}MySQL user: " MYSQL_USER
fi

if ! [ ${MYSQL_PASS+_} ]; then
	read -rep $"${yellow}MySQL password: " MYSQL_PASS
fi

# If one isn't being created, ask for the existing one
if ! [ ${MYSQL_DB+_} ] && [ "${CREATE_DB}" != 'y' ]; then
	read -rep $"${yellow}MySQL database: " MYSQL_DB
fi

# If we need to create it, do that now using MySQL command line
if [ "${CREATE_DB}" == 'y' ]; then
	mysql -u ${MYSQL_USER} -p${MYSQL_PASS} -e "CREATE DATABASE \`${MYSQL_DB}\` CHARACTER SET utf8 COLLATE utf8_general_ci;"
fi

# Git clone
echo "${green}"
echo "================================================================="
echo "GIT will now clone into the directory ${FULL_PATH}"
echo "================================================================="
echo "${yellow}"
git clone https://github.com/simonfryer/drupal-spur.git ${FULL_PATH}

# Move into the created folder
cd ${FULL_PATH}

# Remove the existing .GIT so the user can create their own
rm -rf .git

# Run the drush make file
echo "${green}"
echo "================================================================="
echo "Drush make will now grab all important modules"
echo "================================================================="
drush make drupal_spur.make -y

# Install Drupal using given details and set some defaults
echo "${green}"
echo "================================================================="
echo "Drush will now install using Itomic profile to database defined earlier"
echo "=================================================================${clear}"
drush si drupal_spur --db-url=mysql://${MYSQL_USER}:${MYSQL_PASS}@localhost/${MYSQL_DB} --account-name=admin --account-pass=letmedevelop --site-name=${INSTALL_FOLDER} --account-mail=admin@email.com -y

# We are done!
echo "${green}"
echo "================================================================="
echo ""
echo "Installation has finished running"
echo ""
echo "================================================================="
echo "${clear}"
