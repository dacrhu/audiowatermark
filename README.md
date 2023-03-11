# Audio analog watermark
Very simple audio analog watermark generator.

Dependecies:

- Linux
- Bash
- sox (apt/yum install sox)

Usage:

```
audiowatermark.sh input.wav output.wav rate_of_watermark_in_seconds
```

Example:

```
audiowatermark.sh mymusic.wav mymusic_wm.wav 10
```

(There will be a beep in the music every 10 seconds)


I know this script is not performance effective. You can easily develop it further.
