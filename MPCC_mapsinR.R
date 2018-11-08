#Hello, welcome to map-making in R 101

#Some of this is taken from http://eriqande.github.io/rep-res-web/lectures/making-maps-with-R.html
#If you want to read more about the map-making, go to that link!

#First, install these R libraries:
install.packages(c("ggplot2","devtools","dplyr","stringr","ggmap","maps","mapdata","ggsn","maptools"))

library(ggplot2)
library(ggmap)
library(maps)
library(mapdata)
library(ggsn)
library(maptools)

#Here is the world, try it out:
world <- map_data("world") #this loads our world map data from the interwebs
quartz() #this opens a window where your map will show up
ggplot() + geom_polygon(data = world, aes(x=long, y = lat, group = group)) + 
  coord_fixed(1.3) #this creates our map shapes & plots it

#Here is the USA:
usa <- map_data("usa") #loads our usa data
ggplot() + geom_polygon(data = usa, aes(x=long, y = lat, group = group)) + 
  coord_fixed(1.3) #plots our usa data

#Now to get to states
states <- map_data("state") #load our states data
head(states) #the data starts with alabama
tail(states) #end withs wyoming

cali <- subset(states, region == "california") #load in cali data
head(cali) #does it say california in the 5th column?

#Let's add county lines:
counties <- map_data("county") #load in counties data
ca_county <- subset(counties, region == "california") 

#State map with counties in white:
ggplot(data = cali, mapping = aes(x = long, y = lat, group = group)) + 
  coord_fixed(1.3) + 
  geom_polygon(color = "black", fill = "gray") +
  theme_nothing() + #removes some of the background stuff we had before
  geom_polygon(data = ca_county, fill = NA, color = "white") +
  geom_polygon(color = "black", fill = NA)  

#Zoom in to a specific region:
ggplot(data = cali, mapping = aes(x = long, y = lat, group = group)) + 
  coord_fixed(1.3) + 
  geom_polygon(color = "black", fill = "gray") +
  theme_nothing() + #removes some of the background stuff we had before
  geom_polygon(data = ca_county, fill = NA, color = "white") +
  geom_polygon(color = "black", fill = NA) + 
  coord_fixed(xlim = c(-123, -121.0),  ylim = c(36, 38), ratio = 1.3)
#ignore the warning messages

#Now you're going to do YOUR states & sites:
mystate <- subset(states, region == "X") #replace X with what state you need
head(mystate) #does it say the correct state name in the 5th column?

#Let's add county lines:
mystate_county <- subset(counties, region == "X") #specify your state
head(mystate_county) #how does it look?

#State map with counties in white:
ggplot(data = mystate, mapping = aes(x = long, y = lat, group = group)) + 
  coord_fixed(1.3) + 
  geom_polygon(color = "black", fill = "gray") +
  theme_nothing() + #removes some of the background stuff we had before
  geom_polygon(data = mystate_county, fill = NA, color = "white") +
  geom_polygon(color = "black", fill = NA)  

#To make your specific colleciton sites, you need your site's 
#coordinates.

#An easy way to do this is to go to Google Maps,
#drop a pin at your site, and Google Maps provides the latitude &
#longitude for you, which looks like this: 42.348657, -71.101649
#So put in: -71,-71.5 for xlim (longitude) & 42, 42.5 for ylim (latitude)
ggplot(data = mystate, mapping = aes(x = long, y = lat, group = group)) + 
  coord_fixed(1.3) + 
  geom_polygon(color = "black", fill = "gray") +
  theme_nothing() + #removes some of the background stuff we had before
  geom_polygon(data = mystate_county, fill = NA, color = "white") +
  geom_polygon(color = "black", fill = NA) + 
  coord_fixed(xlim = c(X, X),  ylim = c(X, X), ratio = 1.3)

#your first site map!
#Doesn't show us very much topography..
#Use these lines for more details:

bump <- get_map(location = c(-71.101649,42.348657), maptype = "satellite", source = "google", zoom = 8)
#Remove the pound sign from the next line if that last line doesn't work:
#bump <- get_googlemap(center = c(lon = -71.101649, lat = 42.348657),maptype="satellite",zoom=15,key="AIzaSyBNJc5IV3n0oOustMxvH4r2tzIjhM8vKF0")

id=c("BUMP") 
lon=c(-71.101649)
lat=c(42.348657) 
add = data.frame(id,lon,lat)

ggmap(bump) +
  geom_point(data=add, aes(x=lon,y=lat),colour="white",size=5,pch=7)+
  geom_text(data =add, aes(x = lon, y = lat, label = id), 
            size = 10, hjust = -0.2, color="white")

#Enter in your own coordinates:
sitemap1 <- get_map(location = c(X,X), maptype = "satellite", source = "google", zoom = 11)
#Change the zoom if you want to zoom in (bigger number) & out (smaller number)
#use the following line instead if that one doesn't work:
#sitemap1 <- get_googlemap(center = c(lon = -71.101649, lat = 42.348657),maptype="satellite",zoom=15,key="AIzaSyBNJc5IV3n0oOustMxvH4r2tzIjhM8vKF0")

#Enter in your own 'star' or something where your site is
id=c("ID") #change to your site name
lon=c(X) #change to your longitude
lat=c(X) #change to your latitude
mysite = data.frame(id,lon,lat)

ggmap(sitemap1) +
  geom_point(data=mysite, aes(x=lon,y=lat),colour="white",size=5,pch=8)+
  geom_text(data=mysite, aes(x=lon, y=lat, label=id), size = 10, hjust = -0.2, color="white")

#pch = different points
#different points that you can use are here:
#http://www.sthda.com/english/wiki/r-plot-pch-symbols-the-different-point-shapes-available-in-r

#Prettier maps:
bump2 <- c(left = -71.11, bottom = 42.335, right = -71.09, top = 42.360)
map2 <- get_stamenmap(bump2, zoom = 16, maptype = "toner") 
quartz()
ggmap(map2)+
  geom_point(data=add, aes(x=lon,y=lat),size=12,pch=8,color="red")

map2 <- get_stamenmap(bump2, zoom = 16, maptype = "watercolor")
ggmap(map2)+
  geom_point(data=add, aes(x=lon,y=lat),size=12,pch=18,color="black")