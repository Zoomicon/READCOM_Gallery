@echo off

echo Syntax: READCOM_MakeThumbs [file^|folder]
echo Processes Gallery subfolder by default

::--------------------------------

if not exist "%~dp0READCOM_App.exe" echo %~dp0READCOM_App.exe (need at least version 0.5.13) not found & pause & exit 1

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

echo:
echo Processing folder %1

:: Process files
if exist "%~df1\.thumbs" echo Clearing subfolder ".thumbs" & (del "%~df1\.thumbs\*.*" /Q >NUL)
for %%f in (%1\*.readcom) do call :processFile "%%f"

:: Process subfolders
for /D %%d in (%1\*.*) do call :processFolder "%%d"

exit /B 

::--------------------------------

:processFile
:: Note that %~dp1 always ends with a \
if not exist "%~dp1.thumbs" echo Creating subfolder ".thumbs" & md "%~dp1.thumbs"

echo Saving thumb for %1
%~dp0READCOM_App -thumb "%~f1"
move %1.png "%~dp1.thumbs\" >NUL

exit /B
