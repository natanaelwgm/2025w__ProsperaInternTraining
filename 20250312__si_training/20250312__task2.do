
gl INPUTDATADIR "/Users/natanaelmassie2009/Downloads/SI Training 2" 

forval year = 2010/2015 {
    use "${INPUTDATADIR}/si`year'.dta", clear

    renvars, lower 
    renvars, subst("_" "")

    destring *vtlvcu*, replace force
    destring *psid*, replace force
    gen tahun = `year'
    keep *psid* *vtlvcu* tahun 

    ren *vtlvcu* vtlvcu 
    ren *psid* psid

    tempfile data`year'
    save `data`year'' , replace 
}

clear 

forval year = 2010/2015 {
    append using `data`year'' , force 
}

reshape wide vtlvcu, i(psid) j(tahun)

// save here 
tempfile checkpoint 
save `checkpoint' , replace 

// option 1 : from 30%+ is extreme
use `checkpoint' , clear 
gen diff = (vtlvcu2015 - vtlvcu2010)/vtlvcu2010 
global DIFF = 0.3
keep if abs(diff) > $DIFF & !mi(abs(diff))

// option 2 : bigger than 1.5 IQR 
use `checkpoint' , clear 
gen diff = (vtlvcu2015 - vtlvcu2010)/vtlvcu2010 
drop if mi(diff)
sum diff, detail
global IQR = r(p75) - r(p25)
global UPPER = r(p75) + 1.5 * $IQR
global LOWER = r(p25) - 1.5 * $IQR
keep if diff > $UPPER | diff < $LOWER & !mi(diff)
