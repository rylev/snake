class ScoreKeeper
  attr_reader :score

  def initialize
    reset
  end

  def increment
    @score += 1
  end

  def reset
    @score = 0
  end
end
