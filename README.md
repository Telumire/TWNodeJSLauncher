# TWNodeJSLauncher
`TWNodeJSLauncher.bat` is a batch file to start and manage tiddlywiki on Node.JS

I dont know how to code in batch, this file was build with a lot of googling, so it can probably be improved. 
Feedbacks are welcome !

# Features

* Check if Node.JS is installed
* If not, open https://nodejs.org and close
* If Node.JS is installed, check if Tiddlywiki is installed
* If not, install tiddlywiki globally
* If start.bat was launched with an argument (e.g : start.bat "My wiki"), it will use the argument as the name of the wiki
* If the name was not provided, it will ask for one
* Then it will create or initiate the wiki in the same directory
* It will seek a free port and serve the wiki on it (meaning you can open as many wiki as you want at the same time)
* Then the wiki will be open in the default web browser
* If the tiddler `$__SiteTitle.tid` doesnt exist, the title of the wiki will be set to the name given. To achieve that, title.json is created inside the folder'wiki, you can delete it later
* Two batch files will be added into the wiki directory : one to start the wiki, the other to make a single file backup. In order for the shortcuts to work, you need to keep start.bat in the parent folder.

# TODO

- [x] Add support for drag & drop a single file tiddlywiki on the batch to convert it into a node.js tiddlywiki
- [ ] Add support for lazy loading
- [ ] Add support for multi user wiki (Auth)
- [ ] Add support for the rest of the commands : https://tiddlywiki.com/#Commands
- [ ] Automatically hide the CLI
- [ ] Add a GUI
- [ ] Add right click menu support (see https://youtu.be/wsZp_PNp60Q)
