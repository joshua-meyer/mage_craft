require 'matrix'

module Base
  module SquareBoardUtils

    def set_location_of_piece(location, piece)
      @game_board[location[0]][location[1]] = piece
    end

    def fetch_location(location)
      @game_board[location[0]][location[1]]
    end

    # I'm expecting game boards to be relatively small, with relatively few pieces.
    def location_of_piece(game_piece)
      @game_board.each_with_index do |row,i|
        row.each_with_index do |piece,j|
          return [i,j] if piece == game_piece
        end
      end
      return nil
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

    def is_valid_symbol?(symbol)
      begin
        return false unless symbol.is_a? Hash
        return false unless symbol.count == 3
        return false unless (symbol[:shape] and symbol[:shape].is_a? String)
        return false unless symbol[:shape].length == 2 # To prevent screen tearing
        return false unless symbol[:color].is_a? Fixnum
        return false unless symbol[:attribute].is_a? Fixnum
        return true
      rescue TypeError
        return false
      rescue NoMethodError
        return false
      end
    end

    def distance_between_2_valid_locations(location1, location2)
      vertical_distance = (location1[0] - location2[0]).abs
      horizontal_distance = (location1[1] - location2[1]).abs
      return vertical_distance + horizontal_distance
    end

    def are_2_valid_locations_adjacent(position1, position2)
      distance_between_2_valid_locations(position1, position2) == 1
    end

    def vector_between_valid_locations(from_loc, to_loc)
      vertical = to_loc[0] - from_loc[0]
      horizontal = to_loc[1] - from_loc[1]
      return [vertical,horizontal]
    end

    def apply_vector_to_valid_position(vector, position)
      new_vertical = position[0] + vector[0]
      new_horizontal = position[1] + vector[1]
      return [new_vertical,new_horizontal]
    end

    def map_keyboard_keys_to_adjacent_positions(current_position) # For the player controller
      map = {
        "w" => [current_position[0] - 1, current_position[1]],
        "a" => [current_position[0], current_position[1] - 1],
        "s" => [current_position[0] + 1, current_position[1]],
        "d" => [current_position[0], current_position[1] + 1]
      }
      return map
    end

    def rotate_positive(vector)
      m = Matrix[vector] * Matrix[[0,-1],[1,0]] # Rotates by 90 degrees
      return m.row(0).to_a # Extracts array from matrix
    end

    def rotate_negative(vector)
      m = Matrix[vector] * Matrix[[0,1],[-1,0]] # Rotates by 90 degrees
      return m.row(0).to_a # Extracts array from matrix
    end

    def err_unless_vector_is_unit_vector(vector)
      test_board = SquareGameBoard.new(3)
      test_location = test_board.apply_vector_to_valid_position(vector, [1,1])
      test_board.err_unless_adjacent([1,1], test_location)
    end

  end
end
