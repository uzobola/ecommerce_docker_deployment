#!/bin/bash

# Log Script
# Create a BASH script that will search the log file for "404" errors and identify the IP addresses associated with them.  
# Then provide the number of times each IP encountered a 404.


log_file="web-server-access-logs.log"
output_file="ip_counts.txt"


# "grep" searches the log file for "404" errors 
# "awk -F" : uses ' ,  ' as the field delimiter and '{print $2}' prints out the second field of the output 
# "uniq -c" : counts the occurences of each unique IP address in the list
# "sort -nr" : Sorts numerically in descending order with the highest count first 
echo " "
grep " 404 " "$log_file" | awk -F'[, ]+' '{print $2}' | sort | uniq -c | sort -nr > "$output_file"

echo " "
echo "You can find the count of IP addresses in this file: " $output_file
echo " "
echo " The top 3 IP's with the most occurence are"
echo " "
cat "$output_file" | head -3

