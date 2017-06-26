require 'test_helper'
require './lib/manipulator'

describe 'ManipulatorTest' do
  it 'can be initialized in development mode' do
    manipulator = Manipulator.new(dev_mode: true)

    assert manipulator.dev_mode
  end

  it 'should show public #available_commands' do
    # Just a stub for our tests
    Robot.stub(:instance_methods, %i[left move report right]) do
      manipulator = Manipulator.new
      assert_equal 'LEFT, MOVE, REPORT, RIGHT', manipulator.available_commands
    end
  end
end

describe 'Manipulator#parseTest' do
  before do
    @manipulator = Manipulator.new
  end

  [
    'PLACE 2,3,NORTH',
    '  Place 2, 3, North',
    'placE 2 ,3, nortH   '
  ].each do |command|
    it "should #parse #{command} command and still able to create a robot" do
      @manipulator.parse(command)

      assert @manipulator.robot
      assert_output(/2,3,NORTH/) { @manipulator.robot.report }
    end
  end

  it 'should show an error message when something really goes wrong' do
    # Use this stub to test some error
    raises_exception = -> { raise StandardError }
    Robot.stub(:new, raises_exception) do
      message = /Something went wrong!/
      assert_output(message) { @manipulator.parse('place 2,3,NORTH') }
      refute @manipulator.robot
    end
  end

  it 'shows an error if position is out of range' do
    message = /Invalid Params!/
    assert_output(message) { @manipulator.parse('place 9,3,NORTH') }
  end

  it 'shows a message if the Robot is already placed' do
    message = /The Robot is already placed!/
    assert_output(message) do
      @manipulator.parse('place 0,0,NORTH')
      @manipulator.parse('place 1,2,NORTH')
    end
  end

  it 'should show an error message when command is invalid' do
    message = /The Command wasn't recognized! Try again!/
    assert_output(message) { @manipulator.parse('some_wrong_command') }
    refute @manipulator.robot
  end

  it 'should #parse available_commands and execute the current command' do
    @manipulator.parse('place 0,0,North')

    %w[move rIGHT right Right MOVE left].each do |command|
      @manipulator.parse(command)
    end

    assert_output(/0,1,SOUTH/) { @manipulator.robot.report }
  end

  it 'should show a message if the Robot is not placed yet' do
    %w[move right left report].each do |command|
      refute @manipulator.robot
      assert_output(/Place the Robot first!/) { @manipulator.parse(command) }
    end
  end
end
