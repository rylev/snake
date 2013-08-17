class Shoes::App::Snake
  attr_reader :shape, :app, :direction
  def initialize(rec, app)
    @shape = rec
    @app = app
  end

  def move_right
    return if direction == :right
    animation do
      shape.move(x + 1, y)
    end
    @direction = :right
  end

  def grow
    shape.append(app.rect(x,y, 1))
  end

  def move_left
    return if direction == :left
    animation do
      shape.move(x - 1, y)
    end
    @direction = :left
  end

  def move_down
    return if direction == :down
    animation do
      shape.move(x, y + 1)
    end
    @direction = :down
  end

  def move_up
    return if direction == :up
    animation do
      shape.move(x, y - 1)
    end
    @direction = :up
  end

  def x
    shape.left
  end

  def y
    shape.top
  end

  def animation(&block)
    @animation.stop if @animation
    @animation = app.animate do
      yield
    end
  end
end

Shoes.app do
  window title: "Dude" do
    oval(left: 40, top: 40, width: 2)
    snake = Snake.new(rect(left: 10, top: 10, width: 5), self)
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
        para "j"
        snake.grow
      end
    end
  end
end
