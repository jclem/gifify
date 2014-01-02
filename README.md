# gifify

gifify is a shell script for converting screen recordings into GIFs that can be embedded conveniently into places like Campfire chatrooms or GitHub issues and pull requests.

## Installation

Download the [gifify script][1] and make it available in your `PATH`.

```sh
curl -o /usr/local/bin/gifify -O https://raw.github.com/jclem/gifify/master/gifify.sh && \
  chmod +x /usr/local/bin/gifify
```

## Dependencies

1. [CloudApp gem][2]: `gem install cloudapp`
2. ffmpeg: `brew install ffmpeg`
3. imagemagick: `brew install imagemagick`

## Usage

Given a file `recording.mov`:

### Convert it into recording.mov.gif, and upload it to CloudApp:

```sh
gifify recording.mov
```

### Convert it into new_gif.gif, and upload it to CloudApp

```sh
gifify -o new_gif recording.mov
```

### Convert it, cropping the top left corner, and upload:

```sh
gifify -c 100:100 recording.mov
```

### Convert it, and do not upload it to CloudApp:

```sh
gifify -n recording.mov
```

### Convert it, do not upload, and output at 60 frames per second:

```sh
gifify -r 60 -n recording.mov
```

### Convert it, do not upload, and output at 30 frames per second at 2x speed:

```sh
gifify -r 30 -s 2 -n recording.mov
```

### Convert it, do not upload, and output at 10 frames per second at 6x speed:

```sh
gifify -s 6 -n recording.mov
```

### Convert it, upload it, then destroy the gif and the original file:

```sh
gifify -x recording.mov
```

![http://f.cl.ly/items/1V0b3N4005372w261C0G/output.gif](http://f.cl.ly/items/1V0b3N4005372w261C0G/output.gif)

## Regarding framerates:

GIF renderers typically cap the framerate somewhere between 60 and 100 frames per second. If you choose to change the framerate or playback speed of your GIFs, ensure your framerates do not exceed 60 frames per second to ensure your GIFs play consistently. An easy way to compute this is to ensure that FPS  (`-r`) x SPEED (`-s`) is not greater than 60.

## License

MIT (See [LICENSE][3])


[1]: https://raw.github.com/jclem/gifify/master/gifify.sh
[2]: https://github.com/cloudapp/cloudapp.rb
[3]: https://raw.github.com/jclem/gifify/master/LICENSE
