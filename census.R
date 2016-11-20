#look at Home Value and Structure
#Year Built
#Quasi-binominal logistic regression


#load packages
library(acs)
library(tigris)
library(stringr)
library(rgdal)
library(rgeos)
library(SDMTools)
library(parallel)
library(foreach)
library(broom)

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


e <- extent(naip)
foot <- as(e, "SpatialPolygons")
crs(foot) <- crs(naip)

id.contain <- as.data.frame(gContains(foot,join, byid=TRUE))


join$contain <- id.contain$`1`
join <- join[!(join$contain==FALSE),]

drops <- c("STATEFP", "COUNTYFP", "GEOID", "NAMELSAD", "MTFCC", "FUNCSTAT", "ALAND", "AWATER", "INTPTLAT", "INTPTLON", "merge",
           "state", "county", "state.1", "county.1", "tract.1", "bg.1", "merge.1", "merge.2", "state.2", "county.2", "tract.2", "bg.2", 
           "merge.3", "state.3", "county.3", "tract.3", "bg.3", "merge.4", "contain")
join <- join[ , !(names(join) %in% drops)]

# writeOGR(join, "E:/Dropbox/Fall2016/GEOG515/data/", "join", driver="ESRI Shapefile")
# sub.join <- readOGR("E:/Dropbox/Fall2016/GEOG515/data", "join_sub")
# sub.join <- readOGR("/Users/lando/Dropbox/Fall2016/GEOG515/data/", "join_sub")

join$can_prop <- NA


join.df <- join@data
#age.sum = 355456
age.sum <- colSums(join@data[,48:56])
#five groups = 71091.2
#six groups = 88864
#2000-present
join@data$y2000_present <- rowSums(join@data[,48:49])
#1980-2000
join@data$y1980_2000 <- rowSums(join@data[,50:51])
#1970-1980
join@data$y1970_1980 <- join@data[,52]
#1960-1970
join@data$y1960_1970 <- join@data[,53]
#1950-1960
join@data$y1950_1960 <- join@data[,54]
#before-1950
join@data$yPrevious_1950 <- rowSums(join@data[,55:56])



#inc.sum = 309583
inc.sum <- colSums(join@data[,6:21])
#five groups = 61916.6
#less-20
join@data$incLess_20 <- rowSums(join@data[,6:8])
#20-40
join@data$inc20_40 <- rowSums(join@data[,9:12])
#40-75
join@data$inc40_75 <- rowSums(join@data[,13:16])
#75-125
join@data$inc75_125 <- rowSums(join@data[,17:18])
#125-greater
join@data$inc125_greater <- rowSums(join@data[,19:21])

#val.sum = 138917
val.sum <- colSums(join@data[,23:46])
#five groups = 27783.4
#six groups = 23152.83
#less - 70
join@data$valLess_70 <- rowSums(join@data[,23:32])
#70 - 100
join@data$val70_100  <- rowSums(join@data[,33:35])
#100 - 175
join@data$val100_175 <- rowSums(join@data[,36:38])
#175 - 300
join@data$val175_300 <- rowSums(join@data[,39:41])
#300 - 500
join@data$val300_500 <- rowSums(join@data[,42:43])
#500 - greater
join@data$val500_greater <- rowSums(join@data[,44:46])


keeps <- c("TRACTCE", "BLKGRPCE", "tract", "bg", "t_income_house", "t_value_house", "t_year_house", "t.occu", "o.occu", "r.occu",
           "can_prop", "y2000_present", "y1980_2000", "y1970_1980", "y1960_1970", "y1950_1960", "yPrevious_1950",
           "incLess_20", "inc20_40", "inc40_75", "inc75_125", "inc125_greater", "valLess_70", "val70_100", "val100_175",
           "val175_300", "val300_500", "val500_greater")
join <- join[keeps]

# join.df <- as.data.frame(join)


for (i in 1:length(join)){
  clip <- join[i,]
  clip1 <- crop(naip, clip)
  clip2 <- rasterize(clip, clip1, mask=TRUE)
  clip2[clip2 > 0] <- 2
  clip2[clip2 == 0] <- 1
  clip2[clip2 == 2] <- 0
  prop <- ClassStat(as.matrix(clip2),bkgd=0)
  join.df$can_prop[i] <- prop$prop.landscape
  cat(i )
}

# Write join to shapefile
write.table(join, file = "/Users/lando/Dropbox/Fall2016/GEOG515/data/join.txt", sep=",")
writeOGR(join, dsn = "/Users/lando/Dropbox/Fall2016/GEOG515/data/", "final1", driver = "ESRI Shapefile", overwrite_layer = TRUE)
# writeOGR(join, dsn = "E:/Dropbox/Fall2016/GEOG515/data/", "final", driver = "ESRI Shapefile")
# final <- readOGR(dsn = "/Users/lando/Dropbox/Fall2016/GEOG515/data/", layer = "final")

