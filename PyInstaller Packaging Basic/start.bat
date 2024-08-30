@echo off

rem Check for required programs
for %%i in (git python pyinstaller) do (
    where %%i.exe >nul 2>&1 || (
        echo This operation requires %%i.
        pause
        exit /b
    )
)

echo Application is now generating...

rem Create and move to temp folder
mkdir temp && pushd temp

rem Generate application with PyInstaller
pyinstaller --noconfirm --onefile --windowed --icon "..\app-input\icon.ico" --add-data "..\app-input\setup-files;setup-files/" "..\app-input\app.pyw"

rem Copy files into the app-output folder
xcopy dist "..\app-output\*" /s /i /y
xcopy "..\app-input\setup-files\dependencies\*" "..\app-output\dependencies\" /s /i /e /y

rem Clean up
popd & rmdir /s /q temp

exit
