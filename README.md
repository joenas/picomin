[![Dependency Status](https://gemnasium.com/joenas/picomin.png)](https://gemnasium.com/joenas/picomin)

# Pico sized web admin

Basically I use this at home to restart a few services when I'm to lazy to ssh to my media center.


# Usage
```yaml
# Add services to config/config.yml
---
-
  id: 1
  name: Sixad
  bin: sixad
  commands:
    running:
      stop: sudo service sixad stop
      restart: sudo service sixad restart
    not_running:
      start: sudo service sixad start
-
  id: 2
  name: MPD
  bin: mpd
  commands:
    running:
      stop: kill -15 %{pid}
    not_running:
```

```bash
# Start the server
$ thin start
```

# Foreman

```bash
$ gem install foreman
$ sudo $(rbenv which foreman) export upstart /etc/init -a picomin -u YOURUSER -l SOMELOGPATH
# or rbenv-sudo if you have
```
