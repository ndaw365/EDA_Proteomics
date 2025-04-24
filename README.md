# Exploratory Data Analysis (EDA) on Proteomics

This repository aims to conduct EDA on normalized protein data. With conducting EDA, the purpose of this project aims to visualize the distributions of intensity across all cells lines, setting cutoffs to see how many proteins are gained and lost in order to compare similarities of protein expression across cell lines. 

## Input:
"protein_quant_current_normalized.csv": file downloaded from [Gygi lab](https://gygi.hms.harvard.edu/publications/ccle.html) under Normalized and Other Data. 
In this section, data was downloaded from 2. Protein Quantification. 

<img width="900" alt="Screenshot 2025-04-24 at 11 52 22 AM" src="https://github.com/user-attachments/assets/abb34bff-fb80-47e6-a013-045a2ad9026c" />

This data contains:
- proteins as rows
- cell lines as columns
- normalized intensities as input values

## Code: 

upsetplots.Rmd: holds code that generates the upset plots. 

histograms.Rmd: holds code that generates the histogram plots. 




## Outputs:

### upset_plots:
- Generated upset plots to compare cell lines within the same tissue to see similarities in expression.
- upset plots are split into cutoffs of 90% and 95%. 


### cell_line_histograms_all:
- folder that contains histograms of all cell lines.
- These cell lines are identified by tissue and split accordingly in subfolders.
- These histograms contain 95%, 90%, 75%, and 50% cutoffs of to reveal the distribution of intensity across all cell lines. This is done to identify a number of protein abundances which are meaningful to keep per cell line. This allows visualization of which proteins were kept/removed based on cutoffs. 
- These histograms are also labeled to express values that fall above the cutoff. 


