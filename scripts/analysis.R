# ==============================================================================
# PROJECT: COVID-19 Epidemiological Data Analysis (HCMC 2020-2021)
# AUTHOR: Pham Nhat Quynh
# Description: Statistical analysis of the relationship between age groups 
#              and clinical status using Chi-squared test and visualizations 
#              (Heatmap & Facet Bar Chart).
# ==============================================================================

# --- 1. LOAD LIBRARIES ---
setwd("E:/BAI TAP R")
library(readxl)
library(ggplot2) 
library(scales)    # For data transformation (melt function)
library(reshape2) 

# --- 2. LOAD DATA ---
# Read dataset
covid <- read.csv("data_covid_case_en.csv")

# Filter data for Ho Chi Minh City
hcm <- subset(covid, Location == "Ho Chi Minh")

# Age Binning (Create Age Groups)
hcm$AgeGroup <- cut(
  hcm$Age,
  breaks = c(-Inf, 5, 17, 39, 59, Inf),
  labels = c("0-5", "6-17", "18-39", "40-59", "60+"),
  right = TRUE
)

# Inspect structure
str(hcm)
# Create Contingency Table
df_counts <- as.data.frame(table(hcm$AgeGroup, hcm$Status))
colnames(df_counts) <- c("AgeGroup", "Status", "Count")

# --- 3. STATISTICAL TESTING (CHI-SQUARE TEST) ---
# Create matrix for testing
matran <- table(hcm$Status, hcm$AgeGroup)
print(matran)

# Perform Chi-squared test
chisq <- chisq.test(matran)
print(chisq)

# --- 4. VISUALIZATION 1: RESIDUALS HEATMAP ---
# Extract Standardized Residuals
residuals <- chisq$stdres 
melted_residuals <- melt(residuals) # Convert to Long format for ggplot
colnames(melted_residuals) <- c("Status", "AgeGroup", "StdResidual")

# Plot Heatmap
heatmap_plot <- ggplot(melted_residuals, aes(x = Status, y = AgeGroup, fill = StdResidual)) +
  geom_tile(color = "white") + 
  geom_text(aes(label = round(StdResidual, 2)), color = "black") + 
  scale_fill_gradient2(low = "steelblue", mid = "white", high = "red", midpoint = 0) + 
  labs(
    title = "Heatmap of Adjusted Standardized Residuals",
    subtitle = "Red: Higher than expected (Positive) | Blue: Lower than expected (Negative)",
    x = "Clinical Status",
    y = "Age Group",
    fill = "Std. Res"
  ) +
  theme_minimal()

# Save Heatmap
ggsave("Fig1_Heatmap_Residuals.png", plot = heatmap_plot, width = 10, height = 6)


# --- 5. VISUALIZATION 2: FACET BAR CHART (DISTRIBUTION) ---

# Step 5.1: Prepare Percentage Data
# Calculate total cases per Age Group
df_sum <- aggregate(Count ~ AgeGroup, data = df_counts, sum)
names(df_sum)[2] <- "Total"

# Merge totals back to main dataframe
df_plot <- merge(df_counts, df_sum, by = "AgeGroup")

# Calculate Percentage (Crucial step)
df_plot$Percentage <- df_plot$Count / df_plot$Total

# Step 5.2: Plot Facet Bar Chart
plot_facet <- ggplot(df_plot, aes(x = AgeGroup, y = Percentage, fill = Status)) +
  geom_col(width = 0.7) +
  # Split into 3 separate plots with free Y scales
  facet_wrap(~Status, scales = "free_y") + 
  # Add percentage labels
  geom_text(aes(label = percent(Percentage, accuracy = 0.1)), 
            vjust = -0.5, size = 3.5, fontface = "bold") +
  # Format Y-axis as percentage
  scale_y_continuous(labels = scales::percent, expand = expansion(mult = c(0, 0.2))) + 
  # Custom Colors
  scale_fill_manual(values = c(
    "Dead" = "#B71C1C",    # Dark Red
    "Active" = "#F57F17",  # Orange
    "Out" = "#4CAF50"      # Green (Recovered)
  )) +
  labs(
    title = "Distribution of Clinical Status by Age Group in HCMC",
    subtitle = "Note: Y-axis scales differ between panels to highlight trends",
    x = NULL,
    y = "Percentage (%)"
  ) +
  theme_bw() +
  theme(
    plot.title = element_text(face = "bold", size = 14, hjust = 0.5),
    axis.text.x = element_text(angle = 30, hjust = 1, face = "bold"),
    legend.position = "none",
    strip.text = element_text(size = 12, face = "bold", color = "white"),
    strip.background = element_rect(fill = "gray40")
  )

# Print and Save
print(plot_facet)
ggsave("Fig2_Distribution_Facet.png", plot = plot_facet, width = 14, height = 7, dpi = 300)
