# frozen_string_literal: true

require 'minitest/autorun'
require './shot'
require './frame'
require './game'

MiniTest::Unit.autorun

class TestOppBowling < MiniTest::Unit::TestCase
  def setup
    @game1 = Game.new('6390038273X9180X645')
    @game2 = Game.new('6390038273X9180XXXX')
    @game3 = Game.new('0X150000XXX518104')
    @game4 = Game.new('6390038273X9180XX00')
    @game5 = Game.new('XXXXXXXXXXXX')
  end

  def test_oppbowling
    assert_equal 139, @game1.point
    assert_equal 164, @game2.point
    assert_equal 107, @game3.point
    assert_equal 134, @game4.point
    assert_equal 300, @game5.point
  end
end
