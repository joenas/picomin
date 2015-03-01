class Picomin < Sinatra::Base

  get '/service/:id/:command.json' do |id, command|
    content_type :json
    service = Service.find(id)
    result = service.do command
    {service: service.to_h, message: result}.to_json
  end

  get '/services.json' do
    content_type :json
    { services: Service.all.map(&:to_h) }.to_json
  end

  get '/*' do
    @services = Service.all
    haml :index
  end
end