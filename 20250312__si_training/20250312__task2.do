
gl INPUTDATADIR "/Users/natanaelmassie2009/Downloads/SI Training" 

forval year = 2010/2015 {
    use "${INPUTDATADIR}/si`year'.dta", clear
    renvars, lower 
    destring *vtlvcu*, replace force
    gen year = `year'
    keep *psid* *vtlvcu* *year* 
    save `data`year'' , replace 
}