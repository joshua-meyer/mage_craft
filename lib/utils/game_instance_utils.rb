module Base
  module GameInstanceUtils

    def err_unless_piece_is_on_the_board(piece,board)
      unless board.location_of_piece(piece)
        raise IllegalMove, "Character #{piece} is not on the board"
      end
    end

    def any_are_met(conditions)
      return false unless conditions
      unless conditions.is_a? Array
        raise ArgumentError, "#{conditions} is not an array"
      end
      conditions.each do |condition|
        unless condition.is_a? Proc
          raise ArgumentError, "#{condition} is not a proc"
        end
      end
      conditions.each do |condition|
        return true if condition.call
      end
      return false
    end

  end
end
