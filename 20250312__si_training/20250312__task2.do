********************************************************************************
* Task 2: Handling and Analyzing Longitudinal Data
* 
* This do-file processes data from 2010-2015, combines datasets, 
* and identifies outliers using two different methodologies.
*
* Date: March 12, 2025
* Author: Natanael Massie
********************************************************************************

* Set the input data directory path
gl INPUTDATADIR "/Users/natanaelmassie2009/Downloads/SI Training 2" 

* Loop through each year from 2010 to 2015
forval year = 2010/2015 {
    * Load the data file for the current year
    use "${INPUTDATADIR}/si`year'.dta", clear

    * Convert variable names to lowercase
    renvars, lower 
    * Remove underscores from variable names
    renvars, subst("_" "")

    * Convert vtlvcu variables to numeric format
    destring *vtlvcu*, replace force
    * Convert psid variables to numeric format
    destring *psid*, replace force
    * Create a year variable
    gen tahun = `year'
    * Keep only the ID, value variables, and year
    keep *psid* *vtlvcu* tahun 

    * Standardize variable names across years
    ren *vtlvcu* vtlvcu 
    ren *psid* psid

    * Save the processed data to a temporary file
    tempfile data`year'
    save `data`year'' , replace 
}

* Clear the memory
clear 

* Combine all yearly datasets
forval year = 2010/2015 {
    * Append each year's data to the master dataset
    append using `data`year'' , force 
}

* Reshape data from long to wide format (years become columns)
reshape wide vtlvcu, i(psid) j(tahun)

// save here 
* Create a checkpoint before analyzing outliers
tempfile checkpoint 
save `checkpoint' , replace 

* OPTION 1: Identify extreme changes (more than 30% difference)
// option 1 : from 30%+ is extreme
* Load the checkpoint data
use `checkpoint' , clear 
* Calculate percentage change from 2010 to 2015
gen diff = (vtlvcu2015 - vtlvcu2010)/vtlvcu2010 
* Set threshold for extreme changes (30%)
global DIFF = 0.3
* Keep only observations with changes greater than threshold
keep if abs(diff) > $DIFF & !mi(abs(diff))

* OPTION 2: Identify outliers using 1.5 * IQR rule
// option 2 : bigger than 1.5 IQR 
* Load the checkpoint data again
use `checkpoint' , clear 
* Calculate percentage change from 2010 to 2015
gen diff = (vtlvcu2015 - vtlvcu2010)/vtlvcu2010 
* Remove missing values
drop if mi(diff)
* Calculate summary statistics for the difference variable
sum diff, detail
* Calculate the Interquartile Range (IQR)
global IQR = r(p75) - r(p25)
* Set the upper bound for outliers
global UPPER = r(p75) + 1.5 * $IQR
* Set the lower bound for outliers
global LOWER = r(p25) - 1.5 * $IQR
* Keep only observations outside the bounds (outliers)
keep if diff > $UPPER | diff < $LOWER & !mi(diff)
