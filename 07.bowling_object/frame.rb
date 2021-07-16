# frozen_string_literal: true

class Frame
  attr_reader :first_shot, :second_shot

  def initialize(first_mark, second_mark = nil, third_mark = nil)
    @first_shot  = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot  = Shot.new(third_mark)
  end

  def scores
    [@first_shot.score, @second_shot.score, @third_shot.score].sum
  end

  def strike?
    @first_shot.score == 10
  end

  def spare?
    [@first_shot.score, @second_shot.score].sum == 10 && !strike?
  end

  def add_strike_scores(frames, index)
    now_frame       = scores
    next_frame      = frames[index + 1]
    next_next_frame = frames[index + 2]
    if before_last_frame?(index)
      now_frame + [next_frame.first_shot.score, next_frame.second_shot.score].sum
    elsif next_frame.strike?
      now_frame + [next_frame.scores, next_next_frame.first_shot.score].sum
    else
      now_frame + [next_frame.first_shot.score, next_frame.second_shot.score].sum
    end
  end

  def add_spare_scores(frames, index)
    now_frame  = scores
    next_frame = frames[index + 1]
    now_frame + next_frame.first_shot.score
  end

  # 9フレーム目かどうか
  def before_last_frame?(index)
    index == 8
  end

  # 10フレーム目かどうか
  def last_frame?(index)
    index == 9
  end

  def total_score(frames, index)
    if last_frame?(index)
      scores
    elsif strike?
      add_strike_scores(frames, index)
    elsif spare?
      add_spare_scores(frames, index)
    else
      scores
    end
  end
end
