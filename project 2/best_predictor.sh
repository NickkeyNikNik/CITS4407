#!/usr/bin/env bash
#
# Project 2
# Name: Nicodemus Ong
# Student ID: 22607943
# This script processes a .tsv file to calculate the mean correlation of different factors
# (homicide rate, GDP, life expectancy, and population) with the Cantril ladder, then finds
# the highest predictor among them.

# Function to check if a file exists and is not empty.
check_file() {
  if [[ ! -s "$1" ]]; then
    echo "Error: $1 is missing or empty." > /dev/stderr
    exit 1
  fi
}

# Check if the correct number of arguments is provided. If not, print usage information and exit with status 1.
if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <.tsv File (1)>" > /dev/stderr
  exit 1
fi

# Check if the input file exists and is not empty.
if [[ ! -s "$1" ]]; then
  echo "Error: Input file $1 is missing or empty." > /dev/stderr
  exit 1
fi

# Process the input .tsv file to calculate correlations for different parameters using an AWK script.
# Each parameter uses a different option to specify the column of interest.
gawk -f predictor_cantril_corr.awk -v option="h" "$1" > homicide.tsv
gawk -f predictor_cantril_corr.awk -v option="g" "$1" > gdp.tsv
gawk -f predictor_cantril_corr.awk -v option="l" "$1" > life.tsv
gawk -f predictor_cantril_corr.awk -v option="p" "$1" > population.tsv

# Check if the intermediate output files were created successfully.
check_file homicide.tsv
check_file gdp.tsv
check_file life.tsv
check_file population.tsv

# Calculate the mean correlation from the output files for each parameter and store the result.
# This involves summing all second column values and dividing by the count of rows to get the average.
homicide=$(gawk -F'\t' '{ sum += $2; count++ } END { if (count > 0) printf "%.3f", sum / count; else print "N/A" }' homicide.tsv)
gdp=$(gawk -F'\t' '{ sum += $2; count++ } END { if (count > 0) printf "%.3f", sum / count; else print "N/A" }' gdp.tsv)
life=$(gawk -F'\t' '{ sum += $2; count++ } END { if (count > 0) printf "%.3f", sum / count; else print "N/A" }' life.tsv)
population=$(gawk -F'\t' '{ sum += $2; count++ } END { if (count > 0) printf "%.3f", sum / count; else print "N/A" }' population.tsv)

# Remove the temporary .tsv files created for calculations.
rm -f population.tsv life.tsv gdp.tsv homicide.tsv

# Output the mean correlations to the console.
echo "Mean correlation of Homicide Rate with Cantril ladder is $homicide"
echo "Mean correlation of GDP with Cantril ladder is $gdp"
echo "Mean correlation of Population with Cantril ladder is $population"
echo -e "Mean correlation of Life Expectancy with Cantril ladder is $life \n"

# Check if correlations are calculated and not "N/A"
if [[ $homicide == "N/A" || $gdp == "N/A" || $life == "N/A" || $population == "N/A" ]]; then
  echo "Error: Failed to calculate correlations correctly. One or more mean correlation values are N/A." > /dev/stderr
  exit 1
fi

# Call the AWK script to find the highest predictor among the computed values.
awk -v homicide="$homicide" -v gdp="$gdp" -v life="$life" -v population="$population" -f get_highest_predictor.awk
