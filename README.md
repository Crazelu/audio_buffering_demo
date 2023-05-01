# audio_buffering_demo 🎧

A Flutter app showing how audio files can be downloaded in chunks (buffered) over the internet and played without having to wait for the entire file to be loaded.

Audio can further be cached for a period of time to avoid buffering over the internet every time audio is played.

## Screenshot 📷


<img src="https://raw.githubusercontent.com/Crazelu/audio_buffering_demo/main/screenshots/screen.png" width="270" height="600">

## How it works ⚙️

Using the HTTP verb HEAD, we retrieve metadata headers for the audio including the `Content-Length` which says how large the audio is in bytes and `Accept-Ranges` which says whether the audio content can be downloaded in chunks.

If `Accept-Ranges == bytes`, then the audio content can be downloaded in chunks and we can proceed to buffer! Otherwise, the entire audio content is downloaded in one pass and then played.

In this demo, there's a constant maximum number of chunks. An algorithm to compute this based on the `Content-Length` would be better so smaller files are not downloaded in far too small chunks that are not necessary. However, for this demo, the audio files are about 10MB large and with a maximum chunk count of 10, we'll be downloading 10 chunks of each audio content and appending those chunks to their respective files.

The chunk download has retries enabled in case something goes wrong in the first few trials of downloading the chunk. When the number of retries are exceeded, buffering stops.

ValueNotifiers are used in each layer to communicate the state of the downloaded audio content. This notification eventually reaches the UI which triggers a resubscription to the necessary audio player streams.

## Drawbacks 🫣

- There's audible lag/jank when transitioning from one buffer to another. This can be improved with logic I believe (figuring out the exact duration to skip to).

- Since there's no way to tell the duration of the entire audio without downloading all of it, some jank in the slider movement is observed as more chunks are downloaded and the slider has to adjust.
