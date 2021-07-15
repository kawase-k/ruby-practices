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
    frames.map {|frame| Frame.new(*frame)}
  end

  def point
    frames = build_frames(@score)
    point = 0
    frames.each_with_index do |frame, i|
      if frame.last_frame(i)
        point += frame.scores
      elsif frame.strike?
        point += frame.add_strike_scores(frames, i)
      elsif frame.spare?
        point += frame.add_spare_scores(frames, i)
      else
        point += frame.scores
      end
    end
    p point
  end
end
