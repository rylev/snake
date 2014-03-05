require "curses"

class Board
  include Curses

  attr_reader :height, :width, :snake, :win, :apple

  def initialize(height, width)
    @height, @width = height, width * 2
    @win = Window.new(@height, @width, 0, 0)
    noecho
    curs_set(0)
    @win.nodelay = true
    set_board
  end

  def set_board
    @snake = Snake.new(2, 2, "right")
    @apple = Apple.new(10, 15)
  end
  alias reset_board set_board

  def tick
    while true
      input = read_input
      move_snake(input)
      if apple.position == snake.head
        snake.grow
        apple.new_position(self)
        redraw
      elsif snake.touching_itself? || snake.touching_border?(self)
        end_game
        reset_board
      else
        redraw
      end
    end
  end

  def redraw
    refresh_board
    snake.draw(win)
    apple.draw(win)
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
    win.setpos(height / 2 - 2, width / 2 - 7)
    win.addstr(string)
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
    win.refresh
    win.clear
  end

  def refresh_board
    clear_board
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

  def touching_itself?
    _, *rest_of_tail = *tail
    rest_of_tail.include?(head)
  end

  def touching_border?(board)
    x, y = head
    x == board.right_edge || x == board.left_edge || y == board.top_edge || y == board.bottom_edge
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