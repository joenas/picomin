class Picomin < Sinatra::Base

  get '/service/:service/:command.json' do |service, command|
    content_type :json
    service = settings.services[service]
    msg = service.do command
    info = service.info.merge({:message => msg})
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