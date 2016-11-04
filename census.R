#look at Home Value and Structure
#Year Built

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
bg2 <- spTransform(bg1, crs(naip))
bg2$merge <- paste(bg2$TRACTCE, bg2$BLKGRPCE, sep=".")




#Value for Owner-Occupied Housing Units: Table Number "#B25075"
#acs.lookup(endyear = 2014, span = 5, dataset = "acs",table.name = c("Structure", "Value"))
value <- acs.fetch(endyear=2012, span=5, geography = bg, table.number = "B25075", col.names = "pretty")


#Year Structure was built: Table Number "B25034"
age <- acs.fetch(endyear=2012, span=5, geography = bg, table.number = "B25034", col.names = "pretty")

#Household Income: Table Number "B19001"
income <- acs.fetch(endyear = 2014, span = 5, geography = bg, table.number = "B19001", col.names="pretty")

income_df <- data.frame(state = income@geography$state,
                        county = income@geography$county, 
                        tract = income@geography$tract,
                        bg = income@geography$blockgroup,
                        t_income_house = income@estimate[,1],
                        income10 = income@estimate[,2],
                        income10_15 = income@estimate[,3],
                        income15_20 = income@estimate[,4],
                        income20_25 = income@estimate[,5],
                        income25_30 = income@estimate[,6],
                        income30_35 = income@estimate[,7],
                        income35_40 = income@estimate[,8],
                        income40_45 = income@estimate[,9],
                        income45_50 = income@estimate[,10],
                        income50_60 = income@estimate[,11],
                        income60_75 = income@estimate[,12],
                        income75_99 = income@estimate[,13],
                        income100_125 = income@estimate[,14],
                        income125_150 = income@estimate[,15],
                        income150_200 = income@estimate[,16],
                        greater200 = income@estimate[,17],
                        stringsAsFactors = FALSE)

income_df$merge <- paste(as.character(income_df$tract), as.character(income_df$bg), sep = ".")

join <- geo_join(bg2, income_df, "merge", "merge")


value_df <- data.frame(state = value@geography$state,
                        county = value@geography$county, 
                        tract = value@geography$tract,
                        bg = value@geography$blockgroup,
                        t_value_house = value@estimate[,1],
                        value10 = value@estimate[,2],
                        value10_15 = value@estimate[,3],
                        value15_20 = value@estimate[,4],
                        value20_25 = value@estimate[,5],
                        value25_30 = value@estimate[,6],
                        value30_35 = value@estimate[,7],
                        value35_40 = value@estimate[,8],
                        value40_50 = value@estimate[,9],
                        value50_60 = value@estimate[,10],
                        value60_70 = value@estimate[,11],
                        value70_80 = value@estimate[,12],
                        value80_90 = value@estimate[,13],
                        value90_100 = value@estimate[,14],
                        value100_125 = value@estimate[,15],
                        value125_150 = value@estimate[,16],
                        value150_175 = value@estimate[,17],
                        value175_200 = value@estimate[,18],
                        value200_250 = value@estimate[,19],
                        value250_300 = value@estimate[,20],
                        value300_400 = value@estimate[,21],
                        value400_500 = value@estimate[,22],
                        value500_750 = value@estimate[,23],
                        value750_1000 = value@estimate[,24],
                        value1000 = value@estimate[,25],
                         stringsAsFactors = FALSE)

value_df$merge <- paste(as.character(value_df$tract), as.character(value_df$bg), sep = ".")



join <- geo_join(join, value_df, "merge", "merge")

age_df <- data.frame(state = age@geography$state,
                       county = age@geography$county, 
                       tract = age@geography$tract,
                       bg = age@geography$blockgroup,
                       t_year_house = age@estimate[,1],
                       year2010 = age@estimate[,2],
                       year2000_2009 = age@estimate[,3],
                       year1990_1999 = age@estimate[,4],
                       year1980_1989 = age@estimate[,5],
                       year1970_1979 = age@estimate[,6],
                       year1960_1969 = age@estimate[,7],
                       year1950_1959 = age@estimate[,8],
                       year1940_1950 = age@estimate[,9],
                       year1940 = age@estimate[,10],
                       stringsAsFactors = FALSE)

age_df$merge <- paste(as.character(age_df$tract), as.character(age_df$bg), sep = ".")


join <- geo_join(join, age_df, "merge", "merge")
int.join <- raster::intersect(join, naip)

int.join$canopy.area <- NA

for (i in 1:length(int.join)){
  sub <- crop(naip, int.join[i,])
  sub <- mask(sub, int.join[i,])
  int.join$rel.c.area[i] <- length(sub[sub@data@values == 0] )/length(sub)
  int.join$
}



# for (i in 1:length(join)){
#   if(inherits(tryCatch(crop(naip,join[i,]), error=function(e) e), "error") == TRUE)
#     
#     
# }

