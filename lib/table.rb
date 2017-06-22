# This Class we use to store the table properties
# and to validate available positions
class Table
  attr_reader :width, :height

  def initialize(width: 5, height: 5)
    @width = width
    @height = height
  end

  def size
    "#{width}x#{height}"
  end

  def avalaible_positions
    "x: 0-#{width - 1} and y: 0-#{height - 1}"
  end

  def allows_position?(position)
    (0...width).cover?(position[:x]) && (0...height).cover?(position[:y])
  end
end
