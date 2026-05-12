@echo off
setlocal enabledelayedexpansion

if not exist "converted" mkdir "converted"

for %%F in (*.mp3 *.m4a *.aac *.wav *.flac *.ogg *.opus) do (

    echo.
    echo Processing: %%F

    set "bitrate="

    for /f %%B in ('
        ffprobe -v error -select_streams a:0 -show_entries stream^=bit_rate -of default^=nokey^=1:noprint_wrappers^=1 "%%F"
    ') do (
        set /a bitrate=%%B/1000
    )

    echo Detected: !bitrate! kbps

    if !bitrate! GTR 128 (

        echo Compressing to 128k...

        ffmpeg -hide_banner -loglevel error -stats -y ^
        -i "%%F" ^
        -vn ^
        -c:a libmp3lame ^
        -b:a 128k ^
        "converted\%%~nF.mp3"

    ) else (

        echo Copying original...

        copy /Y "%%F" "converted\%%~nxF" >nul
    )
)

echo.
echo All done.
pause
