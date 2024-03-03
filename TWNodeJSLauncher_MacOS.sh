#!/bin/bash

# Purpose: Runs a series of commands to run a Node.js TiddlyWiki.
# Version: 0.0.1
# Author: telumire + chatgpt
# Warning: This script is a translation made by chatgpt of my .bat script for macOS. I do not own a mac so I can't tell if this works or not, use it at your own risks. 
# Usage: 
#   - Launch and/or create a TiddlyWiki:
#       Place this script into the folder of your choice and run it from the terminal.
#       If Node.js is not installed, follow the instructions to install Node.js and restart this script.
#       Write the name of the wiki when prompted (use the tab key to autofill the name).
#       It will create and launch TiddlyWiki on a new port.
#
#   - Convert a single file TiddlyWiki into a wiki folder:
#       Run this script with the path to your .html file as an argument.

# Check for Node.js installation
if ! which node > /dev/null; then
    echo "NodeJS is not installed."
    echo "Go to https://nodejs.org to install Node.js, then restart this script."
    open https://www.nodejs.org
    exit 1
fi

# Check for TiddlyWiki installation
if ! which tiddlywiki > /dev/null; then
    npm install -g tiddlywiki
fi

# Initialize variables
name=""
startPort=80
freePort=""

# Function to find a free port
find_free_port() {
    while : ; do
        if ! nc -z localhost $startPort 2>/dev/null; then
            freePort=$startPort
            break
        else
            ((startPort++))
        fi
    done
}

# Main logic
if [ "$#" -eq 1 ] && [ "${1: -5}" == ".html" ]; then
    # Convert a single file TiddlyWiki into a wiki folder
    tiddlywiki --load "$1" --savewikifolder "./$(basename "$1" .html)"
    echo "You are converting a single file TiddlyWiki into a wiki folder."
else
    # Ask for the name of the wiki
    if [ "$#" -eq 0 ]; then
        read -p "Name of the wiki: " name
    else
        name="$1"
    fi

    # Remove quotations
    name="${name//\"/}"

    echo "$name will open shortly.."

    # Search for a free port
    find_free_port

    # Check if the folder is empty, then initialize wiki
    if [ ! "$(ls -A "$name")" ]; then
        tiddlywiki "$name" --init server
        echo "Wiki initialization completed."
    fi

    # Open the URL in the default browser
    open "http://localhost:$freePort"

    # Create shortcut files if missing
    if [ ! -f "$name/start.sh" ]; then
        echo "#!/bin/bash" > "$name/start.sh"
        echo "$(basename "$0") \"$name\"" >> "$name/start.sh"
        chmod +x "$name/start.sh"
    fi

    # Set title of the wiki if blank
    if [ ! -f "$name/tiddlers/\$__SiteTitle.tid" ]; then
        echo "{\"title\":\"$:/SiteTitle\",\"text\":\"$name\"}" > "$name/title.json"
        tiddlywiki "$name" --load "$name/title.json"
    fi

    # Listen to the free port
    tiddlywiki +plugins/tiddlywiki/filesystem +plugins/tiddlywiki/tiddlyweb "$name" --listen port="$freePort"
fi
