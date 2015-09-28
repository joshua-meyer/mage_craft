module Base
  module BaseGameBoardUtils

    def symbol_at(location)
      err_unless_valid_location(location)
      thing = fetch_location(location)
      if thing.is_a? GamePiece
        symbol = thing.symbol
      elsif thing == self.class::BLANK_SPACE
        symbol = self.class::BLANK_SPACE
      else
        symbol = self.class::SYMBOL_FOR_UNKNOWN
      end
      return symbol
    end

    def piece_at(location)
      err_unless_valid_location(location)
      thing = fetch_location(location)
      if thing == self.class::BLANK_SPACE
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
      return distance_between_2_valid_locations(position1,position2)
    end

    def are_2_locations_adjacent?(position1,position2)
      err_unless_valid_location(position1)
      err_unless_valid_location(position2)
      return are_2_valid_locations_adjacent(position1,position2)
    end

    def err_unless_valid_location(location)
      unless is_valid_location?(location)
        raise IllegalMove, "Location #{location} does not exist on #{self}" # *
      end
    end

    def err_unless_symbol_is_valid(game_symbol)
      unless is_valid_symbol?(game_symbol)
        raise FormatError, "#{game_symbol} is not a valid symbol"
      end
    end

    def set_location_of_piece(location,piece)
      raise NoMethodError, "Implement me!"
    end

    def location_of_piece(game_piece)
      raise NoMethodError, "Implement me!"
    end

    def is_valid_location?(location)
      raise NoMethodError, "Implement me!"
    end

    def is_valid_symbol?(symbol)
      raise NoMethodError, "Implement me!"
    end

    def fetch_location(location)
      raise NoMethodError, "Implement me!"
    end

    def distance_between_2_valid_locations(location1,location2)
      raise NoMethodError, "Implement me!"
    end

    def are_2_valid_locations_adjacent?(position1,position2)
      raise NoMethodError, "Implement me!"
    end

    def vector_between_valid_locations(from_loc,to_loc)
      raise NoMethodError, "Implement me!"
    end

    def apply_vector_to_position(vector,position)
      raise NoMethodError, "Implement me!"
    end

    def rotate_positive(vector)
      raise NoMethodError, "Implement me!"
    end

    def rotate_negative(vector)
      raise NoMethodError, "Implement me!"
    end

    def map_keyboard_keys_to_adjacent_positions(current_position) # For the player controller
      {
        nil => nil
      }
    end

  # * I'm using "IllegalMove" to mean,
  # "any operation that would be valid if it did not violate the rules or assumptions of the game."
  # I feel like grouping these together will make exception handling easier later on.
  end
end
