require "curses"
require "snake"
require "apple"
require "position"
require "score_keeper"

module Snake
  class Board
    include Curses

    attr_reader :height, :width, :snake, :apple, :window, :score_keeper

    def initialize(height, width)
      @height, @width = height, width * 2
      @window = initialize_window
      @window.nodelay = true
      @score_keeper = ScoreKeeper.new
      set_board
    end

    def tick
      while true
        move_snake(read_input)
        if apple.position == snake.head
          snake.eat(apple)
          score_keeper.increment
          redraw
        elsif snake.touching_itself? || snake.touching_border?
          end_game
          reset_board
        else
          redraw
        end
      end
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

    def redraw
      refresh_board
      snake.draw
      apple.draw
      sleep 0.2
    end

    def end_game(counter = 10)
      counter.times do |i|
        clear_board
        center("Game Over! Restart in #{10 - i}. Score: #{score_keeper.score}")
        sleep 1
      end
      score_keeper.reset
    end

    def center(string)
      window.setpos(height / 2 - 2, width / 2 - 7)
      window.addstr(string)
    end

    def set_board
      @snake = Snake.new(self, Position.new(2, 2), "right")
      @apple = Apple.new(self, Position.new(10, 15))
    end
    alias reset_board set_board

    def initialize_window
      noecho
      curs_set(0)
      Window.new(@height, @width, 0, 0)
    end

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
end
