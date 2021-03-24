# App that graphs PCR/RCB. User selects arm and clinical criteria.


library(bigrquery)

server <- function(input, output) {
  
  # Enter in your google project here
  project = <<your google project>>
  
  output$sqlresults = renderPlot({
    
    # App Auto runs, this is to catch on first empty run
    armchoice = input$myPicker1
    if (armchoice == "") {
      output$mytextoutput = renderText("No Criteria selected")
      # Everything else is for code after Arm Selection
    } else {
      globdata()
    }
  })

  
  globdata = reactive({
    
    req(input$myPicker1)   
    
    # This automatically searches for RCB, PCR, and Arm.  Change if you want other variables.
    mysql = paste0("SELECT RCB_Index, Admin_PCR, Arm FROM `<<your big query table>>` WHERE ARM in (")
    
    # Add arm to SQL query
    uarm_choice <- paste0(input$myPicker1,", '<<Control Arm column name from BQ Table>>') ")
    
    # Add clinical features to SQL Query
    clinlist = input$myPicker2
    uclin_choice <- "AND "
    for (i in 1:length(clinlist)) {
      uclin_choice <- paste0(uclin_choice, clinlist[i])
      if (i != length(clinlist)) {
        uclin_choice <- paste0(uclin_choice, " AND ")
      }
    }
   
    # Run SQL in BigQuery, turn it into data frame, then graph
    sql1 = paste0(mysql, uarm_choice, uclin_choice)
    tb1 = bq_project_query(project, sql1)
    # tb1 runs the actual bigquery and returns results
    # df1 turns results into a data frame
    # from df1 on, you can code in R like usual
    df1 = data.frame(bq_table_download(tb1))
    # Control data frame
    df2 = df1[df1$Arm == 'Paclitaxel', c(1,2)]
    # User choice data frame
    df1 = df1[!df1$Arm == 'Paclitaxel', c(1,2)]
    # pCR variables, 0 or 1
    pcrdrug_freq = table(df1$Admin_PCR)
    pcrcontr_freq = table(df2$Admin_PCR)
    # RCB variables, freqencies
    idf1 = which(df1$RCB_Index == "NULL")
    rcb_drug = df1[-idf1,]
    rcb_drug = as.numeric(rcb_drug$RCB_Index)
    idf2 = which(df2$RCB_Index == "NULL")
    rcb_contr = df2[-idf2,]
    rcb_contr = as.numeric(rcb_contr$RCB_Index)
    
    # Catch if there is not enough data for graphs
    if (any(c(length(pcrdrug_freq), length(pcrcontr_freq)) == 1) | any(c(length(rcb_drug), length(rcb_contr)) < 1)) {
      output$mytextoutput = renderText("Search did not produce enough data for plots")
    } else {
    
    # Graph
    
    #For PCR
    my_ylim = ceiling(max(pcrdrug_freq, pcrcontr_freq))
    # For RCB
    xaxis = ceiling(max(rcb_drug,rcb_contr))
    yaxis = max(table(rcb_drug),table(rcb_contr)) + 1
    
    
    par(mfrow=c(2,2))
    
    # pCR drug
    barplot(pcrdrug_freq, main="PCR distribution of DRUG_A", ylab = "# of cases", names.arg = c("PCR Not Achieved", "PCR Achieved"), ylim = c(0,my_ylim), col = "darkgray")
    
    # pCR Control
    barplot(pcrcontr_freq, main="PCR distribution of CONTROL", ylab = "# of cases", names.arg = c("PCR Not Achieved", "PCR Achieved"), ylim = c(0,my_ylim), col = "deepskyblue3")
    
    # RCB drug
    hist(as.numeric(rcb_drug), 
         main = paste0("RCB values of ", input$myPicker1),
         xlab = "RCB value", ylab = "# of cases", col = "darkgray",
         xlim =c(0,xaxis), ylim = c(0,yaxis))
    # RCB control
    hist(as.numeric(rcb_contr), 
         main = paste0("RCB values of CONTROL"), 
         xlab = "RCB value", ylab = "# of cases", col = "deepskyblue3",
         xlim =c(0,xaxis), ylim = c(0,yaxis))
    
    } # End if / else
  }
  ) # End Reactive Global data
  
}

