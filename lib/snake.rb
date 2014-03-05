require "curses"

class Position
  attr_reader :x, :y
  def initialize(x, y)
    @x, @y = x, y
  end

  def ==(other)
    other.x == x && other.y == y
  end
end
class Board
  include Curses

  attr_reader :height, :width, :snake, :window, :apple

  def initialize(height, width)
    @height, @width = height, width * 2
    @window = initialize_window
    @window.nodelay = true
    set_board
  end

  def initialize_window
    noecho
    curs_set(0)
    Window.new(@height, @width, 0, 0)
  end

  def set_board
    @snake = Snake.new(self, Position.new(2, 2), "right")
    @apple = Apple.new(self, Position.new(10, 15))
  end
  alias reset_board set_board

  def tick
    while true
      input = read_input
      move_snake(input)
      if apple.position == snake.head
        snake.eat(apple)
        redraw
      elsif snake.touching_itself? || snake.touching_border?
        end_game
        reset_board
      else
        redraw
      end
    end
  end

  def redraw
    refresh_board
    snake.draw
    apple.draw
    sleep 0.2
  end

  def end_game(counter = 10)
    counter.times do |i|
      clear_board
      center("Game Over! Restart in #{10 - i}")
      sleep 1
    end
  end

  def center(string)
    window.setpos(height / 2 - 2, width / 2 - 7)
    window.addstr(string)
  end

  def top_edge
    0
  end

  def bottom_edge
    height - 1
  end

  def left_edge
    0
  end

  def right_edge
    width - 1
  end

  private

  def clear_board
    window.refresh
    window.clear
  end

  def refresh_board
    clear_board
    window.box("#", "#")
  end

  def read_input
    window.getch
  end

  def move_snake(input_char)
    case input_char
    when "a"
      snake.move_left
    when "d"
      snake.move_right
    when "w"
      snake.move_up
    when "s"
      snake.move_down
    else
      snake.move_forward
    end
  end
end

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

board = Board.new(20, 35)
board.tick