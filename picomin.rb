class Picomin < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload './config/routes'
    also_reload './lib/service'
  end

  # Setup
  set :title, 'Picomin'
  set :root, File.dirname(__FILE__)
  set :views, Proc.new { File.join(root, "app/views") }
  enable :logging

  # assets
  register Sinatra::AssetPack

  assets {
    prebuild true
    serve '/img', from: 'app/images'    # Optional
    js_compression  :yui, :munge => true
    js :vendor, [
      '/js/vendor/jquery.js',
      '/js/vendor/underscore.js',
      '/js/vendor/*.js'
    ]
    js :app, [ '/js/app/*.js' ]
    css :app, [ '/css/*.css' ]
  }

  require './config/routes'
end