game_piece_path = File.expand_path("../game_piece.rb",__FILE__); require game_piece_path
base_path = File.expand_path("../base.rb",__FILE__); require base_path

module Base
  class GameBoard

    attr_reader :game_board
    attr_accessor :game_instance

    # Where n is the number of rows and k is the number of columns.
    def initialize(n,k = n)
      row = []
      for i in (0...k)
        row << blank_space
      end
      board = []
      for i in (0...n)
        # Using Marshal to create a deep copy.
        board << Marshal.load(Marshal.dump(row))
      end
      @game_board = board
      return "done"
    end

    def print_board
      puts ""
      @game_board.each_with_index do |row,i|
        row.each_index do |j|
          print symbol_at([i,j])
        end
        puts ""
      end
      return "done"
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

    def err_unless_valid_location(location)
      unless is_valid_location?(location)
        raise IllegalMove, "Location #{location} does not exist on #{self}" # *
      end
    end

    def symbol_at(location)
      thing = @game_board[location[0]][location[1]]
      if thing.is_a? GamePiece
        return thing.symbol
      elsif thing == blank_space
        return blank_space
      else
        return symbol_for_unknown_thing
      end
    end

    def piece_at(location)
      thing = @game_board[location[0]][location[1]]
      if thing == blank_space
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

    # I'm expecting game boards to be relatively small, with relatively few pieces.
    def location_of_piece(game_piece)
      @game_board.each_with_index do |row,i|
        row.each_with_index do |piece,j|
          return [i,j] if piece == game_piece
        end
      end
      return nil
    end

    def place_piece(piece,location)
      err_unless_game_piece(piece)
      err_unless_valid_location(location)

      @game_board[location[0]][location[1]] = piece

      return "done"
    end

    def move_piece(piece,to)
      err_unless_game_piece(piece)
      from = location_of_piece(piece)
      if from.nil?
        raise IllegalMove, "#{piece} is not in play" # *
      end
      err_unless_valid_location(to)
      unless is_enterable?(to)
        raise IllegalMove, "Location #{to} contains #{piece_at(to)}" # *
      end

      @game_board[to[0]][to[1]] = piece
      @game_board[from[0]][from[1]] = blank_space

      return "done"
    end

    def err_unless_game_piece(object)
      unless object.is_a? GamePiece
        raise IllegalMove, "#{object} is not a valid game piece" # *
      end
    end

    def remove_piece(piece)
      err_unless_game_piece(piece)

      piece_loc = location_of_piece(piece)
      unless piece_loc
        raise IllegalMove, "#{piece} is not in play" # *
      end

      @game_board[piece_loc[0]][piece_loc[1]] = blank_space

      return "done"
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
