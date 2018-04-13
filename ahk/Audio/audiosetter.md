# audiosetter.ahk
[Download audiosetter.ahk](./audiosetter.ahk)

Sets the default audio output device when launched.

Intended to fix a problem with Windows not remembering the default audio output settings.

## Dependencies
- nircmd (http://nircmd.nirsoft.net/)
- 7Zip (https://www.7-zip.org/)

_This script automatically downloads the dependencies it requires. 7zip is only needed for extracting the nircmd ZIP file._

## Command Line Arguments
_none_

## Configuration
Initially this script creates an INI file for configuration purposes. The following parameters can be configured:

`[DefaultAudioDevice]/Name`: Name of the audio device to set the default to.

`[DefaultAudioDevice]/ShowMessageBox`: Show the executed nircmd command before executing it in a message box. (Default: `0`, Set to `1` to enable)
