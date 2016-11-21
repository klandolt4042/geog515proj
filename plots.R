#plots for the paper
library(ggplot2)
library(tigris)
library(acs)
library(ggmap)
library(broom)

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


ggplot(train_set.df) + aes(long, lat, group=group, fill=can_prop) + 
  geom_polygon() + 
  geom_path(color="black") +
  coord_equal() +
  scale_fill_gradient(low = "gray96", high = "chartreuse4") +
  ggtitle("Block groups used for training dataset") + 
  theme_bw() +
  labs(x="Longitude", y = "Latitude") 

ggplot(test_set.df) + aes(long, lat, group=group, fill=error) + 
  geom_polygon() +
  geom_path(color="black") +
  coord_equal() +
  scale_fill_gradient2(low = "red3", high = "dodgerblue3") +
  ggtitle("Error of canopy cover predictions\n by testing dataset blockgroups (in percent)") +
  theme_bw() +
  labs(x="Longitude", y = "Latitude") 
  

