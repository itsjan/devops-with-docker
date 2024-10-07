## Mounting the current folder as a volume


We mount our current folder as /mydir in our container, overwriting everything that we have put in that folder in our Dockerfile.

```bash
docker run -v "$(pwd):/mydir" yt-dlp 'https://www.youtube.com/watch?v=DptFY_MszQs'
```

In our yt-dlp we wanted to mount the whole directory since the files are fairly randomly named. 

### Mounting a single file

If we wish to create a volume with only a single file we could also do that by pointing to it. For example -v "$(pwd)/material.md:/mydir/material.md" this way we could edit the material.md locally and have it change in the container (and vice versa). Note also that -v creates a directory if the file does not exist.
