# Powershell Google STT

This powershell module gets text from audio files in Powershell using [Google's Speech-to-Text API](https://cloud.google.com/speech-to-text/)

To use this module, install it from the [Powershell Gallery](https://www.powershellgallery.com/packages/powershell-google-stt);

```
Install-Module -Name powershell-google-stt
```

Add an environment variable `GOOGLE_API_KEY_STT` and set the value to a valid API key.

Then, in Powershell, run `Start-GoogleSTT 'path to file'`

## Tips

If you run into errors with the audio file being too large or too long (max 1 minute), you can use this ffmpeg command to easily split the audio into 30s (or however long) chunks:

`ffmpeg -i '.\my audio file.wav' -f segment -segment_time 30 -c copy out%03d.wav`

Then you could loop through each file and process them if necessary or choose the ones you want transcoded.