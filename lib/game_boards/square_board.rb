module Base
  class SquareGameBoard < BaseGameBoard
    include SquareBoardUtils
    BLANK_SPACE = { :shape => "[]", :color => Curses::COLOR_WHITE, :attribute => Curses::A_DIM }

    def generate_board(n,k = n)
      row = []
      for i in (0...k)
        row << self.class::BLANK_SPACE
      end
      board = []
      for i in (0...n)
        # Using Marshal to create a deep copy.
        board << Marshal.load(Marshal.dump(row))
      end
      return board
    end

    def yield_elements_of_board
      yield NEW_LINE_SYMBOL
      @game_board.each_with_index do |row, i|
        row.each_index do |j|
          symbol = symbol_at([i,j])
          yield symbol
        end
        yield NEW_LINE_SYMBOL
      end
      yield NEW_LINE_SYMBOL
    end

  end
end
