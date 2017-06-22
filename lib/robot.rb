require_relative 'table'

# The main class
class Robot
  # Let's create our own Error Class
  class InvalidParamsError < StandardError
    def message
      'Invalid Params!'
    end
  end

  DIRECTIONS = {
    'WEST'  => { x: -1, y: 0 },
    'NORTH' => { x: 0, y: 1 },
    'EAST'  => { x: 1, y: 0 },
    'SOUTH' => { x: 0, y: -1 }
    # Here we can extend it by adding more directions like:
    # SOUTH_WEST: { x: -1, y: -1 }
    # What about 3 dimensions? Easy, it works like a vector:
    # SOUTH_WEST_BACK: { x: -1, y: -1, z: +1 }
    # SOUTH_WEST_FRONT: { x: -1, y: -1, z: -1 }
  }.freeze

  def initialize(x: 0, y: 0, direction: 'NORTH', table: Table.new)
    @table = table
    # To init the first position of our Robot
    self.current_position = { x: x.to_i, y: y.to_i }
    self.facing = direction.upcase
    raise InvalidParamsError until current_position && facing
  end

  # Some public API:

  # Let's Move It Forward!
  def move
    new_pos = current_position.keys.each_with_object({}) do |axis, pos|
      pos[axis] = current_position[axis] + DIRECTIONS[facing][axis]
    end
    self.current_position = new_pos
  end

  def left
    turn(:left)
  end

  def right
    turn(:right)
  end

  def report
    puts "#{current_position[:x]},#{current_position[:y]},#{facing}"
  end

  def reach_report
    puts "
      Current Position is:
        x: #{current_position[:x]},
        y: #{current_position[:y]},
        facing to: #{facing}
    "
  end

  private

  attr_reader :current_position, :facing

  def current_position=(position)
    @current_position = position if valid_position?(position)
  end

  def facing=(facing)
    @facing = facing if DIRECTIONS.keys.include?(facing)
  end

  def valid_position?(position)
    @table.allows_position?(position)
  end

  def turn(direction)
    increament = direction == :right ? 1 : -1
    self.facing =
      DIRECTIONS.keys[
        (DIRECTIONS.keys.index(facing) + increament) % DIRECTIONS.size
      ]
  end
end
