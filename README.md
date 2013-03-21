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

### Convert it, upload it, then destroy the gif and the original file:

```sh
gifify -x recording.mov
```

![http://f.cl.ly/items/1V0b3N4005372w261C0G/output.gif](http://f.cl.ly/items/1V0b3N4005372w261C0G/output.gif)

## License

MIT (See [LICENSE][3])


[1]: https://raw.github.com/jclem/gifify/master/gifify.sh
[2]: https://github.com/cloudapp/cloudapp.rb
[3]: https://raw.github.com/jclem/gifify/master/LICENSE
