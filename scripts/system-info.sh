#!/bin/bash

# System Info Script
# Create a script that will present the following menu to a user to choose from:
# 1. IP Addresses ( Public and Private)
# 2. Current User 
# 3. CPU Information  
# 4. Memory Information 
# 5. Top 5 Memory Processes
# 6. Top 5 CPU Processes #Same as above
# 7. Network Connectivity
# The script should continue to ask the user to choose from the menu until they want to exit.



# Define Variables to Collect System information
private_ip=$(hostname -I)
public_ip=$(curl -s https://icanhazip.com)
current_user=$(whoami)
cpu_info=$(lscpu | grep "^CPU(s):" | awk '{print $1, $2}')
total_mem=$(free -h | grep "Mem:" | awk '{print $2}')
free_mem=$(free -h | grep "Mem:" | awk '{print $4}')
top_mem_proc=$(ps aux --sort=-%mem | head -n 6 | awk '{print $1, $2, $4, $11}')
top_cpu_proc=$(ps aux --sort=-%cpu | head -n 6 | awk '{print $1, $2, $3, $11}')



# User Makes Choice
while true; do
 echo " "
 echo "Welcome user  $(whoami)"
 echo " " 
 echo "If you would like system information, please pick one number from the following options"
 echo " "
 echo "1) IP Addresses ( Public and Private)"
 echo "2) Current User" 
 echo "3) CPU Information"  
 echo "4) Memory Information" 
 echo "5) Top 5 Memory Processes"
 echo "6) Top 5 CPU Processes"
 echo "7) Network Connectivity"
 echo "8) Exit"
 read -p "Enter your choice : " choice
 echo

 
# Choice 1) IP Addresses ( Public and Private)
if [ "$choice" -eq 1 ]; then
echo " You chose information on your Public and Private IP Address" 
echo "Your Private IP Address is: $private_ip and your Public IP address is: $public_ip"
echo 


# Choice 2)Current User"
elif [ "$choice" -eq 2 ]; then
echo "You chose information on the Current User"
echo " The name of your current user is: $current_user"
echo 


# Choice 3) CPU Information
elif [ "$choice" -eq 3 ]; then
echo "You chose CPU Information"
echo "CPU information: Your System has $cpu_info"
echo 



# Choice 4) Memory Information
elif [ "$choice" -eq 4 ]; then
echo "You chose Memory Information"
echo "Your Total memory is  $total_mem you have only $free_mem available"
echo


# Choice 5) Top 5 Memory Processes
elif [ "$choice" -eq 5 ]; then
echo " You chose Top 5 Memory Processes"
echo "Your Top 5 memory Processes are: $top_mem_proc "
echo 


# Choice 6) Top 5 CPU Processes
elif [ "$choice" -eq 6 ]; then
echo " You chose Top 5 CPU Processes"
echo "Your Top 5 cpu Processes are: $top_cpu_proc "
echo 


# Choice 7) Network Connectivity
elif [ "$choice" -eq 7 ]; then
echo "You chose Network Connectivity"
echo " "
read -p "Enter the website or IP address to connect to: " website

    
# Collect the result of pinging the website in a variable
  ping_result=$(ping -c4 $website )

# Handle ping errors
  ping_exit_status=$?

  if [ $ping_exit_status -ne 0 ]; then
   echo "Error: $ping_result"
   echo "Unable to connect to $website. Please check the address and try again."

  else

# Extract average time and packet loss from ping result
  average_time=$( echo "$ping_result" | tail -2 | grep "time" | awk '{print $10}')
  packet_loss=$( echo "$ping_result" | tail -2 | grep "time" | awk '{print $6, $7, $8}')

# Display the results
 echo "Connected to $website. It took $average_time  and there was $packet_loss."
 fi


# Choice 8) Exit
elif [ "$choice" -eq 8 ]; then
  echo "Exiting..."
  exit 0

break
    else
# Handle Invalid Options 
       echo "Invalid option. Please enter a number between 1 and 8."
fi

 echo " "
 read -p "Press Enter to continue..."
 echo " "

done
