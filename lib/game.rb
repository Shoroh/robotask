require './lib/manipulator'

TITLE = '  The Toy Robot Simulator (c) Shelestov Aleksandr  '.freeze
TITLE_SIZE = TITLE.size.freeze

manipulator = Manipulator.new

puts '-' * TITLE_SIZE
puts TITLE
puts '-' * TITLE_SIZE
puts "

    To start the game please place the toy robot on the table.
    To do this use PLACE command.
    PLACE will put the toy robot on the table in position X,Y
    and facing NORTH, SOUTH, EAST or WEST.
    For example:

    PLACE 1,2,NORTH

    Please keep in mind that the table size is #{manipulator.table.size},
    so available positions must be in the range #{manipulator.table.avalaible_positions}.

    After that extra commands will be available:
    #{manipulator.available_commands}

    Enjoy your game! :)

  "

loop do
  puts '-' * TITLE_SIZE
  print 'input a new command (EXIT to quit): '

  input = gets.strip
  break if input =~ /exit|quit|escape|\q|:q/i

  manipulator.parse(input) unless input.size.zero?
end
