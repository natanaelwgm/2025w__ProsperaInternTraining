# Survey of Industry (SI) Data Analysis

This directory contains Stata scripts for processing and analyzing data from the Indonesian Survey of Industry (2010-2015).

## Scripts

### 1. 20250312__task1.do

**Purpose:** Process annual Survey of Industry data and visualize value added trends over time.

**Key Functions:**
- Imports and standardizes SI data from 2010-2015
- Calculates total value added for each year
- Generates a bar chart visualization showing value added trends
- Shows growth from 891.1 trillion IDR in 2010 to 1,894 trillion IDR in 2015

**Usage:**
- Update the `INPUTDATADIR` global variable to point to your SI data files
- Run the script in Stata

### 2. 20250312__task2.do

**Purpose:** Create firm-level panel data and identify outliers in value added changes.

**Key Functions:**
- Efficiently processes annual SI data using loops
- Creates a firm-level panel dataset (2010-2015)
- Implements two outlier detection methods:
  - Fixed threshold (>30% change)
  - Statistical method (1.5 × IQR rule)

**Usage:**
- Update the `INPUTDATADIR` global variable to point to your SI data files
- Run the script in Stata

## Data Requirements

These scripts require access to the Survey of Industry dataset files (si2010.dta, si2011.dta, etc.), which are not included in this repository. The scripts expect the data files to be located in the directory specified by the `INPUTDATADIR` global variable. 