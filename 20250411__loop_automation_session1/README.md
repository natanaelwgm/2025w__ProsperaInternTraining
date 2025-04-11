# Loop Automation Session 1

This directory contains Stata scripts for processing and analyzing Indonesian Labor Survey (Survei Angkatan Kerja Nasional) data from August 2024. This training is designed for Prospera interns to understand the basics of looping and automation controls in Stata.

## Training Overview

This session covers essential Stata programming concepts to help interns develop efficient data processing workflows:

### Core Concepts Covered

- **Looping**
  - `foreach` - Iterating through lists, variables, or datasets
  - `forvalues` - Iterating through numeric sequences
  
- **Flow Control**
  - `if/else` statements - Controlling program flow based on conditions
    - Not just for data filtering (`generate dua = 2 if male == 1`)
    - For controlling code execution:
      ```stata
      if $do_importing == 1 {
          // Import code here
      }
      ```
  
- **Macros / Variable Naming**
  - `global` - Session-wide variables that persist across do-files
  - `local` - Script-level variables with limited scope
  
- **Macros at File Level**
  - `tempfile` - Creating temporary datasets
  - `preserve` / `restore` - Saving and restoring data states
  
- **Orchestration**
  - `do` - Running scripts from within scripts for modular workflows

## Concepts Used in Each Script

### LIVECODING.do
This script demonstrates most of the concepts in a single file and shows the evolution of the code:
- **Looping**: Uses `foreach` to process multiple files and iterate through variables
  ```stata
  foreach num in `numbers' {
    sysuse auto, clear 
    gen row = _n
    keep if mod(row, `num') == 0
    save "...auto_baris_kelipatan_`num'.dta" , replace
  }
  ```
- **Flow Control**: Uses `if/else` to conditionally execute code blocks
  ```stata
  if $REIMPORT_FROM_DBF == 1 {
    import dbase using "...sak2408_diseminasi_part`num'.dbf", clear 
    save "...sak2408_diseminasi_part`num'.dta" , replace
  }
  ```
- **Macros**: Demonstrates both `local` and `global` variables
  ```stata
  local jumlahVariable = 0
  foreach var of varlist _all {
    local jumlahVariable = `jumlahVariable' + 1
  }
  ```
- **File Operations**: Shows directory listing and file handling
  ```stata
  local all_files_in_dir : dir "..." files "*.dta"
  ```

### 00_orchestrator.do
This script demonstrates the orchestration pattern:
- **Global Variables**: Sets up global variables for directory paths and execution flags
  ```stata
  global datadir  "..."
  global do_importing = 0
  global do_preparing = 1
  global do_analysis = 1
  ```
- **Flow Control**: Uses if statements to conditionally execute each step
  ```stata
  if $do_importing == 1 {
    do "${datadir}/01_importing_data.do"
  }
  ```
- **Orchestration**: Shows how to call other do-files from a master file

### 01_importing_data.do
This script focuses on data import and preparation:
- **Looping**: Uses `foreach` with `numlist` to process multiple data files
  ```stata
  foreach num of numlist 1 2 {
    // process file part1, part2, etc.
  }
  ```
- **Flow Control**: Conditional execution based on global flags
  ```stata
  if $REIMPORT_FROM_DBF == 1 {
    // import from DBF
  }
  
  if $CHECK_DATA_DIMENSION == 1 {
    // check dimensions
  }
  ```
- **Data Operations**: Demonstrates merging datasets
  ```stata
  merge 1:1 URUTAN using "${datadir}/sak2408_diseminasi_part2.dta"
  ```

### 02_preparing_data.do
This script shows data transformation:
- **Variable Creation**: Uses egen to create derived variables
  ```stata
  egen income = rowtotal(R16_1 R16_2)
  ```
- **Recoding**: Shows how to recode variables into more usable forms
  ```stata
  recode R6A (1 = 1 "No formal education") (2 = 2 "Primary") (3/6 = 3 "Secondary") (7/12 = 4 "Tertiary"), gen(education)
  ```

### 03_analysis_data.do
This script demonstrates advanced techniques:
- **Data Aggregation**: Uses collapse for summarizing data
  ```stata
  collapse (mean) income if status == 2 [iw = WEIGHT], by(sex education KODE_PROV)
  ```
- **Reshaping**: Shows how to reshape data from long to wide format
  ```stata
  reshape wide income, i(KODE_PROV education) j(sex) string
  ```
- **Looping with Levelsof**: Demonstrates how to iterate through unique values
  ```stata
  levelsof KODE_PROV, local(kodeprovs)
  foreach kodeprov in `kodeprovs' {
    // code for each province
  }
  ```
- **Preserve/Restore**: Shows how to work with temporary data states
  ```stata
  preserve
    // manipulate data
  restore
  ```
- **Exporting**: Demonstrates exporting to Excel with sheet management
  ```stata
  export excel using "${resultExcel}", first(variables) sheet("Prov_`kodeprov'", replace)
  ```

## Directory Structure

The data and scripts are contained in the `Data Mikro Survei_Angkatan_Kerja_Nasional_2024_Agustus/` directory, which includes:

### Main Scripts

- **00_orchestrator.do** - Main script that orchestrates the workflow by calling the other scripts in sequence. Demonstrates how to control execution flow using global flags.
- **01_importing_data.do** - Handles importing data from DBF files and merging datasets. Shows looping through multiple files and checking data dimensions.
- **02_preparing_data.do** - Prepares and transforms data for analysis. Demonstrates variable recoding and generation.
- **03_analysis_data.do** - Performs data analysis and exports results to Excel. Illustrates using loops for repetitive tasks like exporting data by province.

### Other Files

- **LIVECODING.do** - Script created during the live coding session in Zoom. Contains all the code from the session but is less structured than the final scripts.
- **tryoutFolder/** - Directory containing example datasets created during the session to demonstrate looping techniques with the `auto` dataset.

## Workflow

The workflow is organized in a modular way:

1. **00_orchestrator.do** controls which parts of the workflow to run using global flags
2. **01_importing_data.do** imports data from DBF files and merges them
3. **02_preparing_data.do** creates derived variables for analysis
4. **03_analysis_data.do** performs the analysis and exports results to Excel

## Usage

To run the entire workflow, open and run `00_orchestrator.do` in Stata. You can modify the global flags at the beginning of the script to control which parts of the workflow to execute:

```stata
global do_importing = 0  // Set to 1 to run the data importing step
global do_preparing = 1  // Set to 1 to run the data preparation step
global do_analysis = 1   // Set to 1 to run the analysis step
```

## Learning Objectives

By the end of this training, interns should be able to:
- Write efficient looping structures to process multiple files or perform repetitive tasks
- Use conditional execution to control program flow
- Understand the difference between global and local macros and when to use each
- Implement modular code organization using the do-file orchestration pattern
- Apply these techniques to automate common data processing tasks

## Note

The LIVECODING.do file contains the code developed during the live Zoom session and may be less organized than the streamlined versions in the numbered scripts (00, 01, 02, 03) that are called by the orchestrator. 