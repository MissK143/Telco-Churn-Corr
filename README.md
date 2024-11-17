# Telco Customer Churn Project 
<img src="https://raw.githubusercontent.com/MissK143/Telco-Churn-Corr/main/Figures/logo-correlationfunnel.png" alt="Description of image" width="35%" align="right" style="border: 2px solid #2c3e50; margin-left: 10px;" />


> Speed Up Exploratory Data Analysis (EDA)

The goal of `correlationfunnel` is to speed up Exploratory Data Analysis
(EDA). Here’s how to use it.
## Installation

You can install the latest stable (CRAN) version of `correlationfunnel`
with:

``` r
install.packages("correlationfunnel")
```

You can install the development version of `correlationfunnel` from
[GitHub] Thank You Matt !! (https://github.com/business-science/) with:

``` r
devtools::install_github("business-science/correlationfunnel")
```

## Correlation Funnel in 2-Minutes

**Problem**: Exploratory data analysis (EDA) involves looking at
feature-target relationships independently. This process is very time
consuming even for small data sets. 

***Rather than search for relationships, what if we could let the relationships come to
us?***



Next, collect data to analyze. We’ll use Telco Customer Churn Data for a
Telecommunications Company that was popularized by the [IBM Cognos Analytics]([https://archive.ics.uci.edu/ml/datasets/Bank+Marketing](https://accelerator.ca.analytics.ibm.com/bi/?pathRef=.public_folders%2FIBM%2BAccelerator%2BCatalog%2FContent%2FDAT00148)). 

We can load the data with
`data("customer_churn_tbl")`.

``` r
# Use customer_churn_tbl to get a description of the customer churn features
data("customer_churn_tbl")
customer_churn_tbl %>% glimpse()

Rows: 7,043
Columns: 21
$ customerID       <chr> "7590-VHVEG", "5575-GNVDE", "3668-QPYBK", "7795-CFO…
$ gender           <chr> "Female", "Male", "Male", "Male", "Female", "Female…
$ SeniorCitizen    <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
$ Partner          <chr> "Yes", "No", "No", "No", "No", "No", "No", "No", "Y…
$ Dependents       <chr> "No", "No", "No", "No", "No", "No", "Yes", "No", "N…
$ tenure           <dbl> 1, 34, 2, 45, 2, 8, 22, 10, 28, 62, 13, 16, 58, 49,…
$ PhoneService     <chr> "No", "Yes", "Yes", "No", "Yes", "Yes", "Yes", "No"…
$ MultipleLines    <chr> "No phone service", "No", "No", "No phone service",…
$ InternetService  <chr> "DSL", "DSL", "DSL", "DSL", "Fiber optic", "Fiber o…
$ OnlineSecurity   <chr> "No", "Yes", "Yes", "Yes", "No", "No", "No", "Yes",…
$ OnlineBackup     <chr> "Yes", "No", "Yes", "No", "No", "No", "Yes", "No", …
$ DeviceProtection <chr> "No", "Yes", "No", "Yes", "No", "Yes", "No", "No", …
$ TechSupport      <chr> "No", "No", "No", "Yes", "No", "No", "No", "No", "Y…
```
### Response & Predictor Relationships

Modeling and Machine Learning problems often involve a response
(Enrolled in `Churn`, yes/no) and many predictors (OnlineSecurity, TechSupport,
Contract, etc). 
Our job is to determine which predictors are related to
the response. We can do this through **Binary Correlation Analysis**.

### Binary Correlation Analysis

Binary Correlation Analysis is the process of converting continuous
(numeric) and categorical (character/factor) data to binary features. 
We can then perform a correlation analysis to see if there is predictive
value between the features and the response (target).

#### Step 1: Convert to Binary Format

The first step is converting the continuous and categorical data into
binary (0/1) format. We de-select any non-predictive features. The
`binarize()` function then converts the features into binary features.

  - **Numeric Features:** Are binned into ranges or if few unique levels
    are binned by their value, and then converted to binary features via
    one-hot encoding

  - **Categorical Features**: Are binned by one-hot encoding

The result is a data frame that has only binary data with columns
representing the bins that the observations fall into. Note that the
output is shown in the `glimpse()` format. There are now 80 columns that
are binary (0/1).

``` r
customer_churn_bin <- customer_churn %>%
    select(-customerID) %>%
    binarize(n_bins = 4, thresh_infreq = 0.01)
Rows: 7,032
Columns: 56
$ gender__Female                             <dbl> 1, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 0…
$ gender__Male                               <dbl> 0, 1, 1, 1, 0, 0, 1, 0, 0, 1, 1, 1, 1…
$ SeniorCitizen__0                           <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…
$ SeniorCitizen__1                           <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0…
$ Partner__No                                <dbl> 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0…
$ Partner__Yes                               <dbl> 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1…
$ Dependents__No                             <dbl> 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 0, 1, 1…
$ Dependents__Yes                            <dbl> 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0…
$ `tenure__-Inf_9`                           <dbl> 1, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0…
$ tenure__9_29                               <dbl> 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 1, 0…
$ tenure__29_55                              <dbl> 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0…
$ tenure__55_Inf                             <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1…
$ PhoneService__No                           <dbl> 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0…
$ PhoneService__Yes                          <dbl> 0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1…
$ MultipleLines__No                          <dbl> 0, 1, 1, 0, 1, 0, 0, 0, 0, 1, 1, 1, 0…
$ MultipleLines__No_phone_service            <dbl> 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0…
$ MultipleLines__Yes                         <dbl> 0, 0, 0, 0, 0, 1, 1, 0, 1, 0, 0, 0, 1…
$ InternetService__DSL                       <dbl> 1, 1, 1, 1, 0, 0, 0, 1, 0, 1, 1, 0, 0…
$ InternetService__Fiber_optic               <dbl> 0, 0, 0, 0, 1, 1, 1, 0, 1, 0, 0, 0, 1…
$ InternetService__No                        <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0…
$ OnlineSecurity__No                         <dbl> 1, 0, 0, 0, 1, 1, 1, 0, 1, 0, 0, 0, 1…
$ OnlineSecurity__No_internet_service        <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0…
$ OnlineSecurity__Yes                        <dbl> 0, 1, 1, 1, 0, 0, 0, 1, 0, 1, 1, 0, 0…
$ OnlineBackup__No                           <dbl> 0, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1…
$ OnlineBackup__No_internet_service          <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0…
$ OnlineBackup__Yes                          <dbl> 1, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0…
$ DeviceProtection__No                       <dbl> 1, 0, 1, 0, 1, 0, 1, 1, 0, 1, 1, 0, 0…
$ DeviceProtection__No_internet_service      <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0…
$ DeviceProtection__Yes                      <dbl> 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 0, 0, 1…
$ TechSupport__No                            <dbl> 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 1…
$ TechSupport__No_internet_service           <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0…
$ TechSupport__Yes                           <dbl> 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0…
$ StreamingTV__No                            <dbl> 1, 1, 1, 1, 1, 0, 0, 1, 0, 1, 1, 0, 0…
$ StreamingTV__No_internet_service           <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0…
$ StreamingTV__Yes                           <dbl> 0, 0, 0, 0, 0, 1, 1, 0, 1, 0, 0, 0, 1…
$ StreamingMovies__No                        <dbl> 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 0…
$ StreamingMovies__No_internet_service       <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0…
$ StreamingMovies__Yes                       <dbl> 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1…
$ Contract__Monthly_to_Month                 <dbl> 1, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1, 0, 0…
$ Contract__One_year                         <dbl> 0, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1…
$ Contract__Two_year                         <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0…
$ PaperlessBilling__No                       <dbl> 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 1…
$ PaperlessBilling__Yes                      <dbl> 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 0…
$ `PaymentMethod__Bank_transfer_(automatic)` <dbl> 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0…
$ `PaymentMethod__Credit_card_(automatic)`   <dbl> 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1…
$ PaymentMethod__Electronic_check            <dbl> 1, 0, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0…
$ PaymentMethod__Mailed_check                <dbl> 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0…
$ `MonthlyCharges__-Inf_35.5875`             <dbl> 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0…
$ MonthlyCharges__35.5875_70.35              <dbl> 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0…
$ MonthlyCharges__70.35_89.8625              <dbl> 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0…
$ MonthlyCharges__89.8625_Inf                <dbl> 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1…
$ `TotalCharges__-Inf_401.45`                <dbl> 1, 0, 1, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0…
$ TotalCharges__401.45_1397.475              <dbl> 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0…
$ TotalCharges__1397.475_3794.7375           <dbl> 0, 1, 0, 1, 0, 0, 1, 0, 1, 1, 0, 0, 0…
$ TotalCharges__3794.7375_Inf                <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, …
$ Churn                                      <dbl> 0, 0, 1, 0, 1, 1, 0, 0, 1, …
> 
```
#### Step 2: Perform Correlation Analysis

The second step is to perform a correlation analysis between the
response (target = Churn) and the rest of the features.
This returns a specially formatted tibble with the feature, the bin, and
the bin’s correlation to the target. The format is exactly what we need
for the next step - Producing the **Correlation
Funnel**

``` r
customer_churn_corr <- customer_churn_bin %>%
    correlate(target = Churn)
> glimpse(customer_churn_corr)
Rows: 56
Columns: 3
$ feature     <fct> Churn, Contract, OnlineSecurity, TechSupport, tenure, InternetServic…
$ bin         <chr> NA, "Monthly_to_Month", "No", "No", "-Inf_9", "Fiber_optic", "Two_ye…
$ correlation <dbl> 1.0000000, 0.4045646, 0.3422352, 0.3368771, 0.3170774, 0.3074626, -0…
```

#### Step 3: Visualize the Correlation Funnel

A **Correlation Funnel** is an tornado plot that lists the highest
correlation features (based on absolute magnitude) at the top of the and
the lowest correlation features at the bottom. The resulting
visualization looks like a Funnel.
``` r
library(ggplot2)
customer_churn_corr %>%
    plot_correlation_funnel(interactive = TRUE)
 ```
<img src="https://github.com/MissK143/Telco-Churn-Corr/blob/3b77326f437d54f6add2dc3ee72fd9e2d924f60b/Figures/Corrolation%20Funnel%20Rplot.png" alt="Description of image" width="35%" align="right" style="border: 2px solid #2c3e50; margin-left: 10px;" />

### Examining the Results

The most important features are towards the top. We can investigate
these.

``` r
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
```
<img src="https://github.com/MissK143/Telco-Churn-Corr/blob/main/Figures/Top%20Features%20Correlated%20with%20Customer%20ChurnRplot.png" alt="Description of image" width="35%" align="centre" style="border: 2px solid #2c3e50; margin-left: 10px;" />

We can see that the following prospect features have a much greater
correlation with the Churn target:

   * *Contract*: Month-to-month (0.405): Customers on month-to-month contracts are more likely to churn, likely due to the flexibility of not being tied to a long-term commitment.
    * *OnlineSecurity*: No (0.342) and TechSupport: No (0.337): Lack of online security and tech support is associated with a higher likelihood of churn, indicating that these services may be valued by customers.
    * *tenure*: -Inf_9 (0.317): Customers with shorter tenure (0–9 months) are more likely to churn, suggesting that new customers may need more engagement or incentives to stay.
    * *InternetService*: Fiber_optic (0.307): Customers with fiber optic internet show a positive association with churn, which could reflect competition or customer satisfaction issues.
    * *PaymentMethod*: Electronic_check (0.301): Customers using electronic checks are more likely to churn, which may suggest a preference or behavior tied to this payment method.
    * *Contract*: Two_year (-0.302): Customers on two-year contracts are less likely to churn, indicating that long-term contracts help retain customers.

<img src="https://github.com/MissK143/Telco-Churn-Corr/blob/main/Figures/Top5%20Correlated%20Feat%20Rplot.png" alt="Description of image" width="35%" align="center" style="border: 2px solid #2c3e50; margin-left: 10px;"/>


## Data-Driven Insights
1. Retention Strategies:
    * Focus retention efforts on month-to-month contract customers by offering incentives to switch to longer-term contracts.
    * Consider promoting OnlineSecurity and TechSupport services, as these are linked to lower churn rates.
2. Customer Engagement for New Customers:
    * The positive correlation with short tenure indicates that new customers are at higher risk. Consider creating a robust onboarding experience or targeted offers for customers in their first year.
3. Product Adjustments:
    * Investigate why fiber optic customers might be more likely to churn, as this could point to specific satisfaction or pricing issues in that service tier.
4. Payment Method Insights:
    * Customers who pay via electronic check may have different behaviors; consider targeted campaigns or incentives for those using this payment method to encourage loyalty.

This data-driven approach allows you to prioritize customer segments for retention efforts and enhance your services based on customer behavior patterns. 

## Important
The main addition of `correlationfunnel` is to quickly expose feature
relationships to semi-processed data meaning missing (`NA`) values have
been treated, date or date-time features have been feature engineered,
and data is in a “clean” format (numeric data and categorical data are
ready to be correlated to a Yes/No response).

## Here are several great EDA packages that can help you understand data
issues (cleanliness) and get data preprared for Correlation Analysis\!

  - [Data Explorer](https://boxuancui.github.io/DataExplorer/) -
    Automates Exploration and Data Treatment. Amazing for investigating
    features quickly and efficiently including by data type, missing
    data, feature engineering, and identifying relationships.

