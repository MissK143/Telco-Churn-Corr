library(dplyr)
library(correlationfunnel)

# Remove NA values
customer_churn <- na.omit(customer_churn_tbl)
# Convert `Churn` to binary numeric format
customer_churn <- customer_churn %>%
    mutate(Churn = ifelse(Churn == "Yes", 1, 0))
# Convert `Churn` to a binary numeric (0/1)
customer_churn <- customer_churn %>%
    mutate(Churn = as.numeric(Churn))  # Convert to numeric if not already
# Edit out Month -to-month to Monthly basis
customer_churn$Contract <- gsub(
    "Month-to-month", "Month to Month",customer_churn$Contract)
table(customer_churn$Contract)

# Step 1: Binarize the dataset, excluding non-predictive columns such as `customerID`
customer_churn_bin <- customer_churn %>%
    select(-customerID) %>%
    binarize(n_bins = 4, thresh_infreq = 0.01)
glimpse(customer_churn_bin)

# Churn has 2 coloumns Rename `Churn__1` to `Churn` and drop `Churn__0`
customer_churn_bin <- customer_churn_bin %>%
    rename(Churn = Churn__1) %>%
    select(-Churn__0)

# Step 2: Perform Correlation Analysis with `correlate()`
customer_churn_corr <- customer_churn_bin %>%
    correlate(target = Churn)
glimpse(customer_churn_corr)
# Step 3: Visualize the Correlation Funnel
library(ggplot2)
customer_churn_corr %>%
    plot_correlation_funnel(interactive = TRUE)

# View Strong Correlations
strong_correlations <- customer_churn_corr %>%
    filter(abs(correlation) > 0.3) %>%
    arrange(desc(correlation))
print(strong_correlations)

# Plot top correlated features with churn
library(ggplot2)
ggplot(strong_correlations, aes(x = reorder(feature, correlation), y = correlation)) +
    geom_bar(stat = "identity", fill = "skyblue") +
    coord_flip() +
    labs(title = "Top Features Correlated with Customer Churn",
         x = "Feature",
         y = "Correlation with Churn")

# Examine the Top Correlated Features
customer_churn_corr %>%
    filter(feature %in% c("Contract", "OnlineSecurity", "TechSupport",
                          "tenure", "InternetService", "PaymentMethod")) %>%
    plot_correlation_funnel(interactive = FALSE, limits = c(-0.4, 0.4))


install.packages("DataExplorer")
## View basic description fo
introduce(customer_churn)
create_report(customer_churn)
library(ggplot2)
create_report(customer_churn, y = "Churn")
glimpse(customer_churn_tbl)
