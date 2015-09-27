square_utils_path = File.expand_path("../square_board_utils.rb",__FILE__)
require square_utils_path

module Base
  module HexBoardUtils
    include SquareBoardUtils

    def is_valid_symbol?(symbol)
      begin
        return false unless symbol.is_a? Array
        return false unless symbol.count == 2
        symbol.each do |s|
          return false unless s.is_a? String
          return false unless s.uncolorize.length == 4 # To prevent screen tearing
        end
        return true
      rescue TypeError
        return false
      rescue NoMethodError
        return false
      end
    end

    def distance_between_2_valid_locations(location1,location2)
      loc1 = hex_shift(location1)
      loc2 = hex_shift(location2)
      vertical = (loc1[0] - loc2[0]).abs.ceil
      horizontal = (loc1[1] - loc2[1]).abs
      return [vertical, horizontal].max
    end

    # Increases the row position of odd columns by 0.5
    def hex_shift(position)
      if position[1] % 2 == 0
        return position
      else
        return [position[0] + 0.5, position[1]]
      end
    end

    def are_2_valid_locations_adjacent?(position1,position2)
      distance_between_2_valid_locations(position1,position2) == 1
    end

    def vector_between_valid_locations(from_loc,to_loc)
      from = hex_shift(from_loc)
      to = hex_shift(to_loc)
      return [to[0] - from[0], to[1] - from[1]]
    end

    def apply_vector_to_position(vector,position)
      pos = hex_shift(position)
      new_pos = [pos[0] + vector[0], pos[1] + vector[1]]
      return hex_unshift(new_pos)
    end

    def hex_unshift(position)
      [position[0].to_i, position[1]]
    end

    def map_keyboard_keys_to_adjacent_positions(current_position) # For the player controller
      {
        "e" => apply_vector_to_position([-1,0],current_position),
        "w" => apply_vector_to_position([-0.5,-1],current_position),
        "s" => apply_vector_to_position([0.5,-1],current_position),
        "d" => apply_vector_to_position([1,0],current_position),
        "f" => apply_vector_to_position([0.5,1],current_position),
        "r" => apply_vector_to_position([-0.5,1],current_position)
      }
    end

    def return_filler_if_symbol_does_not_exist(location)
      begin
        return symbol_at(location)
      rescue IllegalMove
        return ["####".black,"####".black]
      end
    end

  end
end
