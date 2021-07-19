# frozen_string_literal: true

class Game
  def initialize(score)
    @score = score
    @frames = build_frames(score)
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
    frames.map.with_index(0) do |frame_marks, frame_index|
      next_two_marks = [frames[frame_index.next], frames[frame_index.next.next]].compact.flatten.slice(0, 2)
      Frame.new(frame_marks, frame_index, next_two_marks)
    end
  end

  def point
    point = 0
    @frames.each { |frame| point += frame.total_score }
    point
  end
end
