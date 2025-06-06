# UpSet Plots for Comparing Tissue Protein Expression Similarity
# Date: 2025-04-24
# Description: Generates UpSet plots to compare protein expression patterns across tissues

# Load required libraries
library(UpSetR)
library(dplyr)
library(stringr)
library(ggplot2)
library(readr)

# Load the data
data <- read_csv("~/Downloads/protein_quant_current_normalized.csv")

# Subset columns 49 to 425
data_expr <- data[, 49:425]

# Clean column names for safe processing
colnames(data_expr) <- make.names(colnames(data_expr))

# Extract correct tissue names (middle part between underscores)
extract_tissue <- function(colname) {
  parts <- unlist(strsplit(colname, "_"))
  if (length(parts) >= 3) {
    return(paste(parts[2:(length(parts) - 1)], collapse = "_"))
  } else {
    return(NA)
  }
}

# Get tissue info per column
tissue_info <- sapply(colnames(data_expr), extract_tissue)

# Group column names by tissue
tissue_groups <- split(colnames(data_expr), tissue_info)

# Function to apply bottom X% cutoff per column (i.e., KEEP top percent)
get_binary_matrix <- function(expr_df, keep_percent) {
  apply(expr_df, 2, function(col) {
    threshold <- quantile(col, probs = keep_percent, na.rm = TRUE)
    as.integer(col >= threshold)
  })
}

# Apply top 95% and 90% cutoffs (i.e., remove bottom 5% and 10%)
binary_95 <- as.data.frame(get_binary_matrix(data_expr, 0.05))  # KEEP top 95%
binary_90 <- as.data.frame(get_binary_matrix(data_expr, 0.10))  # KEEP top 90%

# Label columns
colnames(binary_95) <- colnames(data_expr)
colnames(binary_90) <- colnames(data_expr)

# UpSet plotting function (safe and debug-friendly)
plot_upset_by_tissue <- function(binary_matrix, label) {
  output_dir <- "upset_plots"
  if (!dir.exists(output_dir)) dir.create(output_dir)
  
  for (tissue in names(tissue_groups)) {
    cols <- tissue_groups[[tissue]]
    if (length(cols) < 2) next
    
    mat <- binary_matrix[, cols, drop = FALSE]
    mat <- mat[rowSums(mat) > 0, , drop = FALSE]  # remove rows with no expression
    
    # Skip if there are < 2 columns or < 1 protein left
    if (ncol(mat) < 2 || nrow(mat) == 0) {
      cat("⚠️  Skipping tissue:", tissue, "- Not enough data after filtering\n")
      next
    }
    
    # Sanitize filename
    safe_tissue <- gsub("[^A-Za-z0-9]", "_", tissue)
    safe_label <- gsub("[^A-Za-z0-9]", "", label)
    png_filename <- file.path(output_dir, paste0("UpSet_", safe_tissue, "_", safe_label, ".png"))
    
    # Debug info
    cat("🧪 Plotting tissue:", tissue, " →", png_filename, "\n")
    cat("  ➤ Matrix size:", dim(mat)[1], "proteins x", dim(mat)[2], "cell lines\n")
    cat("  ➤ Column totals:\n")
    print(colSums(mat))
    
    tryCatch({
      png(png_filename, width = 1200, height = 800)
      print(
        upset(mat,
              sets = colnames(mat),
              order.by = "freq",
              keep.order = TRUE,
              mainbar.y.label = paste("Shared Proteins in", tissue, "(Top", label, ")"),
              sets.x.label = "Proteins per Cell Line")
      )
      dev.off()
    }, error = function(e) {
      cat("❌ Failed for", tissue, "– Error:", e$message, "\n")
      dev.off()
    })
  }
}

# Run the UpSet plots
cat("Starting UpSet plot generation...\n")
cat("Generating plots for top 95% proteins...\n")
plot_upset_by_tissue(binary_95, "95%")

cat("Generating plots for top 90% proteins...\n")
plot_upset_by_tissue(binary_90, "90%")

cat("UpSet plot generation completed!\n")
cat("Check the 'upset_plots' directory for generated PNG files.\n")