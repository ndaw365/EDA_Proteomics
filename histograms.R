# Histograms of Protein Expression
# Date: 2025-04-24

# Load required libraries
library(ggplot2)
library(dplyr)
library(readr)
library(stringr)

# Load the data
data <- read_csv("~/Downloads/protein_quant_current_normalized.csv")
data_expr <- data[, 49:425]
colnames(data_expr) <- make.names(colnames(data_expr))

# Extract tissue names from column names
extract_tissue <- function(colname) {
  parts <- unlist(strsplit(colname, "_"))
  if (length(parts) >= 3) paste(parts[2:(length(parts) - 1)], collapse = "_") else NA
}

tissue_info <- sapply(colnames(data_expr), extract_tissue)
tissue_groups <- split(colnames(data_expr), tissue_info)

# Define cutoffs
cutoffs <- c(0.95, 0.90, 0.75, 0.5)
cutoff_labels <- paste0("Top ", cutoffs * 100, "%")

# Assign colors conditionally
cutoff_colors <- setNames(
  sapply(cutoffs, function(x) {
    if (x == 0.95) {
      "red"
    } else if (x == 0.90) {
      "orange"
    } else if (x == 0.75) {
      "blue"
    } else if (x == 0.5) {
      "purple"
    } else {
      "black"  # fallback default
    }
  }),
  cutoff_labels
)

# Create output folder
top_dir <- "cell_line_histograms_all"
dir.create(top_dir, showWarnings = FALSE)

# Loop over tissues and cell lines
for (tissue in names(tissue_groups)) {
  cell_lines <- tissue_groups[[tissue]]
  tissue_dir <- file.path(top_dir, gsub("[^A-Za-z0-9]", "_", tissue))
  dir.create(tissue_dir, showWarnings = FALSE)
  
  for (cell in cell_lines) {
    values <- data_expr[[cell]]
    df <- data.frame(Expression = values)
    
    # Compute cutoff values and counts
    cutoff_vals <- quantile(values, probs = 1 - cutoffs, na.rm = TRUE)
    counts_above <- sapply(cutoff_vals, function(val) sum(values >= val, na.rm = TRUE))
    cutoff_labels <- paste0("Top ", cutoffs * 100, "%")
    count_labels <- paste0(cutoff_labels, "\n(n = ", counts_above, ")")
    
    # Data for vertical lines and dummy points
    legend_df <- data.frame(
      cutoff = cutoff_vals,
      label = cutoff_labels,
      count_label = count_labels
    )
    
    # Build plot
    p <- ggplot(df, aes(x = Expression)) +
      geom_histogram(bins = 50, fill = "white", color = "black") +
      ggtitle(paste("Expression Histogram -", cell)) +
      xlab("Expression") +
      ylab("Protein Count") +
      theme_classic(base_size = 14) +
      # Add vertical cutoff lines
      geom_vline(data = legend_df, aes(xintercept = cutoff, color = label),
                 linetype = "dashed", size = 1) +
      # Add invisible points to trigger combined legend
      geom_point(data = legend_df,
                 aes(x = Inf, y = Inf, color = label),
                 size = 0, show.legend = TRUE) +
      # Add combined legend with color-matched entries
      scale_color_manual(
        name = "Top Percentile Cutoffs &
        Values Above Cutoff",
        values = cutoff_colors,
        labels = count_labels
      ) +
      theme(
        legend.position = "right",
        legend.title = element_text(size = 10),
        legend.text = element_text(size = 9),
        legend.key.size = unit(0.6, "cm"),
        legend.key.height = unit(1.0, "cm"),
        legend.spacing.y = unit(0.6, "cm"),
        legend.box = "vertical"
      )
    
    # Save output
    safe_cell <- gsub("[^A-Za-z0-9]", "_", cell)
    output_path <- file.path(tissue_dir, paste0(safe_cell, "_histogram.png"))
    ggsave(filename = output_path, plot = p, width = 10, height = 5)
  }
}