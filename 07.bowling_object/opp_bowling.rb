require './shot'
require './frame'
require './game'

score = ARGV[0]
Game.new(score).point
