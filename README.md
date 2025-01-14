# Simple Online Multiplayer Networking

A simple Godot online multiplayer networking setup: connect to an online server, instance a map, spawn players, and update their positions.

The clients connect by default to the local IP of your computer. When a game is hosted, the server's public IP is displayed above. The IP can be shared with clients for an internet connection. It is also possible to compile the game with the server's public IP directly in the script so that clients automatically join when the server is launched. The client calls the "join" button in the ready function and will connect automatically upon launch if a server is detected (by default, if a local server is detected).