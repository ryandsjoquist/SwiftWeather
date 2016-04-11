# Swift-Weather
The Recieved Message ->
<!---->
<!--This is a simple app that retrieves the current conditions and forecast for-->
<!--Columbus, OH from the National Weather Service at weather.gov. We'd like you to-->
<!--fix two bugs and add some missing features.-->
<!---->
<!--1. Bug: On iOS 8, the app is able to fetch the current conditions and display-->
<!--them, but on iOS 9, it does not. The debug output says App Transport Security-->
<!--blocked the load.-->
<!---->
<!--2. Bug: There is a lengthy delay after getting a response from the server before-->
<!--the labels in the view update, and errors in the debug output about autolayout.-->
<!---->
<!--3. The JSON feed from NWS includes an image file to represent the current-->
<!--weather. Images on the NWS server are stored in a directory at-->
<!--http://forecast.weather.gov/newimages/medium/. Pull the image for the current-->
<!--weather and place it above the current temperature.-->
<!-- -->
<!--4. The JSON feed from NWS includes a 5-day forecast. Show this forecast along-->
<!--with the current weather.-->
<!---->
<!--5. Add something else to the app that you feel makes it better. It can be-->
<!--anything. Use your imagination!-->
<!---->

My Fixes ->

1. App transport security doesn't allow unsigned HTTP requests. However, I allowed forecast.weather.gov
because of it's trustworthiness, and the fact that it is a government site. I believe in proper data security, 
and won't allow arbitrary loads.

2. I put the UI update to the main_queue, for both the current weather and the future forecast. 
The JSON that was given gave a full week, and so I created a 7 day forecast for greater prediction range.

3. I added the image for the current weather, as well as for the five day forecast.

4. Added the 5 day forecaster to the bottom of the screen. Scrolls sideways for ease of use, the the day on the top of each cell.
Embedded Screen fits, and constraints are in place to make sure cells are always fully visible.

5. Added several labels to the current conditions for a more ful user experience. Added the collection view with the images of forecasted weather 
for at a glance understanding of the upcoming week.