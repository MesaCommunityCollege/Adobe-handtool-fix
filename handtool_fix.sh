#!/bin/sh

#CHANGE KEYBOARD SETTINGS FOR CURRENT USER 09042019

currentuser=$(scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }') 
echo $currentuser

# Disable press-and-hold for keys in favor of key repeat 
defaults delete NSGlobalDomain ApplePressAndHoldEnabled 
sudo su - "$currentuser" -c "defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool FALSE"

# Set keyboard repeat rate 
defaults delete NSGlobalDomain KeyRepeat 
sudo su - "$currentuser" -c "defaults write NSGlobalDomain KeyRepeat -int 60"

# Set a shorter Delay until key repeat 
defaults delete -g InitialKeyRepeat 
sudo su - "$currentuser" -c "defaults write -g InitialKeyRepeat -float 68"

# POSIX loop kill cfprefsd daemon and flush cache. 
x=10; while [ $x -gt 0 ]; do sudo killall cfprefsd; x=$(($x-1)); done

sudo killAll Finder 
sleep 10
sudo pkill loginwindow
exit 0
