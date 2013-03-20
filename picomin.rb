class Picomin < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload './config/routes'
  end

  # Setup
  set :title, 'Picomin'
  set :root, File.dirname(__FILE__)
  set :views, Proc.new { File.join(root, "app/views") }
  set :conf_file, Proc.new { File.join(root, "config/config.rb") }
  set :services, {}
  enable :logging

  extend Configuration
  configuration conf_file

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