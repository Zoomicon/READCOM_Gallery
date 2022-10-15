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

:: Start HTML concatenation file
::echo ^<html^> > "%~df1\all.html"
::echo ^<body^> >> "%~df1\all.html"
::echo ^<div style="width:100vw"^/^> >> "%~df1\all.html"

if exist "~df1\all.docx" echo Clearing all.docx & del "%~df1\all.docx" /Q >NUL

:: Process files
if exist "%~df1\.html" echo Clearing subfolder ".html" & (for /D %%d in (%~df1\.html\*.*) do rmdir "%%d" /S /Q)
for %%f in (%1\*.readcom) do call :processFile "%%f" "%~df1\all.docx"

:: Process subfolders
for /D %%d in (%1\*.*) do call :processFolder "%%d" "%~df1\all.docx"

::::echo ^<iframe src="%~nx1\all.html" title="%1" style="width:100%%; height:640px; border:none;"^>iFrame not supported, use newer HTML browser^<^/iframe^> >> %2
::::echo ^<iframe src="%~nx1\all.html" title="%1" style="border:none; overflow:hidden;" sandbox="allow-same-origin" onload="this.style.height=(this.contentWindow.document.body.scrollHeight+20)+'px';"^>iFrame not supported, use newer HTML browser^<^/iframe^> >> %2
::echo ^<object data="%~nx1\all.html" style="width:100%%; max-height:fitcontent; height:100%%; max-height:fitcontent; overflow:none; display:block;"^>%~nx1\all.html not found^<^/object^> >> %2

::echo ^<^/div^> >> "%~df1\all.html"
::echo ^<^/body^> >> "%~df1\all.html"
::echo ^</html^> >> "%~df1\all.html"

::cscript DOCappend.vbs "%2" "%~nx1\all.docx" "%1" //NoLogo

exit /B 

::--------------------------------

:processFile
:: Note that %~dp1 always ends with a \
if not exist "%~dp1.html" echo Creating subfolder ".html" & md "%~dp1.html"

echo Saving HTML for %1
%~dp0READCOM_App -html "%~f1"

:: Append an iframe to HTML concatenation file
::echo ^<p^>%~1^<^/p^> >> %2
::::echo ^<iframe src=".html/%~nx1.html" title="%~nx1.html" style="width:100%%; height:640px; border:none;"^>iFrame not supported, use newer HTML browser^<^/iframe^> >> %2
::::echo ^<iframe src=".html/%~nx1.html" title="%~nx1.html" style="border:none; overflow:hidden;" sandbox="allow-same-origin" onload="this.style.height=(this.contentWindow.document.body.scrollHeight+20)+'px';"^>iFrame not supported, use newer HTML browser^<^/iframe^> >> %2
::echo ^<object data=".html/%~nx1.html" style="width:100%%; max-height:fitcontent; height:100%%; max-height:fitcontent; overflow:none; display:block;"^>.html/%~nx1.html not found^<^/object^> >> %2
::echo. >> %2

::cscript DOCappend.vbs "%2" "%~f1.html" "%~1" //NoLogo

:: Move to .html subfolder
move /Y %1.html "%~dp1.html\" >NUL
move /Y %1.html_Images "%~dp1.html\" >NUL

exit /B
