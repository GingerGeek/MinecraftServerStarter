#!/usr/bin/env bash
# Welcome to the Minecraft Server Starter
# Copyright (c) GingerGeek.co.uk
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
installed="Have you followed me on Twitter?: @TheGingerGeek"
# Installation Instructions:
# DO NOT RUN WITHOUT READING THIS
# Note: Everything is Capital Sensitive!
# Note: It is higly recommended not to run this script as root! See Appendix A (just below the settings) for instructions on how to change the user.
#
# 1) Copy this file into the folder where you all the servers are located
# 2) Set the ServerRoot variable, it must be a full path e.g /home/Servers (note there is NO finishing /). If you don't know where you are, but are where the servers are, type pwd to find out the path.
# 3) Create an Ignore List, by default this should be called ignore.txt and it is stored in the directory you set as ServerRoot. This file must be created and contain at least ONE directory or the script may not work.
# 4) Configure the Bungee settings. See comments for specifics
# 5) Configure the Standard Server Settings. See comments for specifics
# 6) Check All Settings
# 7) Repeat Step 6
# 8) Before the instructions there is a variable called installed, change the value inside the quotes to Zombies
# 9) You are done setting up, execute the script with 
#    /PathTo/WhatEverThisIsCalled.sh 
# 10) Follow me on Twitter: @TheGingerGeek
#     i) or like me on FB: FB/TheGingerGeek
#     ii) or sub me on Youtube: YT/GingerGeekUK



################################
#     General Settings         #
################################
ServerRoot="SETME" #Where should I start looking from (full path) e.g. /home/Servers
IgnoreList="$ServerRoot/ignore.txt" #Location of Ignore List. See Install Guide
debug=0 #Set to one for extra output, helpful for spotting errors.
userRunnuer="" #Leave blank to run as current logged in user, else it will switch using su! Thus you must be root or know the password!
################################
#      Bungee Settings         #
################################
BungeeJarName="BungeeCord.jar" #What is your Bungee Jar called?
BungeeFolder="Bungeecord" #What is the Bungee Folder called?
BungeeArgs="-Xmx512M" #Bungee Java Args to start server
BungeeExecChanged="No" #Change to yes if you have changed below
BungeeExec="" #Advanced Users Only - Change the command for starting the Bungee Server
################################
#   Standard Server Settings   #
################################
ServerJarName="spigot.jar" #What is your server jar called?
StandardArgs="-Xmx1G" #Standard Java Args to start server
ServerExecChanged="No" #Change to yes if you have changed below
ServerExec="" #Advanced Users Only - Change the command for starting the Bungee Server
#################################


#################################
#         Appendixes            #
#################################
# Contents                      #
#################################
# Appendix A - Not running as Root
#################################
#          Appendix A           #
#################################
# To have the Minecraft Server run as not root, follow these steps
# Note, you will need root access to do this!
#
# 1) Create a new user on your Linux System using:
# useradd -m -d /home/USERNAME USERNAME
# e.g
# useradd -m -p SeeBelow -d /home/MCServer MCServer
# This will create a new Useraccount with it's own directory in /home/[UserNameYouHadChosen]
# The -p takes an encrypted password, unless you intend to actually use the account, set this to whatever you want, otherwise use crypt(3) to create an encrypted password (Google it)
#
# 2) Copy Server Directory over to the new directory
# mv [CurrentLocationOfFolders]/*  /home/[UserNameYouHadChosen]
#
# 3) Ensure that the new folder place is owned by the new user
# chown -R [NewUsername] [PathToFolderWhereEverythingIsStored]
#
# 4) Making sure that the folder has appropiate permissions.
# chmod 754 -R [PathToFolderWhereEverythingIsStored]
# 754 is the permissions I recommend using.

