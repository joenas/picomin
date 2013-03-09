class Picomin < Sinatra::Base
  # Routes
  get %r{/js/(application|app.min.js)} do
    coffee :'../assets/js/application'
  end

  get '/service/:service/:command.json' do |service, command|
    content_type :json

    service = settings.services[service]
    msg = service.do command
    info = service.info.merge({:message => msg})

    broadcast('/foo', { :text => "#{service.name} #{command}", :action => "service"} )
    info.to_json
  end

  get '/services.json' do
    content_type :json

    services = {}
    settings.services.each { |name, service| services[name]= service.info  }
    { services: services }.to_json
  end

  get '/*' do
    @services = settings.services
    haml :index
  end
end