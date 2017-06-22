require_relative 'table'
require_relative 'robot'

# We'll use it to parse users inputs
# This is a kind of a Router and a Controller at the same time :)
class Manipulator
  attr_reader :robot, :table, :dev_mode

  def initialize(dev_mode: false)
    @dev_mode = dev_mode
    @table = Table.new
    @robot = nil
  end

  def parse(command)
    parse_command(command)
  rescue NoMethodError
    puts 'Place the Robot first!'
  rescue Robot::InvalidParamsError => e
    puts e.message
  rescue => e
    puts dev_mode ? "#{e.message}, #{e.backtrace}" : 'Something went wrong!'
  end

  def available_commands
    available_methods.map(&:upcase).sort.join(', ')
  end

  private

  def parse_command(command)
    command.gsub!(/\s*/, '')
    case command
    when /^PLACE(\d),(\d),(NORTH|EAST|WEST|SOUTH)$/i
      create_robot(Regexp.last_match)
    when reg_exp_available_methods
      @robot.public_send(Regexp.last_match[1])
    else
      puts "The Command wasn't recognized! Try again!"
    end
  end

  def create_robot(params)
    if @robot
      puts 'The Robot is already placed!'
    else
      @robot = Robot.new(
        x: params[1],
        y: params[2],
        direction: params[3],
        table: table
      )
    end
  end

  def reg_exp_available_methods
    @reg_exp_available_methods ||= Regexp.new(
      '^(' + available_methods.join('|') + ')$',
      Regexp::IGNORECASE
    )
  end

  def available_methods
    @available_methods ||= Robot.instance_methods(false).map(&:to_s)
  end
end
