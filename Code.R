## Load relevent Libraries

library(rjson)
library(plyr)
library(data.table)
library(maps)
library(ggmap)

## Set working Directory

setwd("~/Desktop/Coursera/Capstone/yelp_dataset_challenge_academic_dataset/Data")

## Set seed for reproducibility

set.seed(210794)

## Create Data frame for file pathnames

filePath <- data.frame()

filePath[1,1] <- "yelp_academic_dataset_business.json"; filePath[1,2] <- "business.data"
filePath[2,1] <- "yelp_academic_dataset_checkin.json" ; filePath[2,2] <- "checkin.data"
filePath[3,1] <- "yelp_academic_dataset_review.json"  ; filePath[3,2] <- "review.data"
filePath[4,1] <- "yelp_academic_dataset_tip.json"     ; filePath[4,2] <- "tip.data"
filePath[5,1] <- "yelp_academic_dataset_user.json"    ; filePath[5,2] <- "user.data"

## Clocking run speed - Using MacBook Pro 15" Retina 2015, 16GB

StartTime <- Sys.time()
format(StartTime, "%d-%m-%Y--%H:%M:%S")

## Reading in the JSON data 

for(i in 1:5){
  con = file(filePath[i,1], "r")
  input <- readLines(con, -1L)
  close(con)
  
  df <- ldply(lapply(input, function(x) t(unlist(fromJSON(x)))))
  assign(filePath[i,2], df)
}

RunTime <- Sys.time() - StartTime
RunTime

## Saving the datasets using "saveRDS"

saveRDS(business.data, file = "business.data.rds")
saveRDS(checkin.data, file = "checkin.data.rds")
saveRDS(review.data, file = "review.data.rds")
saveRDS(tip.data, file = "tip.data.rds")
saveRDS(user.data, file = "user.data.rds")

## Loading the datasets after saving to drive using "saveRDS"

business.data <- readRDS("business.data.rds")
checkin.data  <- readRDS("checkin.data.rds")
review.data   <- readRDS("review.data.rds")
tip.data      <- readRDS("tip.data.rds")
user.data     <- readRDS("user.data.rds")

## Create lists of all the levels in business.data
## for exploratory analysis

mydata <- sapply(business.data, levels)

## Need to isolate all the cities, can do so by using K-means clustering
## on geomaps

business.data$latitude <- as.numeric(levels(business.data$latitude))[business.data$latitude]
business.data$longitude <- as.numeric(levels(business.data$longitude))[business.data$longitude]

coordinates <- as.data.table(cbind(business.data$longitude, business.data$latitude))
colnames(coordinates) <- c("latitude", "longitude")

## Create a data frame with longitudes and latitudes for each city in the database
## Use - K-means clustering later

cities <- c('Edinburgh, UK', 'Karlsruhe, Germany', 'Montreal, Canada', 'Waterloo, Canada', 
            'Pittsburgh, PA', 'Charlotte, NC', 'Urbana-Champaign, IL', 'Phoenix, AZ', 'Las Vegas, NV', 'Madison, WI')
city.center <- geocode(cities)
city.center <- round(city.center)
rownames(city.center) <- c('Edinburgh, UK', 'Karlsruhe, Germany', 'Montreal, Canada', 'Waterloo, Canada', 
                           'Pittsburgh, PA', 'Charlotte, NC', 'Urbana-Champaign, IL', 'Phoenix, AZ', 'Las Vegas, NV', 'Madison, WI')

## Display Map and clustering Geographically on a map, check for outliers in the data

map("world", ylim=c(10,70), xlim=c(-140,20), col="gray50")
points(coordinates$longitude, coordinates$latitude,
       pch=19, col="cyan4")

## Perform K-means clustering to group using initial guesses from geocode

city.clusters <-kmeans(coordinates, city.center)
ct.km <- table(coordinates$longitude, city.clusters$cluster)

