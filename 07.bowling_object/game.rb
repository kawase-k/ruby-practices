# frozen_string_literal: true

class Game
  attr_reader :scores

  def initialize(scores)
    @scores = scores
  end

  def create_shot_object(scores)
    strings = scores.chars
    strings.map do |s|
      shot = Shot.new(s)
      shot.convert_to_int
    end
  end

  def build_frames(scores)
    integers = create_shot_object(scores)
    frames = []
    9.times do
      first = integers.shift
      if first == 10
        frames << [10]
      else
        second = integers.shift
        frames << [first, second]
      end
    end
    frames << integers
  end

  def point
    frames = build_frames(scores)
    point  = 0
    9.times do |i|
      frame = Frame.new(*frames[i])
      point += if frame.strike? && frames[i.next] == [10]
                 20 + frames[i + 2][0] || 20 + frames[i + 1][0..1]
               elsif frame.strike?
                 10 + frames[i + 1][0..1].sum
               elsif frame.spare?
                 10 + frames[i + 1][0]
               else
                 frame.frames
               end
    end
    last_frame = Frame.new(*frames.last)
    point += last_frame.frames
  end
end
