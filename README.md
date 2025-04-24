# DepMap Exploratory Data Analysis (EDA) on Proteomics

This repository aims to conduct EDA on normalized protein data. 

Input:
"protein_quant_current_normalized.csv": file downloaded from Gygi lab (Link: https://gygi.hms.harvard.edu/publications/ccle.html) under Normalized and Other Data. 
In this section, data was downloaded from 2. Protein Quantification. 
<img width="900" alt="Screenshot 2025-04-24 at 11 52 22 AM" src="https://github.com/user-attachments/assets/abb34bff-fb80-47e6-a013-045a2ad9026c" />


Outputs:
cell_line_histograms: folder that contains histograms of all cell lines. These cell lines are identified by tissue and split accordingly in subfolders. These histograms contain 95%, 90%, 75%, and 50% cutoffs of to reveal more aboout the intensity of 


contains an .RMD file which is able to generate UpSet plots where the top 90% & top 95% are compared across cell lines to see similarities in expression.

The input for this code includes the protein_quant_current_normalized.csv file, which is manipulated to generate UpSet plots. 
