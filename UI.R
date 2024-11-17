library(shiny)

ui <- fluidPage(
    includeCSS("www/styles.css"),  # Link to the custom CSS file
    tags$style(HTML("
        h2 {
            color: #fffff; /* White */
            font-weight: bold;
        }
    ")),
    titlePanel("Customer Churn Prediction Dashboard"),

    sidebarLayout(
        sidebarPanel(
            h4("Input Customer Details"),
            selectInput("contractType", "Contract Type:", choices = c("Month-to-month", "One year", "Two year")),
            selectInput("internetService", "Internet Service:", choices = c("DSL", "Fiber optic", "No")),
            sliderInput("tenure", "Tenure (Months):", min = 1, max = 72, value = 1),
            numericInput("monthlyCharges", "Monthly Charges:", value = 50, min = 0),
            selectInput("onlineSecurity", "Online Security:", choices = c("Yes", "No")),
            actionButton("predictBtn", "Predict Churn")
        ),

        mainPanel(
            tabsetPanel(
                tabPanel("Prediction Output",
                         h4("Churn Prediction"),
                         verbatimTextOutput("predictionOutput")),
                tabPanel("Model Summary",
                         h4("Logistic Regression Model Summary"),
                         verbatimTextOutput("modelSummary"))
            )
        )
    )
)

