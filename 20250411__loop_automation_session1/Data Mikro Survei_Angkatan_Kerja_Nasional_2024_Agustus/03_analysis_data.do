

** SETTING MACROS 

global datadir  "/Users/natanaelmassie2009/Downloads/Data Mikro Survei_Angkatan_Kerja_Nasional_2024_Agustus"


** Analysis 

// CARA 1 

global resultExcel "${datadir}/result.xlsx"

use "${datadir}/sak2408_diseminasi_combined_ready.dta"  , clear 

collapse (mean) income if status == 2 [iw = WEIGHT] , by(sex education KODE_PROV)

foreach var in education sex {
	decode `var' , gen(`var'_str)
	drop `var' 
	rename `var'_str `var' 
}

reshape wide income , i(KODE_PROV education) j(sex) string

levelsof KODE_PROV, local(kodeprovs)

local num_exported_provinces = 0

foreach kodeprov in `kodeprovs' {
	preserve 
	
	keep if KODE_PROV == "`kodeprov'"
	if `num_exported_provinces' == 0 {
		export excel using "${resultExcel}" , first(variables) sheet("Prov_`kodeprov'") replace
	}
	else {
		export excel using "${resultExcel}" , first(variables) sheet("Prov_`kodeprov'", replace) 
	}
	display "Running for prov: `kodeprov'"
	
	local num_exported_provinces = `num_exported_provinces' + 1
	
	restore // balik ke state di preserve 
}
