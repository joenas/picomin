class Service < OpenStruct

  PS_CMD = "ps -eo comm,pid | grep %s"

  def self.all
    @all ||= YAML.load_file(File.join(__dir__, "../config/services.yaml")).map do |data|
      Service.new(data)
    end
  end

  def self.find(id)
    all.find {|service|service.id.to_i == id.to_i} or raise StandardError, "Service not found"
  end


  def running?
    !`#{PS_CMD % bin}`.empty?
  end

  def to_h
    {
      id:       id,
      running:  running?,
      name:     name
    }
  end

  def do(command)
    begin
      return "please set 'commands' for this service" unless commands
      return "command '#{command}' not allowed!" unless (commands.include? command)
      `service #{bin} #{command}`
    rescue Errno::ENOENT => e
      e.message
    end
  end
end