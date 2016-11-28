#plots for the paper
library(ggplot2)
library(tigris)
library(acs)
library(ggmap)
library(broom)
library(gridExtra)
library(grid)

#STUDY AREA MAP
harris <- counties(state=c("TX"))
harris <- harris[harris$NAME == "Harris",]
foot_tmp <- spTransform(foot, crs(harris))

harris.df = fortify(harris)
foot.df = fortify(foot_tmp)


ggmap(get_map(location=bbox(harris), source = "stamen", maptype = "toner-hybrid", crop=TRUE)) + 
  geom_polygon(data = harris.df, aes(x = long, y = lat), linetype="solid", fill=NA, colour="coral3", size=1, alpha = 0.2) + 
  geom_polygon(data = foot.df, aes(x = long, y = lat),colour="deepskyblue2", linetype = "dashed", fill=NA, size=1) +
  labs(x="Longitude", y = "Latitude") + 
  ggtitle("Harris County") +
  theme(plot.title = element_text(size=19))



# final.join@data$id = rownames(final.join@data)
# train_set.fort = tidy(train_set, region = "id")
# train_set.df = join(train_set.fort, train_set@data, by="id") 
join.train <- train_set
join.test <- test_set
join.train$type <- "Train"
join.test$type <- "Test"
names(join.test)[names(join.test) == "true_can_prop"] <- "can_prop"
join.test$error <- NULL
join.test$pred_can_prop <- NULL
joined <- rbind(join.test,join.train)

joined@data$id = rownames(joined@data)
joined.fort = tidy(joined, region="id")
joined.df = join(joined.fort, joined@data, by="id")

ggplot(joined.df) + aes(long, lat, group=group, fill=joined.df$type) +
  geom_polygon() +
  geom_path(color="black") +
  coord_equal() +
  ggtitle("Block groups by \ntraining and testing") +
  scale_fill_manual(values=c(Train ="springgreen2",Test = "indianred2"), name="Type") +
  theme_bw() +
  labs(x="Longitude", y = "Latitude") 

naip.df <- as.data.frame(naip, xy=TRUE)
write.table(naip.df, file = "/Users/lando/Dropbox/Fall2016/GEOG515/data/naip.txt", sep=",")


train_set@data$id = rownames(train_set@data)
train_set.fort = tidy(train_set, region = "id")
train_set.df = join(train_set.fort, train_set@data, by="id")

p1 <- ggplot(train_set.df) + aes(long, lat, group=group, fill=train_set.df$inc75_125) + 
  geom_polygon() + 
  geom_path(color="black") +
  coord_equal() +
  scale_fill_gradient(low = "gray96", high = "chartreuse4", name="Fraction of\n households") +
  ggtitle("Income between $75,000 to $125,000") + 
  theme_bw() +
  labs(x="Longitude", y = "Latitude") 
  #theme(plot.title = element_text(size=19))

p2 <- ggplot(train_set.df) + aes(long, lat, group=group, fill=train_set.df$y1960_1970) + 
  geom_polygon() + 
  geom_path(color="black") +
  coord_equal() +
  scale_fill_gradient(low = "gray96", high = "red3", name="Fraction of\n households") +
  ggtitle("Built between 1960 to 1970") + 
  theme_bw() +
  labs(x="Longitude", y = "Latitude") 
  #theme(plot.title = element_text(size=19))

p3 <- ggplot(train_set.df) + aes(long, lat, group=group, fill=train_set.df$r.occu) + 
  geom_polygon() + 
  geom_path(color="black") +
  coord_equal() +
  scale_fill_gradient(low = "gray96", high = "dodgerblue3", name="Fraction of\n households") +
  ggtitle("Households with renters") + 
  theme_bw() +
  labs(x="Longitude", y = "Latitude") 
  #theme(plot.title = element_text(size=19))

p4 <- ggplot(train_set.df) + aes(long, lat, group=group, fill=train_set.df$val100_175) + 
  geom_polygon() + 
  geom_path(color="black") +
  coord_equal() +
  scale_fill_gradient(low = "gray96", high = "grey4", name="Fraction of\n households") +
  ggtitle("Value between $100,000 to $175,000") + 
  theme_bw() +
  labs(x="Longitude", y = "Latitude") 
  #theme(plot.title = element_text(size=19))

grid.arrange(p1, p2, p3, p4, ncol=2)

ggplot(train_set.df) + aes(long, lat, group=group, fill=can_prop) + 
  geom_polygon() + 
  geom_path(color="black") +
  coord_equal() +
  scale_fill_gradient(low = "gray96", high = "chartreuse4", name="Fraction of\n canopy cover") +
  ggtitle("Canopy cover by block group") + 
  theme_bw() +
  labs(x="Longitude", y = "Latitude") 



test_set@data$id = rownames(test_set@data)
test_set.fort = tidy(test_set, region = "id")
test_set.df = join(test_set.fort, test_set@data, by="id")


ggplot(test_set.df) + aes(long, lat, group=group, fill=error) + 
  geom_polygon() +
  geom_path(color="black") +
  coord_equal() +
  scale_fill_gradient2(low = "red3", high = "dodgerblue3", name="Percent \nError") +
  ggtitle("Error of canopy cover predictions\n by testing dataset block groups") +
  theme_bw() +
  labs(x="Longitude", y = "Latitude") 
  



