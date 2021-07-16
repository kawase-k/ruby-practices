# frozen_string_literal: true

class Game
  def initialize(score)
    @score = score
  end

  def build_frames(score)
    strings = score.split(',')
    frames = []
    9.times do
      first = strings.shift
      if first == 'X'
        frames << ['X']
      else
        second = strings.shift
        frames << [first, second]
      end
    end
    frames << strings
    frames.map { |frame| Frame.new(*frame) }
  end

  def point
    frames = build_frames(@score)
    point = 0
    frames.each_with_index do |frame, i|
      point += frame.total_score(frames, i)
    end
    point
  end
end
