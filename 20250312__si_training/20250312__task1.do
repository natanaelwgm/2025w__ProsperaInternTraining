/********************************************************************************
* PROGRAM: 20250312__task1.do
* PURPOSE: Process Survey of Industry data from Indonesia (2010-2015)
*          and create visualization of value added over time
* CREATED: March 12, 2025
* DATA SOURCE: SI Training dataset
* NOTES: This script imports annual SI data, standardizes variables,
*        and generates a bar chart showing value added trends
********************************************************************************/

/* Set the input data directory path */
gl INPUTDATADIR "/Users/natanaelmassie2009/Downloads/SI Training 2" // Define global variable for data location

/* Process 2010 data */
use "${INPUTDATADIR}/si2010.dta", clear // Load 2010 Survey of Industry data
destring *VTLVCU*, replace force // Convert string variables to numeric format
collapse (sum) va=*VTLVCU* // Sum all value added variables into one total
replace va = va * 1e3 // Scale the value (multiply by 1000)
gen year = 2010 // Create year identifier
tempfile data2010 // Create temporary filename
save `data2010' , replace // Save processed 2010 data


/* Process 2011 data */
use "${INPUTDATADIR}/si2011.dta", clear // Load 2011 Survey of Industry data
destring *VTLVCU*, replace force // Convert string variables to numeric format
collapse (sum) va=*VTLVCU* // Sum all value added variables into one total
replace va = va * 1e3 // Scale the value (multiply by 1000)
gen year = 2011 // Create year identifier
tempfile data2011 // Create temporary filename
save `data2011' , replace // Save processed 2011 data

/* Process 2012 data */
use "${INPUTDATADIR}/si2012.dta", clear // Load 2012 Survey of Industry data
destring *VTLVCU*, replace force // Convert string variables to numeric format
collapse (sum) va=*VTLVCU* // Sum all value added variables into one total
replace va = va * 1e3 // Scale the value (multiply by 1000)
gen year = 2012 // Create year identifier
tempfile data2012 // Create temporary filename
save `data2012' , replace // Save processed 2012 data

/* Process 2013 data */
use "${INPUTDATADIR}/si2013.dta", clear // Load 2013 Survey of Industry data
destring *VTLVCU*, replace force // Convert string variables to numeric format
collapse (sum) va=*VTLVCU* // Sum all value added variables into one total
replace va = va * 1e3 // Scale the value (multiply by 1000)
gen year = 2013 // Create year identifier
tempfile data2013 // Create temporary filename
save `data2013' , replace // Save processed 2013 data

/* Process 2014 data */
use "${INPUTDATADIR}/si2014.dta", clear // Load 2014 Survey of Industry data
destring *VTLVCU*, replace force // Convert string variables to numeric format
collapse (sum) va=*VTLVCU* // Sum all value added variables into one total
replace va = va * 1e3 // Scale the value (multiply by 1000)
gen year = 2014 // Create year identifier
tempfile data2014 // Create temporary filename
save `data2014' , replace // Save processed 2014 data

/* Process 2015 data */
use "${INPUTDATADIR}/si2015.dta", clear // Load 2015 Survey of Industry data
destring *vtlvcu*, replace force // Convert string variables to numeric format (note: lowercase variable name)
collapse (sum) va=*vtlvcu* // Sum all value added variables into one total
replace va = va * 1e3 // Scale the value (multiply by 1000)
gen year = 2015 // Create year identifier
tempfile data2015 // Create temporary filename
save `data2015' , replace // Save processed 2015 data

/* Combine all years of data */
clear // Clear memory
append using `data2010' , force // Append 2010 data
append using `data2011' , force // Append 2011 data
append using `data2012' , force // Append 2012 data
append using `data2013' , force // Append 2013 data
append using `data2014' , force // Append 2014 data
append using `data2015' , force // Append 2015 data

/*
va	year
8.911e+14	2010
1.018e+15	2011
1.153e+15	2012
1.475e+15	2013
1.689e+15	2014
1.894e+15	2015
*/

// Format the value added in trillions for better readability
gen va_trillion = va / 1e12 // Convert from absolute value to trillions of IDR

// Create a bar chart
graph bar va_trillion, over(year) /// // Create bar chart with year on x-axis
    bar(1, color(navy*0.8)) /// // Set bar color to navy blue (80% intensity)
    ytitle("Value Added (Trillion IDR)", size(medium)) /// // Label y-axis
    title("Value Added in Indonesia, 2010-2015", size(large) color(black)) /// // Add main title
    subtitle("Annual totals from Survey of Industry", size(medsmall)) /// // Add subtitle
    note("Source: SI Training dataset", size(small)) /// // Add data source note
    ylabel(, angle(horizontal) format(%9.1fc)) /// // Format y-axis labels
    graphregion(color(white)) bgcolor(white) /// // Set white background
    blabel(bar, format(%9.1fc) size(medium)) /// // Add value labels to bars
    scheme(s2color) // Set color scheme
