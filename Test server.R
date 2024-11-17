server <- function(input, output, session) {
    # Reactive function to predict churn based on user inputs
    prediction <- eventReactive(input$predictBtn, {
        new_data <- data.frame(
            tenure = input$tenure,
            Contract = factor(input$contractType, levels = levels(train_data$Contract)),
            MonthlyCharges = input$monthlyCharges,
            InternetService = factor(input$internetService, levels = levels(train_data$InternetService)),
            OnlineSecurity = factor(input$onlineSecurity, levels = levels(train_data$OnlineSecurity))
        )

        # Generate prediction probability for the logistic regression model
        prob <- predict(logistic_model, newdata = new_data, type = "response")
        round(prob * 100, 2)  # Return probability as a percentage
    })

    # Display Prediction Output
    output$predictionOutput <- renderText({
        paste("Predicted Churn Probability:", prediction(), "%")
    })

    # Display Model Summary
    output$modelSummary <- renderPrint({
        summary(logistic_model)
    })
}

# Run the application
shinyApp(ui, server)

install.packages("plotly")
