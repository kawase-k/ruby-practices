# frozen_string_literal: true

require './shot'
require './frame'
require './game'

score = ARGV[0]
p Game.new(score).point
