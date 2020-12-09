# Muffler

Muffler is a macOS menu bar app that lets you quickly mute the micrphone and/or
video for Zoom and/or BlueJeans.

## Download/install

[Download the latest release](https://github.com/daneden/muffler/releases/latest/download/Muffler.app.zip)
and open the app to run it.

On its first run/open, Muffler will ask permissions to send Apple Events and
control the computer. These permissions are what allows Muffler to ask
BlueJeans/Zoom to mute their mic/video.

## How it works

For BlueJeans, Muffler briefly foregrounds the window, sends the “m” or “v”
keystroke (corresponding to audio/video mute respectively), then switches back
to the previously-foregrounded app.

For Zoom, Muffler invokes a click on the menu items for muting/unmuting or
stopping/starting audio or video.

The app requires permission to control the user’s computer in order to send
keystrokes and invoke menu clicking.
