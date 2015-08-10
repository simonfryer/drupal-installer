# Drupal shell install scripts

Helpful shell scripts to quickly install Drupal websites.

Super basic, but get the job done for development environments.

A line that starts with a $ sign means a shell/terminal command.

## Drupal 7

This command can be run either from the directory you want to install Drupal too, or from where ever using -d parameter.

### Requirements

1. git
1. drush
1. terminal/ssh access

### Instructions for getting a new Drupal install setup

1. git clone this repository somewhere, doesn't really matter where (read Usage instructions below)
1. run the .sh script as detailed below, either without -d and it will go to current folder, or with to specify
1. once running, you will be asked to either create the database, or use an existing one
1. after that, enter the mysql user and pass (and the database if you've already got one)
1. should install without a hitch - hopefully

### Usage

The folder must be EMPTY. Not even DS_STORE can be in there.

 * The script can create the database for you if required (will create as utf8_general_ci)
 * It assumes the MySQL user/pass are the same as you want to run Drupal on
 * If database is created for you, it will use the lower most folder name as the database name
 * * For example, if you create it in ../../websites/folder.dev the database will be called 'folder.dev'

 > $ sh d7.sh

**-d** lets you set a specific destination folder

 > $ sh d7.sh -d ../websites/drupal7.dev

### What this doesn't do

* It won't create a host file entry/apache entry. Each local env is different, do this separate

### NOTES

This is by no means perfect. It's designed to exit on error, but depending where it's got too, you may have to delete the install folder and database to try again.