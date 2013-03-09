class Service
  attr_reader :name, :bin

  def initialize(options)
    options.each do |key, value|
      instance_variable_set("@#{key}", value)
    end
  end

  def running?
    return false unless @pgrep || @grep
    %x[#{@grep}] != '' || %x[pgrep #{@pgrep}] != ''
  end

  def info
    {
      running: self.running?,
      bin:     @bin,
      name:    @name
    }
  end

  def do(command)
    return "please set 'commands' for this service" unless @commands
    return "command '#{command}' not allowed!" unless (@commands.include? command.to_sym)
    `service #{@bin} #{command}`
  end
end