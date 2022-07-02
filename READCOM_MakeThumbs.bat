@echo off

echo Syntax: READCOM_MakeThumbs [file|folder]
echo Processes Gallery subfolder by default

::--------------------------------

if not exist %~dp0READCOM_App.exe echo %~dp0READCOM_App.exe (need at least version 0.5.13) not found & pause & exit 1

SET param=%1
if "%param%"=="" SET param=Gallery

if exist %param%\nul (
  call :processFolder "%param%"
) else (
  call :processFile "%param%"
)

pause
exit 0

::--------------------------------

:processFolder
if "%~nx1"==".thumbs" exit /B
if "%~nx1"==".git" exit /B
echo Processing folder %1

for /D %%d in (%1\*.*) do call :processFolder "%%d"
for %%f in (%1\*.readcom) do call :processFile "%%f"

exit /B

::--------------------------------

:processFile
echo Saving thumb for %1
%~dp0READCOM_App -thumb %1

if not exist "%~p1.thumbs"\ echo Creating folder "%~p1.thumbs" & md "%~p1.thumbs"
move %1.png "%~p1.thumbs\" >NUL

exit /B
