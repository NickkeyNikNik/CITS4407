# CITS4407
 
# Tobacco Nation Data Analysis Script

This Bash script is part of a university project that analyzes tobacco usage data from a CSV file. The script processes global tobacco usage data and extracts the maximum percentage of male or female tobacco users for a specific year or country. The script is designed to be flexible, allowing the user to filter the data by year or country code, and gender (male or female). The output provides insights into the highest recorded percentage of tobacco use for the specified filters.

## Features:
- **Data Filtering by Year**: The script allows the user to input a specific year (e.g., 2024) to retrieve the highest percentage of male or female tobacco users globally for that year.
- **Data Filtering by Country Code**: The script can also filter data by a country’s three-letter ISO code (e.g., JPN for Japan), showing the highest tobacco usage percentage for that country.
- **Gender-Specific Analysis**: The user can specify whether they are interested in data for "Male" or "Female" tobacco users. The script accepts case-insensitive inputs (i.e., "male" or "Male" will work).
- **Validation**: The script validates inputs, ensuring that the year is in the correct format (YYYY) or the country code is a valid 3-letter uppercase string. It also checks for proper gender input and verifies that the CSV file exists and contains data.

## Usage:
```bash
./tobacco_nation.sh <csv data file> <year | country code> <Male | Female>
```
