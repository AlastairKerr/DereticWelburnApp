
library(shiny)

shinyUI(pageWithSidebar(
    headerPanel("Proteins with fuzzpro matches"),
    
    sidebarPanel(
        wellPanel(h2("iuphred disordered Regions"),
                  checkboxInput("disReg", h3("Filter on %disorder"), FALSE),    
                  conditionalPanel(
                      condition = "input.disReg",
                      uiOutput("Hdis"),
                      uiOutput("Gdis"),
                      uiOutput("Ddis")
                  )
                  ),
        wellPanel(h2("Patterns per region"),
                  checkboxInput("patReg", h3("Show / hide filters"), FALSE),
                  conditionalPanel(
                      condition = "input.patReg",                      
                      uiOutput("UI1a"),
                      uiOutput("UI1b"),
                      uiOutput("UI2a"),
                      uiOutput("UI2b"),
                      uiOutput("UI3a"),
                      uiOutput("UI3b")
                     ) 
                  ),
        
        wellPanel(#h3("Mitotis RNAseq from Reactome"),
            checkboxInput("showGO", h3("Omit GO terms from the table?"), TRUE),
            h2(a(href="http://www.reactome.org/PathwayBrowser/#/R-HSA-69278&PATH=R-HSA-1640170&DTAB=EX", "Reactome mitosis genes")),
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
                        "Negative regulation of mitosis [GO:004539]"  = "NRegMito",
                        "Condensed chromosome kinetochore [GO:0000777]" ="cckin",
                        "Spindle Pole [GO:0000922]" =  "SpindlePole",
                        "Spindle [GO:0005819]" = "Spindle",                        
                        "Mitotic Spindle [GO:0072686]" = "MitoticSpindle",
                        "Mitotic spindle assembly [GO:0090307]" = "MSA",
                        "Mitotic spindle organization [GO:0007052]" = "MSO",
                        "Kinetochore microtubule [GO:0005828]" = "KinetochoreMicrotubule",
                        "Kinetochore [GO:0000776]" = "Kinetochore",
                        "kinetochore binding [GO:0043515]" = "KinetochoreBinding",
                        "Regulation of attachment of mitotic spindle microtubules to kinetochore [GO:1902423]"  = "RegAMS2K",
                        "Metaphase plate congression [GO:0051310]" = "MetaPlateCong",
                        "Centriole [GO:0005814]" = "Centriole",
                        "Cell division [GO:0051301]" = "CellDivision",
                        "Cytokinesis [GO:0000910]"= "Cytokinesis",
                        "Cilum [GO:0005929]" = "Cilum",
                        "Midbody [GO:0030496]" = "Midbody",
                        "Spindle midzone [GO:0051233]" = "SpindleMidzone"                        
                                )
                    ),


        
        
        wellPanel(h2("Percent Similarity to an Ortholog"), 
            checkboxInput("ident", h3("Filter on the %similarity to orthlog"), FALSE),    
    conditionalPanel(
        condition = "input.ident",
        sliderInput("GgId", "Min %identity to Chicken",
                    min=30, max=100, value=30),
        sliderInput("DrId", "Min %identity to ZebraFish",
                    min=30, max=100, value=30)
    )),        

        wellPanel(p(strong("Download Table")),
                  downloadButton('downloadData', 'Download')
                  )
    ),
    mainPanel(
        tabsetPanel(
            tabPanel(h1("Table"), dataTableOutput("mytable1")),
            tabPanel(h1("Documentation"), tableOutput("docs")),
            tabPanel(h1("Methods"),includeMarkdown("Methods.md") )
        )
    )   

))


