# audio_buffering_demo 🎧

A Flutter app showing how audio files can be downloaded in chunks (buffered) over the internet and played without having to wait for the entire file to be loaded.

Audio can further be cached for a period of time to avoid buffering over the internet every time audio is played.

## Screenshot 📷


<img src="https://raw.githubusercontent.com/Crazelu/audio_buffering_demo/main/screenshots/screen.png" width="270" height="600">

## Drawbacks 🫣

- There's audible lag/jank when transitioning from one buffer to another. This can be improved with logic I believe (figuring out the exact duration to skip to).

- Since there's no way to tell the duration of the entire audio without downloading all of it, some jank in the slider movement is observed as more chunks are downloaded and the slider has to adjust.
