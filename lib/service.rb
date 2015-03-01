class Service < OpenStruct

  PS_CMD = "ps -eo comm,pid | grep %s"

  def self.all
    @all ||= YAML.load_file(File.join(__dir__, "../config/services.yml")).map do |data|
      Service.new(data)
    end
  end

  def self.find(id)
    all.find {|service|service.id.to_i == id.to_i} or raise StandardError, "Service not found"
  end


  def running?
    !ps_cmd.empty?
  end

  def to_h
    {
      id:       id,
      running:  running?,
      name:     name,
      commands: {
        running: commands_running,
        not_running: commands_not_running,
      }
    }
  end

  def pid
    ps_cmd.match(/(\d*)\n/){|match| match[1]}
  end

  def do(command)
    begin
      return "please set 'commands' for this service" unless commands
      return "command '#{command}' not allowed!" unless allowed?(command)
      cmd = get_command(command)
      `#{cmd % {pid: pid}}`
    rescue Errno::ENOENT => e
      e.message
    end
  end

  private

  def ps_cmd
    `#{PS_CMD % bin}`
  end

  def get_command(cmd)
    if running?
      commands['running'].fetch(cmd)
    else
      commands['not_running'].fetch(cmd)
    end
  end

  def commands_running
    commands['running'].keys
  end

  def commands_not_running
    commands['not_running'].keys
  end

  def allowed?(command)
    (running? && commands_running.include?(command)) ||
    (!running? && commands_not_running.include?(command))
  end
end