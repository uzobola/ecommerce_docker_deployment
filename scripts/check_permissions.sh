#!/bin/bash

# Check Permissions
# Write a script to check if a file is readable, writable, and executable.


read  -p " Full path to file name :" file_name

if [ -r "$file_name" ]; then
    echo "The file is readable."
else
    echo "The file is not readable."
fi



# Check if the file is writable
if [ -w "$file_name" ]; then
    echo "The file is writable."
else
    echo "The file is not writable."
fi


# Check if the file is executable
if [ -x "$file_name" ]; then
    echo "The file is executable."
else
    echo "The file is not executable."
fi


