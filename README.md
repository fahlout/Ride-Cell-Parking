# Ride-Cell-Parking
Ride Cell coding challenge creating a parking spot reservation app.

The app is ready to be downloaded. Just build and run!

Written in Swift 3

API used to implement the features below:
http://ridecellparking.herokuapp.com/api/v1/

Assumptions:
- App is for the city of San Francisco
- User has an account and is logged in
- User has a payment method configured in their account
- Reservation is assumed to be starting at the time of reserving a parking location

Features:
- User can search parking locations
- User can adjust for how long the parking location should be reserved for
- User can reserve parking location
- User can view reservation and see how much time is left on the reservation tab
- User can extend reservation when initial reservation has run out of time
- User can see a summary of the reservation after inital reservation has run out of time

Bonus:
- User can see the address of a parking location (done through reverse geocoding)
- User can delete reservation on the reservation summary (this will also set the parking location back to unreserved on the server)
- User can get directions to their car (the reserved parking location) from the reservation tab after a parking location has been reserved
- User can see their location on the map as well as easily zoom to where they are
- User can easily search again when moving around the map after doing an initial search
- User can see a live timer of how long is left on their reservation
- The app is integrated with Fabric

Notes:
Number of open spots are shown on the screen shots from the coding challenge pdf, but were not provided in the API and are therefore not in the app. Spot number was mentioned in the problem description, however, I was unable to find it in the API for any given parking location.
When a user searches the app will take the center coordinate of the map that is currently on the screen to facilitate the search.
