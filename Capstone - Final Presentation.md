Capstone - Presentation
========================================================
author: Usamah Khan
date: November 21, 2015
font-family: 'Risque'
width: 1024
height: 768
transition: rotate

DSS Capstone - Connecting Users to Build a Social Network In Yelp!



Introduction
========================================================

People are inclined to trust friends for recommendations and like to meet new people to go and eat with. Yelp allows this by following those who you believe have good reviews. So a question of interest was formulated: 

***Can Yelp be used to create a social network by recommending friends to you based on location, check-in, ratings and other factors?*** 

If there were a passive way to find recommendations like on Instagram's main feed or Tinder's Geo-feed, users may find it helpful. Hence, the question of interest for this analysis.

Methods and Data
========================================================

I - Manipulating and Extracting the Data

- Users were isolated based on city. Montreal was chosen for analysis. K-means clustering was employed on business ids and then linked to reviews and then to users ensuring only Montreal data was taken into account

II - Building a Data product

- The idea was plot all data for the centroids of user activity, and from there give users an option to find other users within a specific radius. This was done in shiny.

Results
========================================================

The app can be found at

**https://usamah-khan.shinyapps.io/DSS-Cap**

A "User Explorer" overlay gives the options of choosing a user and centers a circle of a variable radius. Once the zone is yet, the user can explore the region and check popups for user info. The data input is of the form:


```
    name longitude latitude
1 Roland -73.56573 45.50711
```

Discussion
========================================================

The question was most certainly answerable but there were limitations due to both the methods presented and assumptions that were made. Center of masses aren't necesarily correct due to outliers and geography and sectioning of the data would hopefully make it more accurate.


