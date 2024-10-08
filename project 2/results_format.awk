#!/usr/bin/awk -f

# This AWK script reorganizes and filters tab-separated data based on a specified header format.
# It dynamically identifies column indices from the header to ensure correct data alignment in the output.

BEGIN {
    # Set the field separator for input and output to tab, to handle tab-separated values (TSV) effectively.
    FS = "\t"
    OFS = "\t"
    # Define a specific header for the output to ensure consistent column formatting.
    header = "Entity\tCode\tYear\tGDP per capita, PPP (constant 2017 international $)\tPopulation (historical estimates)\tHomicide rate per 100,000 population - Both sexes - All ages\tLife expectancy - Sex: all - Age: at birth - Variant: estimates\tCantril ladder score"
}

# Process the header row to map each expected column to a specific index for later use.
NR == 1 { 
    # Loop through all fields in the header to mark the columns that will be used.
    for (i = 1; i <= NF; i++) {
        if (!seen[$i]++) {
            col[i] = 1;  # Mark the column index if the header matches for the first time.
        }
    }
    
    # Assign specific indices to each relevant column based on the header names.
    # This allows for flexible column access in subsequent rows.
    for (i = 2; i <= NF; i++) {
        if (col[i]) {
            if ($i == "Entity") {
                entity_index = i  # Index for 'Entity'
            }
            if ($i == "Code") {
                code_index = i  # Index for 'Code'
            }
            if ($i == "Year") {
                year_index = i  # Index for 'Year'
            }
            if ($i == "\"GDP per capita, PPP (constant 2017 international $)\"") {
                gdp_index = i  # Index for 'GDP per capita'
            }
            if ($i == "Population (historical estimates)") {
                population_index = i  # Index for 'Population'
            }
            if ($i == "\"Homicide rate per 100,000 population - Both sexes - All ages\"") {
                homicide_index = i  # Index for 'Homicide rate'
            }
            if ($i == "Life expectancy - Sex: all - Age: at birth - Variant: estimates") {
                life_index = i  # Index for 'Life expectancy'
            }
            if ($i == "Cantril ladder score") {
                cantril_index = i  # Index for 'Cantril ladder score'
            }
        }
    }
    # Print the custom header to ensure consistency in output formatting.
    print header
}

# Process each record after the header to align data under the correct headers.
NR > 1 {
    # Print fields according to their dynamic indices established from the header.
    print $entity_index, $code_index, $year_index, $gdp_index, $population_index, $homicide_index, $life_index, $cantril_index
}
