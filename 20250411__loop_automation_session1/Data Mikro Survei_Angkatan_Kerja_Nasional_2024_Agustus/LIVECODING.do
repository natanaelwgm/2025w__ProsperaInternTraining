

/*
	Looping 
*/

gl dummyDir "/Users/natanaelmassie2009/Downloads/Data Mikro Survei_Angkatan_Kerja_Nasional_2024_Agustus/tryoutFolder"

local numbers 1 2 3 4 5

foreach num in `numbers' {
	sysuse auto, clear 
	gen row = _n
	keep if mod(row, `num') == 0
	save "/Users/natanaelmassie2009/Downloads/Data Mikro Survei_Angkatan_Kerja_Nasional_2024_Agustus/tryoutFolder/auto_baris_kelipatan_`num'.dta" , replace
}

// local files : dir "`myfolder'" files "*.dta"

local all_files_in_dir :  dir "/Users/natanaelmassie2009/Downloads/Data Mikro Survei_Angkatan_Kerja_Nasional_2024_Agustus/tryoutFolder/" files "*.dta"

foreach file in `all_files_in_dir' {
	display "`file'"
	use "/Users/natanaelmassie2009/Downloads/Data Mikro Survei_Angkatan_Kerja_Nasional_2024_Agustus/tryoutFolder/`file'" , clear 
	display "Showing file: `file'"
	sum price
}

// pengulangan 

// foreach 
/*
foreach {sebuahNama} in {listNama} {
	// lakukan sesuatu
}
*/

// foreach name in {looese openednded list} 1
// foreach name in `local'
// foreach name of local namalocal
// foreach name of varlist namavarlist 4
// foreach name of numlist numbers

foreach name in carlos balqis dewita toar naufal waran { // 1
	display "TODAY `name' is present"
}

// equivalent dengan 
display "TODAY carlos is present"
display "TODAY balqis is present"
display "TODAY dewita is present"
display "TODAY toar is present"
display "TODAY naufal is present"
display "TODAY waran is present"

import dbase using "/Users/natanaelmassie2009/Downloads/Data Mikro Survei_Angkatan_Kerja_Nasional_2024_Agustus/sak2408_diseminasi_part1.dbf", clear 

// count number of variables 

foreach var of varlist _all { // 4
	display "`var'"
}

local angka = 2
display `angka'

local angkaLain = 3
display `angkaLain'

local hasilTambah = `angka' + `angkaLain'
display `hasilTambah'




local jumlahVariable = 0

foreach var of varlist _all {
	display "Kita menghitung variable `var'!"
	local jumlahVariable = `jumlahVariable' + 1
	display "Jadi sekarang ada `jumlahVariable' variable :)"
}

display "JUMLAH VARIABLE AKHIR: `jumlahVariable' variables!!"




/*

	GLOBAL VS LOCAL 

*/



// check jumlah variable dan jumlah baris -> local

import dbase using "/Users/natanaelmassie2009/Downloads/Data Mikro Survei_Angkatan_Kerja_Nasional_2024_Agustus/sak2408_diseminasi_part1.dbf", clear
display "JUMLAH BARIS:" 
display _N

local jumlahVariable = 0

