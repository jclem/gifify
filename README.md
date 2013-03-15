# gifify

gifify is a shell scriopt for converting screen recordings into GIFs that can be embedded conveniently into places like Campfire chatrooms or GitHub issues and pull requests.

## Installation

Download the [gifify script][1] and make it available in your `PATH`.

```sh
curl -o /usr/local/bin/gifify -O https://raw.github.com/jclem/gifify/master/gifify.sh && \
  chmod +x /usr/local/bin/gifify
```

## Usage

Given a file `recording.mov` that was recorded with Quicktime:

### Convert it into output.gif:

```sh
gifify recording.mov
```

### Convert it into new_gif.gif

```sh
gifify -o new_gif recording.mov
```

### Convert it, cropping the top left corner:

```sh
gifify -c 100:100 recording.mov
```

### Convert it, and upload it to CloudApp*:

```sh
gifify -u recording.mov
```

### Convert it, upload it, then destroy the gif*:

```sh
gifify -ux recording.mov
```

\* Requires the [CloudApp gem][2]

## License

MIT (See [LICENSE][3])


[1]: https://raw.github.com/jclem/gifify/master/gifify.sh
[2]: https://github.com/cloudapp/cloudapp.rb
[3]: https://raw.github.com/jclem/gifify/master/LICENSE