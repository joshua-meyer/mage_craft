module Base
  module GameBoardUtils

    def err_unless_valid_location(location)
      unless is_valid_location?(location)
        raise IllegalMove, "Location #{location} does not exist on #{self}" # *
      end
    end

    def is_valid_location?(location)
      begin
        return false unless location.count == 2
        return false unless @game_board[location[0]][location[1]]
        return false if location[0] < 0 or location[0] >= @game_board.count
        row = @game_board[location[0]]
        return false if location[1] < 0 or location[1] >= row.count
        return true
      rescue TypeError
        return false
      rescue NoMethodError
        return false
      end
    end

    def symbol_at(location)
      thing = @game_board[location[0]][location[1]]
      if thing.is_a? GamePiece
        symbol = thing.symbol
      elsif thing == BLANK_SPACE
        symbol = BLANK_SPACE
      else
        symbol = SYMBOL_FOR_UNKNOWN
      end
      return symbol.on_black
    end

    def piece_at(location)
      thing = @game_board[location[0]][location[1]]
      if thing == BLANK_SPACE
        return nil
      elsif thing.is_a? GamePiece
        return thing
      else
        raise IllegalMove, "Unrecognized object at #{location}" # *
      end
    end

    def is_enterable?(location)
      err_unless_valid_location(location)
      begin
        not piece_at(location).has_substance
      rescue NoMethodError
        return true
      end
    end

    def err_unless_game_piece(object)
      unless object.is_a? GamePiece
        raise IllegalMove, "#{object} is not a valid game piece" # *
      end
    end

    def distance(position1,position2)
      err_unless_valid_location(position1)
      err_unless_valid_location(position2)

      vertical_distance = (position1[0] - position2[0]).abs
      horizontal_distance = (position1[1] - position2[1]).abs

      return vertical_distance + horizontal_distance
    end

  # * I'm using "IllegalMove" to mean,
  # "any operation that would be valid if it did not violate the rules or assumptions of the game."
  # I feel like grouping these together will make exception handling easier later on.
  end
end
