#add packages
library(acs)
library(tigris)
library(stringr)

api.key.install(key="3b3345346b50d9a6c9d6d99818c94e7e76ee60cf")

#Texas is 48
#Harris County is 201

geo <- geo.make(state=c("TX"), county= 201, tract = "*")

counties <- 201
tracts <- tracts(state="TX", county=201)
income <- acs.fetch(endyear = 2014, span = 5, geography = geo, table.number = "B19001", col.names="pretty")
