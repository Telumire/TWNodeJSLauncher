# TWNodeJSLauncher
`TWNodeJSLauncher.bat` is a batch file to start and manage tiddlywiki on Node.JS

I dont know how to code in batch, this file was build with a lot of googling, so it can probably be improved. 
Feedbacks are welcome !

If you want to hide the command prompt window from the taskbar, you can use this tool : https://github.com/benbuck/rbtray

# Usage
Put the .bat in any folder, then double click it and write the name of your wiki. If there is no folder with that name in the current directory, it will create one then launch the wiki in the default browser. It will also create shortcuts in the wiki folder that you can pin to the taskbar or your start menu (right click start.bat, create a shortcut and put it in `C:\ProgramData\Microsoft\Windows\Start Menu` to be able to pin it).

You can convert a single file tiddlywiki to a tiddlywiki folder by simply drag and dropping the file onto the .bat. 

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

- [x] Add support for drag & drop a single file tiddlywiki on the batch to convert it into a wiki folder
- [x] Add support for lazy loading (v0.0.4)
- [ ] Add option to set defaults settings (Plugins, UI settings)
- [ ] Add support for multi user wiki (Auth)
- [ ] Add support for the rest of the commands : https://tiddlywiki.com/#Commands
- [ ] Automatically hide the CLI
- [ ] Add a GUI
- [ ] Add right click menu support (see https://youtu.be/wsZp_PNp60Q)
