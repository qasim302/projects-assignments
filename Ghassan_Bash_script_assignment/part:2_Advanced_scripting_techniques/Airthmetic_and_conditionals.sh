#!/bin/bash

# Script Name: basic_arithmetic.sh
# Author: Ghassan
# Date: 19/10/2024
# Description: This script accepts two numbers from the user and performs basic
#              arithmetic operations: addition, subtraction, multiplication, and division.
#              It checks for valid numeric input and handles errors such as division by zero.

# Function to check if the input is a valid number (handles integers and decimals)
is_number() {
    if [[ "$1" =~ ^-?[0-9]+([.][0-9]+)?$ ]]; then
        return 0  # Valid number
    else
        return 1  # Invalid number
    fi
}

# Function to prompt the user for a number and validate it
get_number_input() {
    local num
    while true; do
        echo "$1"  # $1 contains the prompt message
        read num
        if is_number "$num"; then
            echo "$num"
            return
        else
            echo "Error: '$num' is not a valid number. Please enter a numeric value."
        fi
    done
}

# Prompt the user for the first number and validate it
num1=$(get_number_input "Enter the first number:")

# Prompt the user for the second number and validate it
num2=$(get_number_input "Enter the second number:")

# Perform arithmetic operations
sum=$(echo "$num1 + $num2" | bc)
difference=$(echo "$num1 - $num2" | bc)
product=$(echo "$num1 * $num2" | bc)

# Check for division by zero
if [[ "$num2" == "0" ]]; then
    division="undefined (division by zero)"
else
    division=$(echo "scale=2; $num1 / $num2" | bc)
fi

# Display the results with clear formatting
echo ""
echo "Results of basic arithmetic operations:"
echo "--------------------------------------"
echo "$num1 + $num2 = $sum"
echo "$num1 - $num2 = $difference"
echo "$num1 * $num2 = $product"
echo "$num1 / $num2 = $division"
