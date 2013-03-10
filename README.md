[![Dependency Status](https://gemnasium.com/joenas/picomin.png)](https://gemnasium.com/joenas/picomin)

# Pico sized web admin

Basically I use this at home internally to restart a few services when I'm to lazy to ssh to my media center.


# Usage
```ruby
# Add a service to config/config.rb
service :name     => 'MPD',
        :bin      => 'mpd',
        :pgrep    => 'mpd',
        :grep     => 'pgrep mpd',
        :commands => [:start, :stop, :restart]
```

```bash
# Start the server
$ foreman start -p port
```
