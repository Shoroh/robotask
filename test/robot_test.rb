require 'test_helper'
require './lib/robot'

describe 'RobotInitialTest' do
  it 'can be initializated without params with defaults' do
    robot = Robot.new

    assert robot
    assert_output(/0,0,NORTH/) { robot.report }
  end

  it 'can be initializated with case insensitive directions' do
    %w[west South eAsT nORTh].each do |direction|
      assert_output(Regexp.new("0,0,#{direction.upcase}")) do
        Robot.new(direction: direction).report
      end
    end
  end

  it 'can be initializated with valid params' do
    robot = Robot.new(x: 2, y: 3, direction: 'NORTH')

    assert robot
    assert_output(/2,3,NORTH/) { robot.report }
  end

  it 'can not be initializated with invalid params' do
    exception = assert_raises Robot::InvalidParamsError do
      Robot.new(x: 22, y: -2, direction: 'WRONG_DIRECTION')
    end

    assert_equal 'Invalid Params!', exception.message
  end

  it 'can be initializated and be placed on a custom table' do
    table = Table.new(width: 9, height: 9)
    robot = Robot.new(x: 8, y: 7, direction: 'NORTH', table: table)

    assert robot
    assert_output(/8,7,NORTH/) { robot.report }
  end
end

describe 'RobotCommandsTest' do
  before do
    @robot = Robot.new(x: 0, y: 0, direction: 'NORTH')
  end

  it 'can #move' do
    3.times do
      @robot.move
    end

    assert_output(/0,3,NORTH/) { @robot.report }
  end

  it 'can not #move more than table allows' do
    7.times do
      @robot.move
    end
    assert_output(/0,4,NORTH/) { @robot.report }

    @robot.right

    7.times do
      @robot.move
    end
    assert_output(/4,4,EAST/) { @robot.report }
  end

  it 'can not #move more than table allows' do
    @robot.left

    7.times do
      @robot.move
    end
    assert_output(/0,0,WEST/) { @robot.report }

    @robot.left

    7.times do
      @robot.move
    end
    assert_output(/0,0,SOUTH/) { @robot.report }
  end

  it 'can turn #left' do
    7.times do
      @robot.left
    end

    assert_output(/0,0,EAST/) { @robot.report }
  end

  it 'can turn #right' do
    7.times do
      @robot.right
    end

    assert_output(/0,0,WEST/) { @robot.report }
  end

  it 'complies with the sequence of directions #left' do
    %w[WEST SOUTH EAST NORTH].each do |direction|
      @robot.left
      assert_output(Regexp.new("0,0,#{direction}")) { @robot.report }
    end
  end

  it 'complies with the sequence of directions #right' do
    %w[EAST SOUTH WEST NORTH].each do |direction|
      @robot.right
      assert_output(Regexp.new("0,0,#{direction}")) { @robot.report }
    end
  end

  it 'can #report' do
    @robot.move
    @robot.right
    @robot.move
    @robot.move

    assert_output(/2,1,EAST/) { @robot.report }
  end

  it 'can #reach_report' do
    reach_report = "
      Current Position is:
        x: 0,
        y: 0,
        facing to: NORTH
    "

    assert_output(Regexp.new(reach_report)) { @robot.reach_report }
  end
end
