# gifify

gifify is a shell script for converting screen recordings into GIFs that can be
embedded conveniently into places like Slack channels or GitHub issues and pull
requests.

## Installation

```sh
brew install gifify
```

## Usage

Given a file `recording.mov`:

- Convert it into recording.mov.gif:

```sh
gifify recording.mov
```

- Convert it into new_gif.gif:

```sh
gifify -o new_gif recording.mov
```

- Convert it, cropping the top left corner:

```sh
gifify -c 100:100 recording.mov
```

- Convert it and output at 60 frames per second:

```sh
gifify -r 60 recording.mov
```

- Convert it and output at 30 frames per second at 2x speed:

```sh
gifify -r 30@2 recording.mov
```

## Regarding framerates:

GIF renderers typically cap the framerate somewhere between 60 and 100 frames
per second. If you choose to change the framerate or playback speed of your
GIFs, ensure your framerates do not exceed 60 frames per second to ensure your
GIFs play consistently. An easy way to compute this is to ensure that FPS x
SPEED is not greater than 60.

## License

MIT (See [LICENSE][3])


[1]: https://raw.github.com/jclem/gifify/master/gifify.sh
[2]: https://github.com/cloudapp/cloudapp.rb
[3]: https://raw.github.com/jclem/gifify/master/LICENSE
