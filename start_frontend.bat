@echo off
echo Starting Wiki Loves Frontend Server...
echo.

REM Get the directory where this batch file is located
set SCRIPT_DIR=%~dp0

REM Navigate to the frontend directory
cd /d "%SCRIPT_DIR%wikiloves-main\frontend\Wikiproject"

REM Check if package.json exists
if not exist "package.json" (
    echo ERROR: package.json not found in %CD%
    echo Expected location: %CD%
    pause
    exit /b 1
)

echo Current directory: %CD%
echo.
echo Installing dependencies (if needed)...
call npm install

echo.
echo Starting development server...
call npm run dev

pause

