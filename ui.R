# App that graphs PCR/RCB. User selects arm and clinical criteria.

library(shiny)
library(shinyWidgets)

# Enter drug information here
myarms = c("","DRUG_A","Drug_B", "Drug_C")
# Enter in clinical variables here
mychoices = c("HER2-", "HER2+", "HR-", "HR+", "MP_0", "MP_1", "pCR_0", "pCR_1", 
              "RCB_I", "RCB_II", "RCB_III")

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
