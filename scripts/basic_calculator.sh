#!/bin/bash

# Basic Calculator
#The script should prompt the user to enter two integers.
#The script should prompt the user to choose an operation: +,-,*,/
#Use conditionals ('if`, `elif`, `else') to perform the chosen operation.
#Display the result of the operation.
#Handle division by zero with an appropriate error message.



# Prompt the user to enter two integers
echo " "
read -p "Enter a number: " num1
read -p "Enter another number: " num2



# Prompt the user to choose an operation
echo "Choose an operation from the list : ( +, -, *, / )"
read -p "Enter your choice: " operation
echo " " 


# Perform the chosen operation using conditionals
if [ "$operation" == "+" ]; then
    result=$((num1 + num2))
    echo "Result: $num1 + $num2 = $result"
elif [ "$operation" == "-" ]; then
    result=$((num1 - num2))
    echo "Result: $num1 - $num2 = $result"
elif [ "$operation" == "*" ]; then
    result=$((num1 * num2))
    echo "Result: $num1 * $num2 = $result"
elif [ "$operation" == "/" ]; then
    if [ "$num2" -ne 0 ]; then
        result=$((num1 / num2))
        echo "Result: $num1 / $num2 = $result"


# Handle divisison by zero
    else
        echo "Error: Division by zero is not allowed."
    fi
else
    echo "Invalid operation. Please choose one of +, -, *, /."
fi

echo " " 
