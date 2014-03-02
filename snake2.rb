require "curses"

class Board
  include Curses

  attr_reader :height, :width, :snake, :win

  def initialize(height, width)
    @height, @width = height, width
    @snake = Snake.new(2, 2)
    @win = Window.new(height, width * 2, 0, 0)
    win.nodelay = true
    win.box("#", "#")
  end

  def tick
    while true
      # input = read_input
      snake.move_right
      redraw
      sleep 1
    end
  end

  def redraw
    win.refresh
    win.clear
    win.box("#", "#")
    snake.positions.each do |pos|
      x, y = pos
      win.setpos(y, x)
      win.addstr("+")
    end
  end

  private

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
    end
  end
end

class Snake
  attr_reader :positions

  def initialize(initial_x, initial_y)
    @positions = [[initial_x, initial_y]]
  end

  def add_to_board(positions_map)
    positions_map = positions_map.dup
    positions.each do |x, y|
      positions_map[[x,y]] = "+ "
    end
    positions_map
  end

  def move_up
    x, y = head
    positions.unshift [x, y + 1]
    positions.pop
    positions
  end

  def move_down
    x, y = head
    positions.unshift [x, y - 1]
    positions.pop
    positions
  end

  def move_right
    x, y = head
    positions.unshift [x + 1, y]
    positions.pop
    positions
  end

  def move_left
    x, y = head
    positions.unshift [x - 1, y]
    positions.pop
    positions
  end

  def head
    positions.first
  end
end

board = Board.new(20, 35)
board.tick