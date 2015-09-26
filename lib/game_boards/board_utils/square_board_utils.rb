module Base
  module SquareBoardUtils

    def set_location_to_piece(location,piece)
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

    def distance_between_2_valid_locations(location1,location2)
      vertical_distance = (location1[0] - location2[0]).abs
      horizontal_distance = (location1[1] - location2[1]).abs
      return vertical_distance + horizontal_distance
    end

  end
end
