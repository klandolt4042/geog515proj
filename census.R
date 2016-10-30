#load packages
library(acs)
library(tigris)
library(stringr)
library(rgdal)

#read api.key.install
read.lines

#Texas is 48
#Harris County is 201

tx <- counties("Texas", cb=TRUE)
harris <- tx[tx$COUNTYFP == 201,]

geo <- geo.make(state=c("TX"), county= 201, tract = "*")
bg <- geo.make(state="TX", county= 201, tract = "*", block.group = "*")
bg1 <- block_groups(state="TX", county=201)


bg <- block_groups(state="TX", county=201)

counties <- 201
# tracts <- tracts(state="TX", county=201)
# blocks <- blocks(state="TX", county=201)

income <- acs.fetch(endyear = 2014, span = 5, geography = bg, table.number = "B19001", col.names="pretty")

income_df <- data.frame(state=income@geography$state,
                        county=income@geography$county, 
                        tract=income@geography$tract,
                        bg=income@geography$blockgroup,
                        income@estimate[,c(1:17)], 
                        stringsAsFactors = FALSE)




income_df1 <- data.frame(paste0(str_pad(income@geography$state,2,"left",pad="")))
