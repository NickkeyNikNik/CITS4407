#!/usr/bin/awk -f

# find_highest.awk
# This AWK script calculates and determines which variable among 'homicide', 'gdp', 'life expectancy',
# and 'population' has the highest absolute value, and then prints out the variable with its value.

BEGIN {
    # Initialize variables by calculating the absolute values of each parameter.
    # Absolute values are used to handle negative numbers correctly, assuming variables could be negative.
    abs_homicide = sqrt(homicide * homicide); # Absolute value of 'homicide' rate
    abs_gdp = sqrt(gdp * gdp);                 # Absolute value of 'GDP'
    abs_life = sqrt(life * life);              # Absolute value of 'life expectancy'
    abs_population = sqrt(population * population); # Absolute value of 'population'

    # Set the initial maximum value and its corresponding name.
    # Here, we start by assuming 'homicide' has the highest absolute value.
    max_value = abs_homicide;
    max_name = "Homicide";

    # Sequentially compare the absolute values of 'gdp', 'life expectancy', and 'population'
    # to find the maximum value and update max_name accordingly.
    if (abs_gdp > max_value) {
        max_value = gdp;
        max_name = "GDP";
    }
    if (abs_life > max_value) {
        max_value = life;
        max_name = "Life Expectancy";
    }
    if (abs_population > max_value) {
        max_value = population;
        max_name = "Population";
    }
    else {
        max_value = homicide; # Fallback to homicide if no other values are greater (not typically reached due to logic flow)
    }

    # Output the result.
    # Print the name of the parameter with the highest absolute value and the value itself formatted to three decimal places.
    printf "Most predictive mean correlation with the Cantril ladder is %s (r = %0.3f)\n", max_name, max_value
}
