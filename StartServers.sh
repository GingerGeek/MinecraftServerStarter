#!/usr/bin/env bash
# Minecraft Server Starter
# Server Starter Bit
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

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. "$DIR/config.sh"

IFS=$'\n' read -d '' -r -a disabledDirs < $IgnoreList #Please don't touch this, it's quite important
isRoot() {
#If Root, will return True (0)
if [ "$(id -u)" == "0" ]; then
  debug "Being Run as Root User"
  return 0 #True
else
  return 1 #False
fi
# ...
}

debug() {
#If we are in debug mode then this will echo Debug
if [ $debug == 1 ]
then
echo "DEBUG: $1"
fi
}

info() {
#Prepends message with INFO
echo "INFO: $1"
}

StartBungee () {
  #Starts the Bungee Server
  cd $1
  if [ $BungeeExecChanged == "Yes" ]
  then
    $BungeeExec
  else
    $tmp01 = ${PWD##*/}
    $tmp02 = "-MCBSS"
    $tmp03 = $tmp01+$tmp02
    screen -mdS $tmp03 java $BungeeArgs -jar $BungeeJarName
  fi
}
StartServer () {
  #Starts the Normal Minecraft Server
  cd $1
  if [ $ServerExecChanged == "Yes" ]
  then
    $ServerExec
  else
    $tmp01 = ${PWD##*/}
    $tmp02 = "-MCSS"
    $tmp03 = $tmp01+$tmp02
    screen -mdS $tmp03 java $StandardArgs -jar $ServerJarName
  fi
}

HasChild () {
  #Sees if the PWD has childs, if so, will return TRUE (0)
  subdircount=( $(find $1 -maxdepth 1 -type d | wc -l) )
  debug "$subdircount Child Directories (Note, 1 means none)"
  if [ $subdircount -eq 1 ]
  then
    return 1
  else
    return 0
fi
}

IsDisabled () { 
  #Sees if PWD matches a folder in the IGNORE File

 # echo "Seeing if $1 is disabled"
 # echo "Importing $IgnoreList"
  cd $1
  debug "Seeing if $1 is disabled"
  #currDir=$1
  #I am using the Imported List of unwanted files from $IgnoreList and it is stored in $DisabledDirs
  disabledDirsNum=${#disabledDirs[@]}
  Disabled="IDK"
  local i
  for ((i=0; i<=$disabledDirsNum-1; ++i)) ;
    do
      debug "Comparing $PWD with $ServerRoot/${disabledDirs[i]} "
      if [ "$PWD" == "$ServerRoot/${disabledDirs[i]}" ]
      then
        debug "$PWD is the same as $ServerRoot/${disabledDirs[i]}"
        Disabled="Yes"
      fi
      debug "Disabled i is: $i - Max is $disabledDirsNum minus 1"
   done
  #Was it disabled?
  debug "Disabled is $Disabled"
  if [ "$Disabled" == "Yes" ]
  then
    return 0
  else
    return 1
  fi
}
IsServer () {
  #Checks to see if the folder contains the server jar
  cd $1
  if [ -f $ServerJarName ]
  then
    debug "I have detected $ServerJarName is here"
    return 0
  else
    debug "I have not detected $ServerJarName here"
    return 1
  fi
}
FindServers () {
  #Finds and starts the Server.
  local worker
  worker=$1
  cd $worker
  local dirs=( $(cd $1; find . -maxdepth 1 -type d -printf '%P\n') )
  #dirs=temp
  local dirsNum=${#dirs[@]}
  debug "I have found $dirsNum directories in $PWD!"
  debug "They are ${dirs[@]}"
  local i
  for ((i=0; i<=$dirsNum-1; ++i)) ;
    do
      cd $worker/${dirs[i]}
      info "Looking in $PWD"
      if [ "$PWD" == "$ServerRoot/$BungeeFolder" ]
      then
        info "I am in the Bungee Folder"
        StartBungee $PWD
      elif (IsDisabled $PWD)
      then
        info "I am in a Disabled Folder"
      elif (IsServer $PWD)
      then
        info "This Folder is a Server"
        StartServer $PWD
      elif (HasChild $PWD)
      then
        info "This Folder may contain servers, finding"
        #local comeback="$PWD"
        #debug "This is i before FindServers: $i"
        FindServers $PWD
        #debug "This is i after FindServers: $i"
        #cd $comeback
      else
        info "This is not a Server, nor does it containt possible server locations. No action taken, moving on to next directory."
      fi
    echo "#####################################"
   done
}

runProgram() {
    echo "####################################"
    debug "All functions defined"
    info "Finding and Starting Servers..."
    echo "####################################"
    FindServers $ServerRoot
    info "Complete. I have started all the server I could find."
}
    
if [ $installed == "Zombies" ]
then
  debug "ServerRoot = $ServerRoot"
  debug "ServerJarName = $ServerJarName"
  debug "BungeeJarName = $BungeeJarName"
  debug "BungeeFolder = $BungeeFolder"
  debug "IgnoreList = $IgnoreList"
  debug "BungeeArgs = $BungeeArgs"
  debug "StandardArgs = $StandardArgs"
  debug "disabledDirs = $disabledDirs"
  debug "IFS = $IFS"
  if [ isRoot() == 1 ]
  then
    runProgram()
  else
    echo "You are running this program as root user. Please don't for security reason."
    echo "Are you sure you want to continue (y/n)"
    read userIn
    if [ ${userIn,,} == "y" ]
      runProgram()
    else
      echo "To run the server as a non-root user, follow the intructions held within this file"
      echo "Exiting Script"
    fi
  fi
else
  info "You have not installed this Script, please open this up and follow instructions"
fi
