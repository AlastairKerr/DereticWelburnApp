library(dplyr)
library(magrittr)


mito <- read.table('mitosis.tsv', header=TRUE, sep="\t")

tab <-read.table('region-table.tsv', sep="\t", fill=T, header=T)
tab$Cluster = as.factor(tab$Cluster)

shinyServer(function(input, output){

    output$Hdis <- renderUI({
        sliderInput("h_pcdis",
                    h3("Human:Min percentage of disorder in region"),
                    min = 1, max = 100, value= 0
                    )           
    })
    
    output$Gdis <- renderUI({
        sliderInput("g_pcdis",
                    h3("Chicken:Min percentage of disorder in region"),
                    min = 1, max = 100, value= 0
                    )           
    })
    
    output$Ddis <- renderUI({
        sliderInput("d_pcdis",
                    h3("Zebrafish:Min percentage of disorder in region"),
                    min = 1, max = 100, value= 0
                    )           
    })
    
    output$UI1a <- renderUI({
        selectInput("h_length",
                    label = h3("Human:Length of region to examine"),
                    choices  = c(FALSE, 20,50,100,300),
                    selected = 300
                    )
    })
    output$UI1b <- renderUI({
        sliderInput("h_min",
                    h3("Human:Min number of patterns"),
                    min = 1, max = 10, value= 1
                    )
    })
    output$UI2a <- renderUI({
        selectInput("g_length",
                    label = h3("Chicken:Length of region to examine"),
                   choices  = c(FALSE, 20,50,100,300),
                    selected = 300
                    )        
    })
    output$UI2b <- renderUI({
        sliderInput("g_min",
                    h3("Chicken:Min number of patterns"),
                    min = 1, max = 10, value= 3
                    )
    })
    output$UI3a <- renderUI({
        selectInput("d_length",
                    label = h3("Zebrafish:Length of region to examine"),
                    choices  = c(FALSE,20,50,100,300),
                    selected = 300
                    )       
    })
    output$UI3b <- renderUI({
        sliderInput("d_min",
                    h3("Zebrafish:Min number of patterns"),
                    min = 1, max = 10, value= 3
                    )
    })
    
    output$UImito <- renderUI({        
        selectInput("mito",
                    h3("Select All, or a tissue and min value"),
                        c("No", "All",
                          names(mito)[!grepl("Gene", names(mito))]
                          ),
                    selected = "No"
                    )
    })
    output$UIclust <- renderUI({
        if(input$Clus){
            checkboxGroupInput("Group",
                               label =
                                   h3("Select a cluster: prefiltered by max 10aa between 3 patterns"),
                               choices=levels(tab$Cluster),
                               selected=1
                               )
        }else{
            return()
        }
    })
    
    output$UImitoVal <- renderUI({
        if(input$mito == "No" | input$mito == "All"){
            return()
        }else{
            sliderInput("mitoVal",
                        h3("Min value"),
                        min = 1, max = 10, value= 1
                        )
        }
    })
    
    

  
    count_h<- reactive({
        cch <-   subset(ch,
                        ch$V2 == input$h_length &
                        ch$V3 >= input$h_min)
#        cch$V1
        cch[,c(1,3)];
    })

    count_g<- reactive({
        ccg <- subset(cg,
                      cg$V2 == input$g_length &
                      cg$V3 >= input$g_min)
                                        #        ccg <- cg %>%
#            subset(cg$V2 == input$g_length) %>%
#            subset(cg$V3 >= input$g_min)
#        ccg$V1
        ccg[,c(1,3)];
    })

    count_d<- reactive({
        ccd <- subset(cd,
                      cd$V2 == input$d_length & 
                      cd$V3 >= input$d_min)

                                        #        ccd <- cd %>%
#            subset(cd$V2 == input$d_length) %>%
#            subset(cd$V3 >= input$d_min)
        #ccd$V1
        ccd[,c(1,3)];
    })

    
    filter_table  <- reactive({
        ft <- tab

        ft <- subset(ft,  H_pc_Disorder >= input$h_pcdis) 
        ft <- subset(ft,  G_pc_Disorder >= input$g_pcdis) 
        ft <- subset(ft,  D_pc_Disorder >= input$d_pcdis) 
        
        if(input$mito != "No"){
            if(input$mito == "All"){
                ft <- merge(ft, mito, by.x ="GID",  by.y="Gene.ID")##
            }else{
                mmito <- subset(mito, mito[[input$mito]] > input$mitoVal)
                ft <- merge(ft, mmito, by.x ="GID",  by.y="Gene.ID")                
            }
                            
        }
        if(input$d_length > 0){
            dc <- count_d()
            names(dc) <- c("PID3","Dr.count")
            ft <- merge(dc, ft, by.x ="PID3",  by.y="PID3")
            #ft <- subset(ft, ft$PID3 %in% count_d())
        }

        if(input$g_length > 0 ){
            gc <- count_g()
            names(gc) <- c("PID2","Gg.count")
            ft <- merge(gc, ft, by.x ="PID2",  by.y="PID2")            
#            ft <- subset(ft, ft$PID2 %in% count_g())
        }
        
        if(input$h_length > 0){
            hc <- count_h()
            names(hc) <- c("PID1","Hs.count") 
            ft <- merge(hc, ft, by.x ="PID1",  by.y="PID1") 
                                        #            ft <- subset(ft, ft$PID1 %in% count_h())
        }

        if(input$Near){ ft <- subset(ft, ft$Cluster != "NA")}    

        if(input$Clus){
            ft <- subset(ft, ft$Cluster != "NA")
            ft <- ft[ft$Cluster == input$Group,]
        }

        
        if(input$GOterm == "mito"){            
           ft <- subset(ft, grepl("GO:0007067", ft$GOterms))
        }
        
        if(input$GOterm == "centrosome"){  ft <- subset(ft, grepl("GO:0005813", ft$GOterms)) }
        if(input$GOterm == "microtubule"){ ft <- subset(ft, grepl("GO:0005874", ft$GOterms)) }
        if(input$GOterm == "cyc")        { ft <- subset(ft, grepl("GO:0000278", ft$GOterms)) }
        if(input$GOterm == "Mphase"){      ft <- subset(ft, grepl("GO:0000087", ft$GOterms)) }
        if(input$GOterm == "RegCell"){     ft <- subset(ft, grepl("GO:0007346", ft$GOterms)) }
        if(input$GOterm == "RegMito"){     ft <- subset(ft, grepl("GO:0007088", ft$GOterms)) }
        if(input$GOterm == "RegMAna"){     ft <- subset(ft, grepl("GO:0035415", ft$GOterms)) }
        if(input$GOterm == "RegAna"){      ft <- subset(ft, grepl("GO:0090007", ft$GOterms)) }
        if(input$GOterm == "PRegMito"){    ft <- subset(ft, grepl("GO:0045840", ft$GOterms)) }
        if(input$GOterm == "NRegMito"){    ft <- subset(ft, grepl("GO:0045839", ft$GOterms)) }



        
#        ft<- subset(ft, input$Sites <= ft$Matches1)
#        ft<- subset(ft, input$Sites <= ft$Matches2)
#        ft<- subset(ft, input$Sites <= ft$Matches3)
        ft
    })
    
    
       
    output$mytable1 = renderDataTable({        
        ft<-filter_table()
        ft
    },
        options = list(bSortClasses = TRUE, aLengthMenu = c(5,20,100,200),iDisplayLength = 20)
                                      )
    
                                        # Download
    output$downloadData <- downloadHandler(
        filename = function() {'data.csv' },
        content = function(file) {
            write.csv(filter_table(), file, row.names=F,sep="\t")
        }
    )

}) 



