require "curses"

class Board
  include Curses

  attr_reader :height, :width, :snake, :win
  attr_accessor :map

  def initialize(height, width)
    # Curses.init_screen()
    @height, @width = height, width
    @map = {}
    @snake = Snake.new(2, 2)
    @win = Window.new(height, width, 0, 0)
    win.nodelay = true
    initialize_borders!
    @fresh_map = map.dup
  end

  def tick
    while true
      # input = read_input
      # move_snake(input)
      self.map = snake.add_to_board(fresh_map)
      redraw
      sleep 1
    end
  end

  def redraw
    win.refresh
    map.each do |k, v|
      setpos(*k)
      win.addstr(v)
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

  def fresh_map
    @fresh_map
  end

  def initialize_borders!
    top; bottom; left; right
  end

  def top
    @top ||= width.times.map { |i| map[[i, 0]] = "##"}
  end

  def bottom
    @bottom ||= width.times.map { |i| map[[i, (height - 1)]] = "##" }
  end

  def left
    @left ||= height.times.map {|i| map[[0, i]] = "# " }
  end

  def right
    @right ||= height.times.map { |i| map[[width - 1, i]] = "#\n" }
  end

  # def draw
  #   print "\\r" + to_s
  # end
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