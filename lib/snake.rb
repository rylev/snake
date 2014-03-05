require "curses"

class Board
  include Curses

  attr_reader :height, :width, :snake, :win, :apple

  def initialize(height, width)
    @height, @width = height, width * 2
    @win = Window.new(@height, @width, 0, 0)
    @snake = Snake.new(2, 2, "right")
    @apple = Apple.new(10, 15)
    noecho
    @win.nodelay = true
  end

  def tick
    while true
      input = read_input
      move_snake(input)
      detect_collision
      redraw
      sleep 0.5
    end
  end

  def redraw
    refresh_board
    snake.draw(win)
    apple.draw(win)
  end

  private

  def detect_collision
    if apple.position == snake.head
      snake.grow
      apple.new_position(self)
    end
  end

  def refresh_board
    win.refresh
    win.clear
    win.box("#", "#")
  end

  def read_input
    win.getch
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
  attr_reader :positions

  def initialize(initial_x, initial_y, direction)
    @positions, @direction= [[initial_x, initial_y]], direction
  end

  def move_up
    x, y = head
    positions.unshift [x, y - 1]
    move_tail
    @direction = "up"
  end

  def move_down
    x, y = head
    positions.unshift [x, y + 1]
    move_tail
    @direction = "down"
  end

  def move_right
    x, y = head
    positions.unshift [x + 1, y]
    move_tail
    @direction = "right"
  end

  def move_left
    x, y = head
    positions.unshift [x - 1, y]
    move_tail
    @direction = "left"
  end

  def move_forward
    send :"move_#{@direction}"
  end

  def draw(window)
    positions.each do |pos|
      x, y = pos
      window.setpos(y, x)
      window.addstr("+")
    end
  end

  def head
    positions.first
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
end

class Apple
  attr_reader :position

  def initialize(initial_x, initial_y)
    @position = [initial_x, initial_y]
  end

  def new_position(board)
    new_x = (1..board.width - 1).to_a.sample
    new_y = (1..board.height - 1).to_a.sample
    @position = [new_x, new_y]
  end

  def draw(window)
    window.setpos(y, x)
    window.addstr("*")
  end

  def x
    position.first
  end

  def y
    position.last
  end
end

board = Board.new(20, 35)
board.tick