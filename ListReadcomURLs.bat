@echo off
setlocal enabledelayedexpansion

:: Set the base URL
set "BASE_URL=??https://raw.githubusercontent.com/zoomicon/READCOM_Gallery/master/Gallery/"

:: Get the current directory
set "BASE_DIR=%CD%\Gallery"

:: Create or clear the output file
> Gallery\ListReadcomURLs.txt (

    :: Loop through all *.readcom files recursively
    for /R %%F in (*.readcom) do (
        :: Get the relative path
        set "FULL_PATH=%%F"
        set "REL_PATH=!FULL_PATH:%BASE_DIR%\=!"
        :: Replace backslashes with forward slashes for URL compatibility
        set "REL_PATH=!REL_PATH:\=/!"
        echo !BASE_URL!!REL_PATH!
    )
)

endlocal
