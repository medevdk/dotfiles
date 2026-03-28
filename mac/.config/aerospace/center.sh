#!/bin/bash
sleep 0.15
#Use Applescript to center the window
osascript -e 'tell application "System Events"
  set frontProcess to first process whose frontmost is true
  set frontWindow to window 1 of frontProcess
  set screenBounds to bounds of window of desktop
  set screenWidth to item 3 of screenBounds
  set screenHeight to item 4 of screenBounds

  set windowSize to size of frontWindow 
  set windowWidth to item 1 of windowSize 
  set windowHeight to item 2 of windowSize

  set newX to (screenWidth - windowWidth) /2
  set newY to (screenHeight - windowHeight) /2

  set position of frontWindow to {newX, newY}
end tell '
