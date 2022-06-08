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
IF NOT "%~1"=="" (
  ::if using shortcut
  set name=%~1
) ELSE (
  ::ask for the name
  set /p name=Name of the wiki:
)
::remove quotations
set name=%name:"=%
ECHO %name% will open shortly..
::search free port
set startPort=80
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
::launch tiddlywiki server
CALL tiddlywiki "%name%" --init server
::open the url in the default browser
START http://localhost:%freePort%
::create shortcuts files if missing 
IF NOT EXIST "%name%/start.bat" ECHO for %%%%d in ^(^.^) do cd.. ^& start.bat "%%%%~nxd" >"%name%/start.bat"
IF NOT EXIST "%name%/backup.bat" ECHO tiddlywiki --build index >"%name%/backup.bat"
::set title of the wiki if blank
IF NOT EXIST "%name%/tiddlers/$__SiteTitle.tid" (
  ECHO {"title":"$:/SiteTitle","text":"%name%"} >"%name%/title.json"
  CALL tiddlywiki "%name%" --load "%name%/title.json"
)
::listen to a free port
CALL tiddlywiki "%name%" --listen port=%freePort%