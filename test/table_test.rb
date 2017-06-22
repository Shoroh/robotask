require 'test_helper'
require './lib/table'

describe 'TableTest' do
  it 'has default dimension after initialization' do
    table = Table.new

    assert_equal table.width, 5
    assert_equal table.height, 5
  end

  it 'can be initializated with custom dimension' do
    table = Table.new(width: 7, height: 9)

    assert_equal table.width, 7
    assert_equal table.height, 9
  end

  it 'allows valid position' do
    table = Table.new

    assert table.allows_position?(x: 2, y: 3)
  end

  it 'does not allow invalid position' do
    table = Table.new

    refute table.allows_position?(x: 12, y: 39)
  end

  it 'should show the #size of the table' do
    table = Table.new(width: 6, height: 7)
    assert_equal '6x7', table.size
  end

  it 'should show #avalaible_positions of the table' do
    table = Table.new(width: 6, height: 7)
    assert_equal 'x: 0-5 and y: 0-6', table.avalaible_positions
  end
end
