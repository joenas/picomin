service :name     => 'MPD',
        :bin      => 'mpd',
        :pgrep    => '-x mpd',
        :grep     => 'pgrep -x mpd',
        :commands => [:start, :stop, :restart]

service :name     => 'Airplay',
        :bin      => 'shairport',
        :pgrep    => 'shairport',
        :grep     => 'ps aux | grep shairport | grep -v grep',
        :commands => [:start, :stop, :restart]
