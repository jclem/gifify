# gifify

gifify is a shell script for converting screen recordings into GIFs that can be embedded conveniently into places like Campfire chatrooms or GitHub issues and pull requests.

## Installation

```sh
brew install gifify
```

## Usage

Given a file `recording.mov`:

### Convert it into recording.mov.gif:

```sh
gifify recording.mov
```

### Convert it into new_gif.gif:

```sh
gifify -o new_gif recording.mov
```

### Convert it, cropping the top left corner:

```sh
gifify -c 100:100 recording.mov
```

### Convert it, and upload it to CloudApp:

```sh
gifify -u recording.mov
```

### Convert it, upload it, and output at 60 frames per second:

```sh
gifify -r 60 -u recording.mov
```

### Convert it, upload it, and output at 30 frames per second at 2x speed:

```sh
gifify -r 30 -s 2 -u recording.mov
```

### Convert it, upload it, and output at 10 frames per second at 6x speed:

```sh
gifify -s 6 -u recording.mov
```

### Convert it, upload it, then destroy the gif and the original file:

```sh
gifify -ux recording.mov
```

![http://f.cl.ly/items/1V0b3N4005372w261C0G/output.gif](http://f.cl.ly/items/1V0b3N4005372w261C0G/output.gif)

## Regarding framerates:

GIF renderers typically cap the framerate somewhere between 60 and 100 frames per second. If you choose to change the framerate or playback speed of your GIFs, ensure your framerates do not exceed 60 frames per second to ensure your GIFs play consistently. An easy way to compute this is to ensure that FPS  (`-r`) x SPEED (`-s`) is not greater than 60.

## License

MIT (See [LICENSE][3])


[1]: https://raw.github.com/jclem/gifify/master/gifify.sh
[2]: https://github.com/cloudapp/cloudapp.rb
[3]: https://raw.github.com/jclem/gifify/master/LICENSE
