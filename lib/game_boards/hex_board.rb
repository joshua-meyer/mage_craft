base_board_path = File.expand_path("../../base_game_board.rb",__FILE__)
require base_board_path

hex_utils_path = File.expand_path("../board_utils/hex_board_utils.rb",__FILE__)
require hex_utils_path

square_board_path = File.expand_path("../square_board.rb",__FILE__)
require square_board_path

module Base
  class HexGameBoard < SquareGameBoard
    include HexBoardUtils

    # Each space is 2 by 4, so we can shift the odd columns down by 1/2
    def refresh_board!
      @win.clear
      @win.setpos(0, 0)
      @win.addstr("\n")


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
            symbol = return_filler_if_symbol_does_not_exist([r,c])[0]
            print_symbol(symbol)
          else
            symbol = return_filler_if_symbol_does_not_exist([r-1,c])[1]
            print_symbol(symbol)
          end
        end
        @win.addstr("\n")
        row.each_index do |c|
          if c % 2 == 0
            symbol = return_filler_if_symbol_does_not_exist([r,c])[1]
            print_symbol(symbol)
          else
            symbol = return_filler_if_symbol_does_not_exist([r,c])[0]
            print_symbol(symbol)
          end
        end
        @win.addstr("\n")
        r += 1
      end
      Curses.refresh
      return @win
    end

    def print_symbol(symbol)
      begin
        color = symbol[:color] || Curses::COLOR_WHITE
      rescue TypeError
        binding.pry
      end
      attribute = symbol[:attribute] || Curses::A_NORMAL
      Curses.init_pair(color, color, Curses::COLOR_BLACK)
      @win.attron(Curses.color_pair(color)|attribute) do
        @win.addstr(symbol[:shape])
      end
    end

  end
end
