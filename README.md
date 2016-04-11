# Swift-Weather


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