Capstone - Presentation
========================================================
author: Usamah Khan
date: November 21, 2015
font-family: 'Lato'
width: 1024
height: 768

DSS Capstone - Connecting Users to Build a Social Network In Yelp!

Introduction
========================================================

People are inclined to trust friends for recommendations and like to meet new people to go and eat with. Yelp allows this by following those who you believe have good reviews. 

If there were a passive way to find recommendations like on Instagram's main feed or Tinder's Geo-feed, users may find it helpful. Hence, the question of interest for this analysis is:

***Can Yelp be used to create a social network by recommending friends to you based on location, check-in, ratings and other factors?*** 

Methods and Data
========================================================

I - Manipulating and Extracting the Data

Users were isolated based on city. Montreal was chosen for analysis. K-means clustering was employed on business ids and then linked to reviews and then to users ensuring only Montreal data was taken into account

II - Building a Data product

The idea was plot all data for the centroids of user activity, and from there give users an option to find other users within a specific radius. This was done in shiny.

Results
========================================================

The app can be found by running 

```r
runGitHub( "DSS-Capstone", "Usamahk") 
```

The app built was the result and was found that it could be used to determine friends. A "User Explorer" overlay gives the options of choosing a user and centers a circle of a variable radius. Once the zone is yet, the user can explore the region and other users inside by clicking on the marker which initiates a popup with relevent information pertaining to the user.

Discussion
========================================================

In the end, using Shiny and Leaflet proved to be a useful resource in terms of getting an example of the potential of the data use. The question was most certainly answerable but there were limitations due to both the methods presented and assumptions that were made.

