module Base
  module BaseGameBoardUtils

    def symbol_at(location)
      err_unless_valid_location(location)
      thing = fetch_location(location)
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
      err_unless_valid_location(location)
      thing = fetch_location(location)
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

    def distance(position1,position2)
      err_unless_valid_location(position1)
      err_unless_valid_location(position2)
      distance_between_2_valid_locations(position1,position2)
    end

    def err_unless_valid_location(location)
      unless is_valid_location?(location)
        raise IllegalMove, "Location #{location} does not exist on #{self}" # *
      end
    end

    def set_location_to_piece(location,piece)
      raise NameError, "Implement me!"
    end

    def location_of_piece(game_piece)
      raise NameError, "Implement me!"
    end

    def is_valid_location?(location)
      raise NameError, "Implement me!"
    end

    def fetch_location(location)
      raise NameError, "Implement me!"
    end

    def distance_between_2_valid_locations(location1,location2)
      raise NameError, "Implement me!"
    end

  # * I'm using "IllegalMove" to mean,
  # "any operation that would be valid if it did not violate the rules or assumptions of the game."
  # I feel like grouping these together will make exception handling easier later on.
  end
end
