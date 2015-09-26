base_board_path = File.expand_path("../../base_game_board.rb",__FILE__)
require base_board_path

square_utils_path = File.expand_path("../board_utils/square_board_utils.rb",__FILE__)
require square_utils_path

module Base
  class SquareGameBoard < BaseGameBoard
    include SquareBoardUtils

    BLANK_SPACE = "[]".light_black

    def generate_board(n,k = n)
      row = []
      for i in (0...k)
        row << BLANK_SPACE
      end
      board = []
      for i in (0...n)
        # Using Marshal to create a deep copy.
        board << Marshal.load(Marshal.dump(row))
      end
      return board
    end

    def print_board
      puts ""
      @game_board.each_with_index do |row,i|
        row.each_index do |j|
          print symbol_at([i,j])
        end
        puts ""
      end
      return "done"
    end

  end
end
