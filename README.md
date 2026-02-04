# COVID-19 Age Group Impact Analysis (HCMC) 📊

## 📌 Overview
This project utilizes **R** to analyze a COVID-19 dataset, focusing specifically on cases in Ho Chi Minh City. The primary objective is to investigate the statistical relationship between **Age Groups** and **Clinical Status** (Active, Recovered/Out, Deceased/Dead).

## 🛠 Tools & Libraries
* **Language:** R
* **Key Libraries:**  `ggplot2` (Data Visualization)
    * `reshape2` (Data Transformation)
    * `scales` (Formatting)
* **Statistical Method:** Pearson's Chi-squared Test.

## 🔍 Key Findings
1.  **Statistical Significance:** The Chi-squared test results indicate a significant association between age groups and clinical outcomes.
2.  **Heatmap Analysis:**  The **60+ age group** shows a strongly positive standardized residual for the "Dead" status, indicating a mortality rate significantly higher than the theoretical expectation.
    * Younger groups show negative residuals for "Dead," indicating lower risk.
3.  **Distribution Trends:** The Facet Bar Chart visualizes the exact percentage of outcomes across age groups, highlighting the sharp increase in severity for older demographics.

## 📷 Visualizations
### 1. Residuals Heatmap


### 2. Distribution by Status (Facet Plot)


---
*Project by Pham Nhat Quynh*
