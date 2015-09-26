module Base
  module GameInstanceUtils

    def err_unless_piece_is_on_the_board(piece,board)
      unless board.location_of_piece(piece)
        raise IllegalMove, "Character #{piece} is not on the board"
      end
    end

    def any_are_met(conditions)
      return false unless conditions
      conditions.each do |condition|
        return true if condition.call
      end
      return false
    end

  end
end
