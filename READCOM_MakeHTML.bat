@echo off

echo Syntax: READCOM_MakeHtml [file^|folder]
echo Processes Gallery subfolder by default

::--------------------------------

if not exist "%~dp0READCOM_App.exe" echo %~dp0READCOM_App.exe (need at least version 0.7.13) not found & pause & exit 1

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
if "%~nx1"==".html" exit /B
if "%~nx1"==".git" exit /B

echo:
echo Processing folder %1

:: Process files
if exist "%~df1\.html" echo Clearing subfolder ".html" & (for /D %%d in (%~df1\.html\*.*) do rmdir "%%d" /S /Q)
for %%f in (%1\*.readcom) do call :processFile "%%f"

:: Process subfolders
for /D %%d in (%1\*.*) do call :processFolder "%%d"

exit /B 

::--------------------------------

:processFile
:: Note that %~dp1 always ends with a \
if not exist "%~dp1.html" echo Creating subfolder ".html" & md "%~dp1.html"

echo Saving HTML for %1
%~dp0READCOM_App -html "%~f1"
move /Y %1.html "%~dp1.html\" >NUL
move /Y %1.html_Images "%~dp1.html\" >NUL

exit /B
