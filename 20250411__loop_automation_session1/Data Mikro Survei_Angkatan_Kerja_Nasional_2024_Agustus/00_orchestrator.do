
** SETTING MACROS 

global datadir  "/Users/natanaelmassie2009/Downloads/Data Mikro Survei_Angkatan_Kerja_Nasional_2024_Agustus"

global do_importing = 0
global do_preparing = 1
global do_analysis = 1

** Importing data 

if $do_importing == 1 {
do "${datadir}/01_importing_data.do"
}

** Preparing data

if $do_preparing == 1 {
do "${datadir}/02_preparing_data.do"
}

** Analysis 

if $do_analysis == 1 {
do "${datadir}/03_analysis_data.do"
}
