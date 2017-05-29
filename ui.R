#library(shiny)

shinyUI(pageWithSidebar(
#    headerPanel("BROKEN: IN DEVELOPMENT"),
    headerPanel("Genes with fuzzpro matches"),
    
    sidebarPanel(
#        selectInput("dset", label = h3("Dataset To Show"),
#                    choices  = "Human_Chicken_Zebrafish",
#                    selected = "Human_Chicken_Zebrafish"
#                    ),
        wellPanel(h3("Disordered Regions"),
                  uiOutput("Hdis"),
                  uiOutput("Gdis"),
                  uiOutput("Ddis")
                  ),
        wellPanel(h3("Patterns per region"),
                  uiOutput("UI1a"),
                  uiOutput("UI1b"),
                  uiOutput("UI2a"),
                  uiOutput("UI2b"),
                  uiOutput("UI3a"),
                  uiOutput("UI3b")
                  ),
        wellPanel(#h3("Mitotis RNAseq from Reactome"),
        h3(a(href="http://www.reactome.org/PathwayBrowser/#/R-HSA-69278&PATH=R-HSA-1640170&DTAB=EX", "Reactome mitosis genes")),
                  uiOutput("UImito"),
                  uiOutput("UImitoVal")                  
                  ),                 
        selectInput("GOterm", label = h3("Filter on a GO term"),
                    choices = c("Any" ="Any",
                        "Mitotic Nuclear Division [GO:0007067]"="mito",
                        "Centrosome [GO:0005813]"  = "centrosome",
                        "Microtubule [GO:0005874]" = "microtubule",
                        "mitotic cell cycle [GO:0000278]" = "cyc",
                        "M phase of mitotic cell cycle [GO:0000087]" = "Mphase",
                        "Regulation of mitotic cell cycle [GO:0007346]" = "RegCell",
                        "Regulation of mitosis [GO:0007088]" = "RegMito",
                        "Regulation of mitotic prometaphase [GO:0035415]" = "RegPro",
                    "Regulation of mitotic metaphase/anaphase transition [GO:0030071]" = "RegMAna",
                        "Regulation of mitotic anaphase [GO:0090007]" = "RegAna",
                        "Positive regulation of mitosis [GO:0045840]" = "PRegMito", 
                        "Negative regulation of mitosis [GO:004539]"  = "NRegMito"
                                )
                    ),
#        sliderInput("Sites", "Min number of sites per protein",
#                    min=3, max=30, value=3                   
#                    ),
        checkboxInput("Near", h3("Only include if 3 patterns are each 10aa apart"), FALSE),

#        checkboxInput("Clus", h3("Filter on the clusters"), FALSE),
#        uiOutput("UIclust"),
                                        #        checkboxGroupInput("Group", label = h3("Select a cluster: prefiltered by max 10aa between 3 patterns"),
 #                          choices=levels(tab$Cluster),
 #                          selected=1
 #                          ),
        wellPanel(p(strong("Download Table")),
                  downloadButton('downloadData', 'Download')
                  )
    ),
    mainPanel(
        dataTableOutput("mytable1")
    )   

))


