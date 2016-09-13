#add packages
library(acs)
library(tigris)
library(stringr)

***REMOVED***

#Texas is 48
#Harris County is 201

geo <- geo.make(state=c("TX"), county= 201, tract = "*")

counties <- 201
tracts <- tracts(state="TX", county=201)
income <- acs.fetch(endyear = 2014, span = 5, geography = geo, table.number = "B19001", col.names="pretty")
