module Configuration
  def service(options)
    service = Service.new(options)
    settings.services[service.bin] = service
  end

  def configuration(file)
    eval File.open(file).read
  end
end