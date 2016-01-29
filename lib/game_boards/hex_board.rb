module Base
  class HexGameBoard < SquareGameBoard
    include HexBoardUtils

    # Each space is 2 by 4, so we can shift the odd columns down by 1/2
    def yield_elements_of_board
      yield NEW_LINE_SYMBOL
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
            yield symbol
          else
            symbol = return_filler_if_symbol_does_not_exist([r-1,c])[1]
            yield symbol
          end
        end
        yield NEW_LINE_SYMBOL
        row.each_index do |c|
          if c % 2 == 0
            symbol = return_filler_if_symbol_does_not_exist([r,c])[1]
            yield symbol
          else
            symbol = return_filler_if_symbol_does_not_exist([r,c])[0]
            yield symbol
          end
        end
        yield NEW_LINE_SYMBOL
        r += 1
      end
    end

  end
end
