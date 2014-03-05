$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), "snake"))

require "board"

Snake::Board.new(20, 35).tick