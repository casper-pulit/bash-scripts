@echo off
setlocal

set VAULT_DIR="C:\Users\caspe\Documents\vault"

REM Function to run before the program starts
:before_program
echo Starting Obsidian Hook
echo Checking for updates on GitHub repository
cd /d %VAULT_DIR%
git pull


REM Function to run after the program ends
:after_program
for /f "tokens=1-5 delims=/: " %%d in ("%date% %time%") do (
    set end_time=%%d-%%e-%%f %%g:%%h:%%i
)
git add .
git status
git commit -m "Updated at %end_time%"
git push

REM Main function to run the program and detect its termination
:run_program
call :before_program

REM Run the program in the background
start "" "C:\Users\caspe\AppData\Local\Programs\obsidian\Obsidian.exe"
set PROGRAM_PID=%!

REM Wait for the program to finish (Windows does not have a direct equivalent to 'wait')
REM Using a loop to check if the program is running
:wait_loop
tasklist /fi "PID eq %PROGRAM_PID%" | find /i "Obsidian.exe" >nul
if not errorlevel 1 (
    timeout /t 1 /nobreak >nul
    goto wait_loop
)

call :after_program
goto :eof

REM Run the main function
call :run_program

endlocal
