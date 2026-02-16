@echo off
setlocal

:: Check for SkyrimSE_PATH
if not defined SkyrimSE_PATH (
    echo ERROR: SkyrimSE_PATH environment variable is not set.
    echo.
    echo Set it to your Skyrim Special Edition installation directory, e.g.:
    echo   set SkyrimSE_PATH=C:\Program Files ^(x86^)\Steam\steamapps\common\Skyrim Special Edition
    echo.
    pause
    exit /b 1
)

echo Using Skyrim SE at: %SkyrimSE_PATH%
echo.

:: Configure
echo --- Configuring ---
cmake --preset build -Wno-dev
if errorlevel 1 (
    echo.
    echo ERROR: CMake configuration failed.
    pause
    exit /b 1
)

:: Build
echo.
echo --- Building ---
cmake --build build
if errorlevel 1 (
    echo.
    echo ERROR: Build failed.
    pause
    exit /b 1
)

echo.
echo --- Done ---
echo Release zip created in the release/ folder.
echo.
pause
