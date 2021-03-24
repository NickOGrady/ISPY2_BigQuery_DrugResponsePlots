# App that graphs PCR/RCB. User selects arm and clinical criteria.

library(shiny)
library(shinyWidgets)

# Enter drug information here
# Human Readable on left, column names on right
myarms = c("",
           "DRUG_A" = "'<<Drug_A column name from  BQ table>>'",
           "DRUG_B" = "'<<Drug_B column name from BQ Table'",
           "Drug_C" = "'<<Drug_C coumna name from BQ Table'")

# Enter in clinical variables here
# human readable on left, column names on right
mychoices = c("HER2-" = "HER2 = '0'",
              "HER2+" = "HER2 = '1'", 
              "HR-" = "HR = '0'",
              "HR+" = "HR = '1'",
              "MP_0" = "MP = '0'",
              "MP_1" = "MP = '1'", 
              "pCR_0" = "Admin_PCR = '0'",
              "pCR_1" = "Admin_PCR = '1'", 
              "RCB_I" = "RCB_Class = 'I'", 
              "RCB_II" = "RCB_Class = 'II'", 
              "RCB_III" = "RCB_Class = 'III'")

# Page Layout, titles, sidebar info
ui <- fluidPage(
  
  titlePanel(HTML(
    paste(
      h3("ISPY2 PRoBE:"),h4("PCR / RCB Plots")))),
  
  sidebarLayout(
    sidebarPanel(
      
      pickerInput(
        inputId = "myPicker1", 
        label = "Select/deselect treatment arms", 
        choices = myarms,
        selected = NULL,
        options = list(
          `actions-box` = TRUE, 
          size = 10,
          `selected-text-format` = "count > 5"
        )),
      pickerInput(
        inputId = "myPicker2", 
        label = "Select/deselect clinical features", 
        choices = mychoices, 
        options = list(
          `actions-box` = TRUE, 
          size = 10,
          `selected-text-format` = "count > 5"
        ), multiple = TRUE), 
      
      submitButton("Submit")), # End sidebar panel
    
    # Text for main panel, displays right of choices
    mainPanel(HTML(paste(h4("Query Results:"))),
              textOutput(outputId = "mytextoutput"),
               plotOutput(outputId = "sqlresults"))
  )
) # end UI fluid page