final.join <- (join)
final.join <- final.join[final.join@data$t_income_house!=0,]
final.join <- final.join[final.join@data$t_value_house!=0,]
final.join <- final.join[final.join@data$t_year_house!=0,]
final.join <- final.join[final.join@data$t.occu!=0,]

final.join@data$income.frac <- final.join@data[,18:22]/final.join@data[,5]
final.join@data$value.frac <- final.join@data[,23:28]/final.join@data[,6]
final.join@data$age.frac <- final.join@data[,12:17]/final.join@data[,7]
final.join@data$owner.frac <- final.join@data[,9:10]/final.join@data[,8]

smp_size <- floor(0.80 * nrow(final.join))

set.seed(123)
train_ind <- sample(seq_len(nrow(final.join)), size= smp_size)
train_set <- final.join[train_ind,]
test_set <- final.join[-train_ind,]

write.table(final.join, file = "/Users/lando/Dropbox/Fall2016/GEOG515/data/join.txt", sep=",")
writeOGR(final.join, dsn = "/Users/lando/Dropbox/Fall2016/GEOG515/data/", "final1", driver = "ESRI Shapefile", overwrite_layer = TRUE)


keeps <- c("can_prop", "income.frac", "value.frac", "age.frac", "owner.frac")

train_set <- train_set[keeps]
train_set@data <- cbind(train_set@data, train_set@data$income.frac, train_set@data$value.frac, train_set@data$age.frac, train_set@data$owner.frac)
train_set@data$income.frac <- NULL
train_set@data$value.frac <- NULL
train_set@data$age.frac <- NULL
train_set@data$owner.frac <- NULL

test_set@data <- test_set@data[keeps]
test_set@data <- cbind(test_set@data, test_set@data$income.frac, test_set@data$value.frac, test_set@data$age.frac, test_set@data$owner.frac)
test_set@data$income.frac <- NULL
test_set@data$value.frac <- NULL
test_set@data$age.frac <- NULL
test_set@data$owner.frac <- NULL
names(test_set)[names(test_set) == "can_prop"] <- "true_can_prop"


# sub <- cbind(income.frac, value.frac, age.frac, owner.frac)
# sub$canopy <- final.df$can_prop



# Model with all covariates excluding 1 from each category
# model.tot <- glm(can_prop~. -income.frac$inc125_greater -value.frac$val500_greater -age.frac$y2000_present -owner.frac$o.occu, data=train_set@data, family = quasibinomial(link = "logit"))
model.tot <- glm(can_prop~. -inc125_greater -val500_greater -y2000_present -o.occu, data=train_set@data, family = quasibinomial(link = "logit"))

test_set$pred_can_prop <- predict(model.tot, test_set@data, type="response")
test_set$error <- test_set$true_can_prop - test_set$pred_can_prop

#Plotting shapefile
train_set@data$id = rownames(train_set@data)
train_set.fort = tidy(train_set, region = "id")
train_set.df = join(train_set.fort, train_set@data, by="id")

ggplot(train_set.df) + aes(long, lat, group=group, fill=can_prop) + geom_polygon() + coord_equal()


test_set@data$id = rownames(test_set@data)
test_set.fort = tidy(test_set, region = "id")
test_set.df = join(test_set.fort, test_set@data, by="id")
ggplot(test_set.df) + aes(long, lat, group=group, fill=error) + geom_polygon() + coord_equal()




# Only Single type of category models
model.year <- glm(canopy~. -y2000_present, data=sub[, -c(1:11, 18:19)], family = quasibinomial(link = "logit"))
model.value <- glm(canopy~. -val500_greater, data=sub[, -c(1:5, 12:19)], family = quasibinomial(link = "logit"))
model.owner <- glm(canopy~. -o.occu, data=sub[, -c(1:17)], family = quasibinomial(link = "logit"))
model.inc <- glm(canopy~. -inc125_greater, data=sub[, -c(6:19)], family = quasibinomial(link = "logit"))

# Subracting single type of variable models
model.sub.year <- glm(canopy~. -inc125_greater -val500_greater -o.occu, data=sub[, -c(12:16)], family = quasibinomial(link = "logit"))
model.sub.value <- glm(canopy~. -inc125_greater -y2000_present -o.occu, data=sub[, -c(6:11)], family = quasibinomial(link = "logit"))
model.sub.owner <- glm(canopy~. -inc125_greater -val500_greater -y2000_present, data=sub[, -c(18:19)], family = quasibinomial(link = "logit"))
model.sub.inc <- glm(canopy~. -val500_greater -y2000_present -o.occu, data=sub[, -c(1:5)], family = quasibinomial(link = "logit"))


anova(model.1, model.11, test='Chisq')
anova(model.1, model.12, test='Chisq')
anova(model.1, model.13, test='Chisq')


