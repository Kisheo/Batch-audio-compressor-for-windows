# Audio Batch Compressor (FFmpeg + Windows CMD)

Automatically compress audio files above **128kbps** to **128kbps MP3** using **FFmpeg**.
Files already at `128kbps` or lower are copied without modification.

Perfect for reducing music library size while preserving compatibility.

---

## Features

* Batch processes an entire folder
* Supports:

  * MP3
  * M4A
  * AAC
  * WAV
  * FLAC
  * OGG
  * OPUS
* Automatically detects bitrate
* Only recompresses files above 128kbps
* Copies lower bitrate files unchanged
* Saves everything into a separate `converted` folder
* Handles filenames with spaces and special characters

---

## Requirements

* Windows
* CMD
* FFmpeg installed and added to PATH
* FFprobe included with FFmpeg

Check installation:

```bash
ffmpeg -version
ffprobe -version
```

---

## Usage

1. Create a file named:

```text
compress_audio.cmd
```

2. Paste this script inside:

```bat
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
```

3. Put the script inside your music folder

Example:

```text
Music/
├── song1.mp3
├── song2.flac
├── compress_audio.cmd
```

4. Double-click the script

---

## Output

A new folder named:

```text
converted/
```

will be created automatically.

Example:

```text
Music/
├── song1.mp3
├── song2.flac
├── converted/
│   ├── song1.mp3
│   ├── song2.mp3
```

---

## Example Console Output

```text
Processing: Song Name.mp3
Detected: 320 kbps
Compressing to 128k...

size=4521kB time=00:04:12 bitrate=128.0kbits/s speed=22x
```

---

## Notes

* Recompressed files are always saved as MP3
* Original files are never modified
* Audio encoding is CPU-based
* NVIDIA CUDA / RTX GPUs do not significantly accelerate MP3 encoding

---

## License

MIT License
