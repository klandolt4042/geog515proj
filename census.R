#look at Home Value and Structure
#Year Built
#Quasi-binominal logistic regression


#load packages
library(acs)
library(tigris)
library(stringr)
library(rgdal)
library(SDMTools)
library(parallel)

#read api.key.install
# read.lines

#Texas is 48 and Harris County is 201

#make texas and harris county spatial polygon data frame
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

#Ownership Type: Table Number "B25003"
owner <- acs.fetch(endyear=2014, span = 5, geography = bg, table.number = "B25003", col.names = "pretty")

# Make income data frame
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

# Make income data frame column to merge
income_df$merge <- paste(as.character(income_df$tract), as.character(income_df$bg), sep = ".")

# Make join data frame merging income with block group
join <- geo_join(bg2, income_df, "merge", "merge")

#Make household value data frame
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

# Make merge column
value_df$merge <- paste(as.character(value_df$tract), as.character(value_df$bg), sep = ".")

# Join value dataframe with previous join
join <- geo_join(join, value_df, "merge", "merge")

# Make household age data frame
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

# Make merge column
age_df$merge <- paste(as.character(age_df$tract), as.character(age_df$bg), sep = ".")

# Join household age data frame to previous merge
join <- geo_join(join, age_df, "merge", "merge")

# Make ownership dataframe
owner_df <- data.frame(state = owner@geography$state,
                     county = owner@geography$county, 
                     tract = owner@geography$tract,
                     bg = owner@geography$blockgroup,
                     t.occu = owner@estimate[,1],
                     o.occu = owner@estimate[,2],
                     r.occu = owner@estimate[,3],
                     stringsAsFactors = FALSE)

# Make merge column
owner_df$merge <- paste(as.character(owner_df$tract), as.character(owner_df$bg), sep = ".")

# Make join column
join <- geo_join(join, owner_df, "merge", "merge")



writeOGR(join, "E:/Dropbox/Fall2016/GEOG515/data/", "join", driver="ESRI Shapefile")
sub.join <- readOGR("E:/Dropbox/Fall2016/GEOG515/data", "join_sub")

sub.join$can_prop <- NA
# int.join <- raster::intersect(join, naip)

# canopy.metrics <- list()

# per.cov <- function(img,region){
#   sub <- crop(img, region)
#   sub <- mask(sub, region)
#   sub[sub > 0] <- 2
#   sub[sub == 0] <- 1
#   sub[sub == 2] <- 0
#   return(ClassStat(as.matrix(sub),bkgd=0))
# }

for (i in 1:length(sub.join)){
  clip <- sub.join[i,]
  sub <- crop(naip, clip)
  sub <- mask(sub, clip)
  sub[sub > 0] <- 2
  sub[sub == 0] <- 1
  sub[sub == 2] <- 0
  prop <- ClassStat(as.matrix(sub),bkgd=0)
  sub.join$can_prop[i] <- prop$prop.landscape
  cat(i)
}

writeOGR(sub.join, dsn = "E:/Dropbox/Fall2016/GEOG515/data/", "final", driver = "ESRI Shapefile")
final <- readOGR(dsn = "/Users/lando/Dropbox/Fall2016/GEOG515/data/", layer = "final")

final.df <- as.data.frame(final)

income.frac <- final.df[,19:34]/final.df[,18]
value.frac <- final.df[,41:64]/final.df[,40]
age.frac <- final.df[,71:79]/final.df[,70]

sub <- cbind(income.frac, value.frac, age.frac)
sub$canopy <- final.df$can_prop

sub <- sub[complete.cases(sub),]

#model with just age covariates
model.age <- glm(canopy~sub$yer2010+sub$y2000_2+sub$y1990_1+sub$y1980_1+sub$y1970_1+sub$y1960_1+sub$y1950_1+sub$y1940_1+sub$yer1940, data=sub, family=quasibinomial(link = "logit"))

# Model with all covariates exclusing 1 from each category
model.1 <- glm(canopy~.-grtr200 -val1000 -yer1940, data=sub, family = quasibinomial(link = "logit"))
model.11 <- glm(canopy~.-grtr200 -val1000 -yer1940, data=sub[, -c(1:15)], family = quasibinomial(link = "logit"))
model.12 <- glm(canopy~.-grtr200 -val1000 -yer1940, data=sub[, -c(17:39)], family = quasibinomial(link = "logit"))
model.13 <- glm(canopy~.-grtr200 -val1000 -yer1940, data=sub[, -c(41:48)], family = quasibinomial(link = "logit"))
anova(model.1, model.11, test='Chisq')
anova(model.1, model.12, test='Chisq')
anova(model.1, model.13, test='Chisq')

model.2 <- glm(canopy~.-grtr200 -val1000 -yer1940, data=sub, family = quasibinomial)
