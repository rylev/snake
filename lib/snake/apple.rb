module Snake
  class Apple
    attr_reader :position, :board

    def initialize(board, initial_position)
      @board, @position = board, initial_position
    end

    def new_position
      new_x = ((board.left_edge + 1)..(board.right_edge - 1)).to_a.sample
      new_y = ((board.top_edge + 1)..(board.bottom_edge - 1)).to_a.sample
      @position = Position.new(new_x, new_y)
    end

    def draw
      board.window.setpos(y, x)
      board.window.addstr("*")
    end

    def x
      position.x
    end

    def y
      position.y
    end
  end
end
