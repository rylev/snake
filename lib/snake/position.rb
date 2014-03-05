module Snake
  class Position
    attr_reader :x, :y
    def initialize(x, y)
      @x, @y = x, y
    end

    def ==(other)
      other.x == x && other.y == y
    end
  end
end