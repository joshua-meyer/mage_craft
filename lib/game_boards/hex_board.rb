base_board_path = File.expand_path("../../base_game_board.rb",__FILE__)
require base_board_path

hex_utils_path = File.expand_path("../board_utils/hex_board_utils.rb",__FILE__)
require hex_utils_path

square_board_path = File.expand_path("../square_board.rb",__FILE__)
require square_board_path

module Base
  class HexGameBoard < SquareGameBoard
    include HexBoardUtils
    BLANK_SPACE = ["/\u203E\u203E\\".light_black,"\\__/".light_black]

    # Each space is 2 by 4, so we can shift the odd columns down by 1/2
    def print_board
      puts ""
      rows_plus_one = @game_board.count + 1
      r = 0 # r for row
      rows_plus_one.times do
        if r < @game_board.count
          row = @game_board[r]
        else
          row = @game_board[r-1]
        end
        row.each_index do |c| # c for column
          if c % 2 == 0
            print return_filler_if_symbol_does_not_exist([r,c])[0].on_black
          else
            print return_filler_if_symbol_does_not_exist([r-1,c])[1].on_black
          end
        end
        puts ""
        row.each_index do |c|
          if c % 2 == 0
            print return_filler_if_symbol_does_not_exist([r,c])[1].on_black
          else
            print return_filler_if_symbol_does_not_exist([r,c])[0].on_black
          end
        end
        puts ""
        r += 1
      end
      return "done"
    end

  end
end
