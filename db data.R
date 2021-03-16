library(DBI)
conn <- dbConnect(
  drv = RMySQL::MySQL(),
  dbname = "shinydemo",
  host = "shiny-demo.csa7qlmguqrf.us-east-1.rds.amazonaws.com",
  username = "guest",
  password = "guest")
rs <- dbSendQuery(conn, "SELECT * FROM City LIMIT 5;")
dbFetch(rs)
rp<-dbSendQuery(conn, "SELECT * FROM Country ;")
dbFetch(rp)
dbClearResult(rs,rp)
dbDisconnect(conn)
rs
head(rs,6)
rs<-as.data.frame(rs)

conn<-dbConnect(
  drv = RMySQL::MySQL(),
  dbname = "shinydemo",
  host = "shiny-demo.csa7qlmguqrf.us-east-1.rds.amazonaws.com",
  username = "guest",
  password = "guest")
  data2 = dbGetQuery(conn,"SELECT*From Country LIMIT 50;")
  dbDisconnect(conn)
  data2<-as.data.frame(data2)
  tail(data2)

  
  
  
library(DBI)
conn <- dbConnect(
  drv = RMySQL::MySQL(),
  dbname = "shinydemo",
  host = "shiny-demo.csa7qlmguqrf.us-east-1.rds.amazonaws.com",
  username = "guest",
  password = "guest")
data<-dbGetQuery(conn, "SELECT * FROM City LIMIT 50;")
dbDisconnect(conn)
data<-as.data.frame(data)
head(data,6)


data%>%
  group_by(District)%>%
  head()

data%>%
  group_by(District)%>%
  count(Population)%>%
  arrange(desc(Population))%>%
  top_n(10)%>%
  ggplot(data ,mapping =  aes(y = Population,x = District))+
  geom_col()+
  coord_flip()
  data$Name

ggplot(data ,mapping =  aes(y = Population,x = Name))+
  geom_col()+
  coord_flip()



data$District<-as.factor(data$District)
table(data$District)


str(data)

?count









library(shiny)
library(DBI)

ui <- fluidPage(
  numericInput("nrows", "Enter the number of rows to display:", 5),
  tableOutput("tbl")
)

server <- function(input, output, session) {
  output$tbl <- renderTable({
    conn <- dbConnect(
      drv = RMySQL::MySQL(),
      dbname = "shinydemo",
      host = "shiny-demo.csa7qlmguqrf.us-east-1.rds.amazonaws.com",
      username = "guest",
      password = "guest")
    on.exit(dbDisconnect(conn), add = TRUE)
    dbGetQuery(conn, paste0(
      "SELECT * FROM City LIMIT ", input$nrows, ";"))
  })
}

shinyApp(ui, server)
