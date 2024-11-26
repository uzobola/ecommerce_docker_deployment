#!/bin/bash

# Directory Check

dir=/home/director/ubuntu/backup

#Check if Directory Exists
if [ -d "$dir" ]
then
   echo " Directory exists"

#Create directory if it does not exist
else
  sudo  mkdir -p "$dir"
   echo "directory created"
fi
