#!/bin/bash
sleep 0.2
TARGET_APP="${1:-}"

osascript -e "
tell application \"System Events\"
  if \"$TARGET_APP\" is not \"\" then
    set targetProcess to first process whose name is \"$TARGET_APP\"
  else
    set targetProcess to first process whose frontmost is true
  end if
  -- Find the smallest window (the dialog, not the main browser)
  set smallestWindow to missing value
  set smallestArea to 999999999
  repeat with w in windows of targetProcess
    set wSize to size of w
    set wArea to (item 1 of wSize) * (item 2 of wSize)
    if wArea < smallestArea then
      set smallestArea to wArea
      set smallestWindow to w
    end if
  end repeat
  if smallestWindow is missing value then return
  set screenBounds to bounds of window of desktop
  set screenWidth to item 3 of screenBounds
  set screenHeight to item 4 of screenBounds
  set windowSize to size of smallestWindow
  set windowWidth to item 1 of windowSize
  set windowHeight to item 2 of windowSize
  set newX to (screenWidth - windowWidth) / 2
  set newY to (screenHeight - windowHeight) / 2
  set position of smallestWindow to {newX, newY}
end tell
"