coordinates.clusters <- cbind(city.clusters$cluster, coordinates)
colnames(coordinates.clusters) <- c("City", "latitude", "longitude")
coordinates.clusters$City <- as.factor(coordinates.clusters$City)
levels(coordinates.clusters$City) <- c('Edinburgh, UK', 'Karlsruhe, Germany', 'Montreal, Canada', 'Waterloo, Canada', 
                                       'Pittsburgh, PA', 'Charlotte, NC', 'Urbana-Champaign, IL', 'Phoenix, AZ', 'Las Vegas, NV', 'Madison, WI')

## Bind the clustering results to the original business.data table and name
## and convert to character

business.data <- cbind(coordinates.clusters$City,business.data)
colnames(business.data)[1] <- "City"
business.data$City <- as.character(business.data$City)

## Moving forward all tests will be based on the data for Montreal
## Subset the data based on location

business.data.mtl <- subset(business.data, business.data$City == "Montreal, Canada")
business.data.mtl <- business.data.mtl[,c("City", "business_id", "longitude", "latitude")]

## Plot map of Montreal and locations 
## - Montreal coordinates lon = -73.587810, lat = 45.50884

mtl <- get_map(location = c(lon = -73.587810, lat = 45.50884), zoom = "auto", scale = "auto")
ggmap(mtl) + geom_point(aes(x = longitude, y = latitude, data = business.data.mtl), alpha = .5, color="darkred", size = 3)

## Subset from reviews, all businesses reviewed in Montreal

review.data.mtl <- review.data[which(review.data$business_id %in% business.data.mtl$business_id),]

## Subset from review.data.mtl, all users - Hence all users based out of Montreal

user.data.mtl <- user.data[which(user.data$user_id %in% review.data.mtl$user_id),]

## Make a table merging info on users and reviews

review.user.mtl <- merge(review.data.mtl, business.data.mtl, by = "business_id")

## Subset records from review.user.mtl pertaining to a single user. In time this can
## and will be automated but for the sake of experiment, pick observation 3 since it
## that user has a good sized amount of businesses attended to build a profile. This
## section of the code will determine a center of mass for this individual

user.id <- subset(review.user.mtl, review.user.mtl$user_id == user.data.mtl[3,7])

## Calculate centroid and check graphically

mx <- mean(user.id$longitude)
my <- mean(user.id$latitude)

plot(user.id$longitude, user.id$latitude, pch = 1)
points(mx, my, pch=3)

## Place in a table

user.id.location <- data.frame()
user.id.location[1,1] <- user.data.mtl[3,7]
user.id.location[1,2] <- mx
user.id.location[1,3] <- my

## Write a loop to automate

for(i in i:nrow(user.data.mtl))
  {
    user.id <- subset(review.user.mtl, review.user.mtl$user_id == user.data.mtl[i,7])
    mx <- mean(user.id$longitude)
    my <- mean(user.id$latitude)
  
    user.id.location[i,1] <- user.data.mtl[i,7]
    user.id.location[i,2] <- mx
    user.id.location[i,3] <- my
}

## Merge to get names and other useful indicators

user.id.location <- merge(user.data.mtl[,c(6,7,5,214,215)], user.id.location, by = "user_id")
user.id.location$name <- as.character(user.id.location$name)

## Write base code for the shiny app. Ideally call a single person and find out
## how many people are within a certain radius of them

## For testing

user.test <- user.id.location[c(1:100),]

## Calculate distance in kilometers between two points - Haversine Formula

earth.dist <- function (long1, lat1, long2, lat2)
  {
    rad <- pi/180
    a1 <- lat1 * rad
    a2 <- long1 * rad
    b1 <- lat2 * rad
    b2 <- long2 * rad
    dlon <- b2 - a2
    dlat <- b1 - a1
    a <- (sin(dlat/2))^2 + cos(a1) * cos(b1) * (sin(dlon/2))^2
    c <- 2 * atan2(sqrt(a), sqrt(1 - a))
    R <- 6378.145
    d <- R * c
    return(d)
}

## Bibliography and references
## FOUND HAVERSINE FORMULA ON DISCUSSION BOARD
## USED GGMAP - 
## D. Kahle and H. Wickham. ggmap: Spatial Visualization with ggplot2. The R Journal,
## 5(1), 144-161. URL http://journal.r-project.org/archive/2013-1/kahle-wickham.pdf