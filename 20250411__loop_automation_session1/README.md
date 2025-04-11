# Loop Automation Session 1

This directory contains Stata scripts for processing and analyzing Indonesian Labor Survey (Survei Angkatan Kerja Nasional) data from August 2024.

## Directory Structure

The data and scripts are contained in the `Data Mikro Survei_Angkatan_Kerja_Nasional_2024_Agustus/` directory, which includes:

### Main Scripts

- **00_orchestrator.do** - Main script that orchestrates the workflow by calling the other scripts in sequence
- **01_importing_data.do** - Handles importing data from DBF files and merging datasets
- **02_preparing_data.do** - Prepares and transforms data for analysis
- **03_analysis_data.do** - Performs data analysis and exports results to Excel

### Other Files

- **LIVECODING.do** - Script created during the live coding session in Zoom. Contains all the code from the session but is less structured than the final scripts.
- **tryoutFolder/** - Directory containing example datasets created during the session to demonstrate looping techniques

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

## Note

The LIVECODING.do file contains the code developed during the live Zoom session and may be less organized than the streamlined versions in the numbered scripts (00, 01, 02, 03) that are called by the orchestrator. 