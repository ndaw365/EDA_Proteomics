# Exploratory Data Analysis (EDA) on Proteomics

This repository aims to conduct EDA on normalized protein data. With conducting EDA, the purpose of this project aims to visualize the distributions of intensity across all cells lines, setting cutoffs to see how many proteins are gained and lost in order to compare similarities of protein expression across cell lines. 

## Input:
**protein_quant_current_normalized.csv**: file downloaded from [Gygi lab](https://gygi.hms.harvard.edu/publications/ccle.html) under Normalized and Other Data. 
In this section, data was downloaded from 2. Protein Quantification. 

<img width="900" alt="Screenshot 2025-04-24 at 11 52 22 AM" src="https://github.com/user-attachments/assets/abb34bff-fb80-47e6-a013-045a2ad9026c" />

This data contains:
- proteins as rows
- cell lines as columns
- normalized intensities as input values

## Code: 

**upset_plots.R**: holds code that generates the upset plots. 
  Summary of code: for generating UpSet plots:  
  Data is cleaned to only work with cell line columns. This includes only working with columns that hold expression values and extracting column names that represent different types of tissue. Then, a binary expression matrix is formed to determine if value is above cutoff (1) or below cutoff (0). Cutoffs keep top 95% and top 90% of protein intensities. The specific tissue UpSet plots selects the relevant cell lines which filter to proteins that hold some expression. UpSetR is used to express how proteins are shared across cell lines. 

**histograms.R**: holds code that generates the histograms that reveal protein expression. 
  Each tissue type is looped through cell lines and a histogram is generated that holds the intensity values. 
  Cutoff thresholds are identified as the vertical dashed lines where the red lines mark each cutoff. 
  

## Outputs:

### upset_plots:
- Code generates "upset_plots" folder
- compares cell lines within the same tissue to see similarities in expression.
- upset plots are split into cutoffs of 90% and 95%.
- upset plots are in .png format 

  (output has been manually compressed into .zip to be uploaded in git repository successfully)

An example of an output of an upset plot. This example is for Bone Tissue determined at the 95% cutoff. 

![UpSet_BONE_95](https://github.com/user-attachments/assets/c8dd1080-d792-414f-a7a2-873a04d6cc88)


### cell_line_histograms_all:
- folder that contains histograms of all cell lines.
- Histograms are identified by cell line, tissue of origin, and tag identifer. 
- subfolders are different tissue types with histograms in .png format 
- These cell lines are identified by tissue and split accordingly in subfolders.
- These histograms contain 95%, 90%, 75%, and 50% cutoffs of to reveal the distribution of intensity across all cell lines. This is done to identify a number of protein abundances which are meaningful to keep per cell line. This allows visualization of which proteins were kept/removed based on cutoffs. 
- These histograms are also labeled to express values that fall above the cutoff.

  (output is too large to be uploaded on git repository successfully. Run code to save on your local device)

An example of an output of the histogram plot. This example is the CORL23 cell line within lung tissue with a TenPx29 tag identifier. 

<img width="1397" alt="Screenshot 2025-05-05 at 12 13 09 AM" src="https://github.com/user-attachments/assets/88e00e6c-57cc-4f75-a7e2-d5626e0461b0" />

