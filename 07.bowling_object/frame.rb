class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  def initialize(first_mark, second_mark = nil, third_mark = nil)
    @first_shot  = first_mark
    @second_shot = second_mark
    @third_shot  = third_mark
  end

  def frames
    [first_shot, second_shot, third_shot.to_i].sum
  end

  def strike?
    first_shot == 10
  end

  def spare?
    [first_shot, second_shot].sum == 10 && !strike?
  end
end
