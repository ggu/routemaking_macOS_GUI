# Routemaking GUI
The macOS GUI for UBC Sailbot's routemaking component.

## Background
This is the front-end for a process that creates paths around other boats (detected through the Automatic Identification System used on ships) that was used for UBC Sailbot's autonomous sailboat, Ada (see more here https://ubcsailbot.org). I quickly developed this in Newfoundland while our team was preparing to launch Ada on her transatlantic journey to simplify testing of our boat avoidance algorithms. 

The routemaking code itself was written in C++ by a few of us on UBC Sailbot while the front-end was developed by me with Swift. I wrote a wrapper in C in order to interface with the UBC Sailbot code.

## Demo/More Info
Here is a short video demonstrating the GUI: https://www.youtube.com/watch?v=AanXgTiSrGo.

The red blobs are nearby boats with 1 kilometer risk radii for our boat to avoid, the yellow tile is the target, and the green tiles represent the travelled path and current position through time. The grey tiles represent visited nodes (nodes that the algorithm considers for travel, but doesnt due to finding a more optimal path as we use A* search).

<img src="https://github.com/ggu/routemaking_macOS_GUI/blob/master/screenshot.png"/>
