

** SETTING MACROS 

global datadir  "/Users/natanaelmassie2009/Downloads/Data Mikro Survei_Angkatan_Kerja_Nasional_2024_Agustus"

** Importing data 

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
