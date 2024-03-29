:: Purpose:   Runs a series of commands to run a node JS tiddlywiki.
:: Version:   0.0.7
:: Download:  https://github.com/Telumire/TWNodeJSLauncher/releases
:: Author:    telumire
:: Usage:     ##Launch and/or create a tiddlywiki
::              Put this file into the folder of your choice, double click it.
::              If Node.js is not installed :
::              - The Node.js website will open
::              - Follow the instructions to install Node.js
::              - Restart the .bat
::              Write the name of the wiki when prompted (use the tab key to autofill the name)
::              It will create and launch tiddlywiki on a new port
::              
::            ##Use this bat from the command line
::              start "Name of the wiki"
::              
::            ##Convert a single file tiddlywiki into a wiki folder
::              Drag and drop your html on the .bat file
@ECHO off
::checks
:CHECK_NODEJS
where node > NUL && GOTO :CHECK_TW
echo NodeJS is not installed.
echo Go to https://nodejs.org to install Node.JS, then restart this file.
START https://www.nodejs.org
PAUSE
GOTO :EOF
:CHECK_TW
where tiddlywiki > NUL && GOTO :INIT
npm install -g tiddlywiki
:INIT
IF "%~x1"==".html" (
  CALL tiddlywiki --load "%~1" --savewikifolder "./%~n1"
  echo You are converting a single file tiddlywiki into a wiki folder.
  PAUSE
  GOTO :EOF
) ELSE (
  IF NOT "%~1"=="" (
    set name=%~1
  ) ELSE (
    ::ask for the name
    set /p name=Name of the wiki:
  )
)
::remove quotations
set name=%name:"=%
ECHO %name% will open shortly..
::search free port
set startPort=8000
:SEARCHPORT
netstat -o -n -a | find "LISTENING" | find ":%startPort% " > NUL
IF "%ERRORLEVEL%" equ "0" (
  set /a startPort +=1
  GOTO :SEARCHPORT
) ELSE (
  set freePort=%startPort%
  GOTO :FOUNDPORT
)
:FOUNDPORT
::if  the folder is empty, initialize wiki
SET "folder=%name%"
SET "files="
FOR /f "delims=" %%f IN ('dir /a-d /b "%folder%"') DO (
  SET "files=%%f"
)
IF "%files%"=="" (
  CALL tiddlywiki "%name%" --init server
  ECHO Wiki initialization completed.
)
::open the url in the default browser
START http://localhost:%freePort%
::create shortcuts files if missing 
IF NOT EXIST "%name%/start.bat" ECHO for %%%%d in ^(^.^) do cd.. ^& "%~n0" "%%%%~nxd" >"%name%/start.bat"
IF NOT EXIST "%name%/start-lazy.bat" ECHO for %%%%d in ^(^.^) do cd.. ^& "%~n0" "%%%%~nxd" --lazy all >"%name%/start-lazy.bat"
IF NOT EXIST "%name%/backup.bat" ECHO tiddlywiki --build index >"%name%/backup.bat"
::set title of the wiki if blank
IF NOT EXIST "%name%/tiddlers/$__SiteTitle.tid" (
  ECHO {"title":"$:/SiteTitle","text":"%name%"} >"%name%/title.json"
  CALL tiddlywiki "%name%" --load "%name%/title.json"
)
::listen to a free port
:: If lazy
IF "%2"=="--lazy" (
  IF "%3"=="images" CALL tiddlywiki +plugins/tiddlywiki/filesystem +plugins/tiddlywiki/tiddlyweb "%name%"  --listen port=%freePort% root-tiddler=$:/core/save/lazy-images
  IF "%3"=="all" CALL tiddlywiki +plugins/tiddlywiki/filesystem +plugins/tiddlywiki/tiddlyweb "%name%"  --listen port=%freePort% root-tiddler=$:/core/save/lazy-all
) ELSE (
CALL tiddlywiki +plugins/tiddlywiki/filesystem +plugins/tiddlywiki/tiddlyweb "%name%" --listen port=%freePort%
)
