#!/usr/bin/env bash
#
# Project 1
# Name: Nicodemus Ong
# Student ID: 22607943

# Function to display usage
usage() {
    echo "Usage: $0 <csv data file> <year | country code> <Male | Female>"
    exit 1
}

# Check for the correct number of command-line arguments
if [ "$#" -ne 3 ]; then
    usage
fi

# Assign command-line arguments to variables for clarity
csvFileName="$1"
year_countryCode="$2"
gender="$3"

# Convert gender to lowercase
gender=$(echo "$3" | tr '[:upper:]' '[:lower:]')

# Validate gender input to be either 'Male' or 'Female' (case-insensitive)
if [ "$gender" != "male" ] && [ "$gender" != "female" ]; then
    echo "Invalid gender. Please enter Male or Female."
    usage
fi

# Check if the CSV file is valid and not empty
if ! firstLine=$(tail -n +2 "$csvFileName" 2>/dev/null | head -n 1) || [ -z "$firstLine" ]; then
    echo "The named input file $csvFileName does not exist or has zero length"
    exit 1
fi

# Initialize variables
year=""
countryCode=""

# Determine if year_countryCode is a year or a country code
if [[ "$year_countryCode" =~ ^[0-9]+$ ]]; then
    year="$year_countryCode"
elif [[ "$year_countryCode" =~ ^[A-Z]{3}$ ]]; then
    countryCode="$year_countryCode"
else
    echo "Unable to determine if input is a year or country code: $year_countryCode"$'\n'"Please follow the format:"$'\n'"Year: YYYY e.g. 2024"$'\n'"Country Code: 3 Uppercase Letters e.g. JPN"
    exit 1
fi

# Function to process and display the maximum percentage of tobacco users
display_data() {
    if [ -z "$filtered_data" ]; then
        echo "There is no data for the selected $1 $2"
        exit 1
    fi

    local displayYear=$(echo "$filtered_data" | cut -d ',' -f5)
    local location=$(echo "$filtered_data" | cut -d ',' -f4)
    local locationCode=$(echo "$filtered_data" | cut -d ',' -f3)
    local percentage=$(echo "$filtered_data" | cut -d ',' -f7)
    local timeQualifier=$([ -n "$year" ] && [ "$year" -gt 2024 ] && echo "is predicted to be" || echo "was")
    
    # Change gender to the right format manually
    # Extract the first letter and capitalize it
    first_letter=${gender:0:1}
    first_letter_capitalized=$(echo $first_letter | tr '[:lower:]' '[:upper:]')

    # Extract the rest of the string
    rest_of_string=${gender:1}

    # Concatenate them
    capitalized_gender="$first_letter_capitalized$rest_of_string"

    if [ -n "$year" ]; then

        echo "The global maximum percentage of $capitalized_gender tobacco users in the year $displayYear for $location ($locationCode) $timeQualifier at $percentage%"
    else
        echo "The global maximum percentage of $capitalized_gender tobacco users for $location ($countryCode) $timeQualifier $percentage% in $displayYear"
    fi
}

# Main logic for filtering data and determining the outcome
if [ -n "$year" ]; then
    filtered_data=$(grep ",$year," "$csvFileName" | grep -i ",$gender," | sort -t ',' -k7nr | head -n 1)
    display_data "year" "$year"
elif [ -n "$countryCode" ]; then
    filtered_data=$(grep ",$countryCode," "$csvFileName" | grep -i ",$gender," | sort -t ',' -k7nr | head -n 1)
    display_data "country with the code" "$countryCode"
fi