foreach var of varlist _all {

	local jumlahVariable = `jumlahVariable' + 1

}

display "JUMLAH VARIABLE AKHIR: `jumlahVariable' variables!!"


// 2 -> global

import dbase using "/Users/natanaelmassie2009/Downloads/Data Mikro Survei_Angkatan_Kerja_Nasional_2024_Agustus/sak2408_diseminasi_part2.dbf", clear 
display "JUMLAH BARIS:"
display _N

global jumlahVariable = 0

foreach var of varlist _all {

	global jumlahVariable = $jumlahVariable + 1

}

display "JUMLAH VARIABLE AKHIR: $jumlahVariable variables!!"



/*

	flow:
		- kalau misal ni data belum gw .dta kan -> ya gw .dta kan 
		- kalau udah -> tinggal use .dta version nya

*/


global REIMPORT_FROM_DBF = 1 // jika 1 -> kita run dbf, save dta etc; 0 -> langsung use dta aja 


foreach num of numlist 1 2 {
	
	if $REIMPORT_FROM_DBF == 1 {
		import dbase using "/Users/natanaelmassie2009/Downloads/Data Mikro Survei_Angkatan_Kerja_Nasional_2024_Agustus/sak2408_diseminasi_part`num'.dbf", clear 
		save "/Users/natanaelmassie2009/Downloads/Data Mikro Survei_Angkatan_Kerja_Nasional_2024_Agustus/sak2408_diseminasi_part`num'.dta" , replace
	}
	
	use "/Users/natanaelmassie2009/Downloads/Data Mikro Survei_Angkatan_Kerja_Nasional_2024_Agustus/sak2408_diseminasi_part`num'.dta"
	
	display "JUMLAH BARIS:"
	display _N

	global jumlahVariable = 0

	foreach var of varlist _all {

		global jumlahVariable = $jumlahVariable + 1

	}

	display "JUMLAH VARIABLE AKHIR: $jumlahVariable variables!!"
}




// Merging 

// identify dia unique di apa
use "/Users/natanaelmassie2009/Downloads/Data Mikro Survei_Angkatan_Kerja_Nasional_2024_Agustus/sak2408_diseminasi_part1.dta" , clear
merge 1:1 URUTAN using  "/Users/natanaelmassie2009/Downloads/Data Mikro Survei_Angkatan_Kerja_Nasional_2024_Agustus/sak2408_diseminasi_part2.dta" , keep(1 3) gen(merge_dbf)


// Berapa rata-rata pendapatan tiap laki2 vs wanita yang bekerja di tiap provinsi by education, export ke Excel dan tiap provinsi jadi 1 Excel sheet 



// Berapa rata-rata pendapatan tiap laki2 vs wanita di tiap provinsi, export ke Excel dan tiap provinsi jadi 1 Excel sheet, tapi buat di tiap sheet ada 2 tabel; 1 tabel untuk yang bekerja by education; 1 tabel untuk yang memiliki usaha



// Secara best practice 

/*

	- Taruh nama direktori di global 

*/

** SETTING MACROS 

global datadir  "/Users/natanaelmassie2009/Downloads/Data Mikro Survei_Angkatan_Kerja_Nasional_2024_Agustus"

global do_importing = 0
global do_preparing = 1
global do_analysis = 1

** Importing data 

if $do_importing == 1 {

global REIMPORT_FROM_DBF = 0 // jika 1 -> kita run dbf, save dta etc; 0 -> langsung use dta aja 
global CHECK_DATA_DIMENSION = 0

foreach num of numlist 1 2 {
	
	if $REIMPORT_FROM_DBF == 1 {
		import dbase using "${datadir}/sak2408_diseminasi_part`num'.dbf", clear 
		save "${datadir}/sak2408_diseminasi_part`num'.dta" , replace
		display "Done for data `num'!"
	}
	
	if $CHECK_DATA_DIMENSION == 1 {
		use "${datadir}/sak2408_diseminasi_part`num'.dta" , clear
		
		display "JUMLAH BARIS:"
		display _N

		global jumlahVariable = 0

		foreach var of varlist _all {

			global jumlahVariable = $jumlahVariable + 1

		}

		display "JUMLAH VARIABLE AKHIR: $jumlahVariable variables!!"
	}
}

use "${datadir}/sak2408_diseminasi_part1.dta" , clear
merge 1:1 URUTAN using  "${datadir}/sak2408_diseminasi_part2.dta" , keep(1 3) gen(merge_dbf)

save "${datadir}/sak2408_diseminasi_combined.dta" , replace 

}

if $do_preparing == 1 {

** Preparing data

use "${datadir}/sak2408_diseminasi_combined.dta"  , clear 

// Income
// treatment = missing means zero 
egen income = rowtotal(R16_1 R16_2)

// Education -> 1 is No formal educ; 2 is lulus primary; 3 is lulus secondary; 4 is lulus tertiary 
recode R6A (1 = 1 "No formal education") (2 = 2 "Primary") (3/6 = 3 "Secondary") (7/12 = 4 "Tertiary") , gen(education)

// male female 
recode K4 (1=1 "Male") (2=2 "Female") , gen(sex)

// status bekerja 
recode R14A (1/3 = 1 "Usaha") (4/6 = 2 "Bekerja") (nonmissing = 3 "Lainnya") (missing = 99 "Menganggur/out of labor force") , gen(status)

save "${datadir}/sak2408_diseminasi_combined_ready.dta" , replace 

}

if $do_analysis == 1 {

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

}
