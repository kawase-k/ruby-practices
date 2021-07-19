# frozen_string_literal: true

class Frame
  attr_reader :first_shot, :second_shot

  def initialize(current_marks, frame_index, next_two_marks = nil)
    first_mark, second_mark, third_mark = *current_marks
    @first_shot  = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot  = Shot.new(third_mark)
    @frame_index = frame_index
    next_mark, next_next_mark = *next_two_marks
    @next_shot      = Shot.new(next_mark)
    @next_next_shot = Shot.new(next_next_mark)
  end

  def total_score
    if last_frame?
      scores
    elsif strike?
      add_strike_scores
    elsif spare?
      add_spare_scores
    else
      scores
    end
  end

  private

  def scores
    [@first_shot.score, @second_shot.score, @third_shot.score].sum
  end

  def strike?
    @first_shot.score == 10
  end

  def spare?
    [@first_shot.score, @second_shot.score].sum == 10 && !strike?
  end

  def add_strike_scores
    current_score    = scores
    next_total_score = [@next_shot.score, @next_next_shot.score].sum

    current_score + next_total_score
  end

  def add_spare_scores
    current_score = scores
    next_score    = @next_shot.score

    current_score + next_score
  end

  def last_frame?
    @frame_index == 9
  end
end
