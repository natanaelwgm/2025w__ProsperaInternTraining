
** SETTING MACROS 

global datadir  "/Users/natanaelmassie2009/Downloads/Data Mikro Survei_Angkatan_Kerja_Nasional_2024_Agustus"


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
