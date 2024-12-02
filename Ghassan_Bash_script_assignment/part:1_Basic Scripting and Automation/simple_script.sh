#!/bin/bash

# Script name: animal_fun_facts.sh
# Author: Ghassan
# Date: 18/10/2024
# Description: This script prompts the user for their name, age, and favorite animal.
#              It checks if the user is old enough to drive and provides a fun fact about their favorite animal.
#              The script also includes error handling and user input validation.

# Function to display fun facts about animals
fun_fact() {
    case $1 in
        lion)
            echo "Fun Fact: A lion's roar can be heard from as far as 5 miles away!"
            ;;
        rabbit)
            echo "Fun Fact: Rabbits are social animals that can purr when they're happy, just like cats!"
            ;;
        dog)
            echo "Fun Fact: Dogs are human-friendly animals and can sense time!"
            ;;
        cat)
            echo "Fun Fact: Cats can rotate their ears 180 degrees and hear high-frequency sounds humans can't!"
            ;;
        elephant)
            echo "Fun Fact: Elephants are the only mammals that cannot jump!"
            ;;
        *)
            echo "I don't have a fun fact about that animal. Sorry!"
            ;;
    esac
}

# Function to validate age input
validate_age() {
    # Check if age is a number
    if ! [[ "$1" =~ ^[0-9]+$ ]]; then
        echo "Error: Age must be a number."
        return 1
    fi
    return 0
}

# Function to validate animal input
validate_animal() {
    case $1 in
        lion|rabbit|dog|cat|elephant)
            return 0  # Valid animal
            ;;
        *)
            echo "Error: Invalid animal choice. Please choose from the predefined list."
            return 1  # Invalid animal
            ;;
    esac
}

# Prompt the user for their name
echo "What is your name?"
read -r name

# Validate that the user entered a name
if [[ -z "$name" ]]; then
    echo "Error: You must enter a name."
    exit 1
fi

# Greet the user
echo "Hello, $name!"

# Prompt the user for their age
while true; do
    echo "What is your age?"
    read -r age

    # Validate the age input
    validate_age "$age"
    if [ $? -eq 0 ]; then
        break  # If age is valid, exit the loop
    fi
done

# Check if the user is old enough to drive
if [ "$age" -ge 16 ]; then
    echo "You are old enough to drive!"
else
    echo "You are not old enough to drive yet!"
fi

# List of predefined animals
echo "Choose your favorite animal from the following list: lion, rabbit, dog, cat, elephant."

# Prompt the user for their favorite animal and validate the input
while true; do
    echo "Please enter your favorite animal:"
    read -r animal

    # Validate the animal input
    validate_animal "$animal"
    if [ $? -eq 0 ]; then
        break  # If animal is valid, exit the loop
    fi
done

# Display a fun fact about the selected animal
fun_fact "$animal"
