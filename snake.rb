class Shoes::App::Snake
  attr_reader :head, :app, :direction, :tail_pieces
  def initialize(app)
    @head = Shoes::App::Head.new(app, 10, 10)
    @app = app
    @tail_pieces = []
  end

  def grow
    @tail_pieces = pieces.map(&:add_tail)
    send :"move_#{direction}"
  end

  def pieces
    [head] + tail_pieces
  end

  def move_right
    return if direction == :right || direction == :left
    animation do
      head.move_right
      @tail_pieces = tail_pieces.map(&:increment)
    end
    @direction = :right
  end

  def move_left
    return if direction == :left || direction == :right
    animation do
      head.move_left
      @tail_pieces = tail_pieces.map(&:increment)
    end
    @direction = :left
  end

  def move_down
    return if direction == :down || direction == :up
    animation do
      head.move_down
      @tail_pieces = tail_pieces.map(&:increment)
    end
    @direction = :down
  end

  def move_up
    return if direction == :up || direction == :down
    animation do
      head.move_up
      @tail_pieces = tail_pieces.map(&:increment)
    end
    @direction = :up
  end

  def animation(&block)
    @animation.stop if @animation
    @animation = app.animate do
      app.para @tail_pieces.count
      yield
    end
  end
end

class Shoes::App::Piece
  require 'forwardable'
  extend Forwardable

  def_delegator :shape, :remove
  attr_reader :app, :x, :y, :leading_neighbor, :trailing_neighbor, :shape
  def initialize(app, x, y, leading_neighbor)
    @app = app
    @x = x
    @y = y
    @leading_neighbor = leading_neighbor
    @trailing_neighbor = nil
    draw
  end

  def draw
    @shape = app.rect(left: x,top: y, height: 5, width: 5)
  end

  def add_tail
    return @trailing_neighbor if @trailing_neighbor
    @trailing_neighbor = Shoes::App::Piece.new(app, x, y, self)
  end

  def increment
    @x, @y = leading_neighbor.x, leading_neighbor.y
    remove
    draw
    self
  end
end

class Shoes::App::Head < Shoes::App::Piece
  attr_accessor :direction
  def initialize(app, x, y)
    @app = app
    @x = x
    @y = y
    @leading_neighbor = nil
    @trailing_neighbor = nil
    draw
  end

  def move_right
    @x = x + 1
    remove
    draw
  end

  def move_left
    @x = x - 1
    remove
    draw
  end

  def move_up
    @y = y - 1
    remove
    draw
  end

  def move_down
    @y = y + 1
    remove
    draw
  end
end

Shoes.app do
  window title: "Dude" do
    # oval(left: 40, top: 40, width: 2)
    snake = Snake.new(self)
    snake.move_right
    keypress do |k|
      case k
      when :left
        snake.move_left
      when :right
        snake.move_right
      when :up
        snake.move_up
      when :down
        snake.move_down
      when "j"
        snake.grow
      end
    end
  end
end
