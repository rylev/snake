module Snake
  class Snake
    attr_reader :positions, :board

    def initialize(board, initial_position, intial_direction)
      @board, @positions, @direction= board, [initial_position], intial_direction
    end

    def move_up
      if @direction == "down"
        move_down
      else
        positions.unshift Position.new(head.x, head.y - 1)
        move_tail
        @direction = "up"
      end
    end

    def move_down
      if @direction == "up"
        move_up
      else
        positions.unshift Position.new(head.x, head.y + 1)
        move_tail
        @direction = "down"
      end
    end

    def move_right
      if @direction == "left"
        move_left
      else
        positions.unshift Position.new(head.x + 1, head.y)
        move_tail
        @direction = "right"
      end
    end

    def move_left
      if @direction == "right"
        move_right
      else
        positions.unshift Position.new(head.x - 1, head.y)
        move_tail
        @direction = "left"
      end
    end

    def move_forward
      send :"move_#{@direction}"
    end

    def draw
      positions.each do |pos|
        board.window.setpos(pos.y, pos.x)
        board.window.addstr("+")
      end
    end

    def touching_itself?
      tail.uniq.include? head
    end

    def touching_border?
      head.x == board.right_edge || head.x == board.left_edge ||
        head.y == board.top_edge || head.y == board.bottom_edge
    end

    def head
      head, _ = *positions
      head
    end

    def tail
      _, *tail = *positions
      tail
    end

    def grow
      @growing = true
    end

    def growing?
      !!@growing
    end

    def move_tail
      positions.pop unless growing?
      @growing = false
    end

    def eat(apple)
      grow
      apple.new_position
    end
  end
end
