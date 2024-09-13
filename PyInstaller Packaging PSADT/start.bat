@echo off
setlocal enabledelayedexpansion

rem Check for required programs
for %%i in (git python pyinstaller) do (
    where %%i.exe >nul 2>&1 || (
        echo This operation requires %%i.
        pause
        exit /b
    )
)

rem Check for existing project
set "fileCount=0"
for /r ".\app-input\setup-files" %%a in (*) do (
    set /a fileCount+=1
)

if %fileCount%==0 (
    echo Application is now generating...
    timeout /t 3 /nobreak >nul
    goto :GenerateApplication
)

rem Cleanup from broken previous runs
:Cleanup
if exist ".\app-input\setup-files" (
    del /q /f ".\app-input\setup-files\*"
    for /d %%i in (.\app-input\setup-files\*) do rmdir /s /q "%%i"
)
if exist ".\app-output" (
    rmdir /s /q ".\app-output"
)
if exist ".\temp" (
    rmdir /s /q ".\temp"
)
if exist ".\build" (
    rmdir /s /q ".\build"
)
if exist ".\dist" (
    rmdir /s /q ".\dist"
)
if exist ".\Toolkit" (
    rmdir /s /q ".\Toolkit"
)
if exist ".\app.spec" (
    del /q /f ".\app.spec"
)

:GenerateApplication
rem Create a temporary directory
mkdir temp

rem Clone the PSADT repository into the temporary directory
git clone https://github.com/PSAppDeployToolkit/PSAppDeployToolkit.git ".\temp"

rem Check if the clone was successful
if not exist ".\temp\Toolkit" (
    echo Failed to clone the repository.
    pause
    exit /b
)

rem Copy the contents of the Toolkit directory from the temporary directory
xcopy ".\temp\Toolkit\*" ".\app-input\setup-files" /e /i /c /q /h /r /y

rem Check if the files were copied successfully
if errorlevel 1 (
    echo Error copying files to setup-files.
    pause
    exit /b
)

rem Cleanup: Delete the temporary directory
if exist ".\temp" ( rmdir /s /q ".\temp" )

rem Create app-output directory and build the application
mkdir ".\app-output"

rem Build application
mkdir temp && pushd temp
pyinstaller --noconfirm --onefile --windowed --icon "..\app-input\icon.ico" --add-data "..\app-input\setup-files;setup-files/" "..\app-input\app.pyw"

rem Check if the build was successful
if not exist ".\dist" (
    echo PyInstaller build failed.
    popd
    rmdir /s /q ".\temp"
    pause
    exit /b
)

xcopy ".\dist\*" "..\app-output\" /s /i /y

rem Check if the files were copied successfully
if errorlevel 1 (
    echo Error copying files to app-output.
    popd
    rmdir /s /q ".\temp"
    pause
    exit /b
)

popd
rmdir /s /q ".\temp"

echo Application generation complete. Output available in app-output folder.
pause
endlocal
