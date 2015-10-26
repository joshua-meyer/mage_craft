base_path = File.expand_path("../base.rb", __FILE__)
require base_path

board_utils_path = File.expand_path("../utils/base_game_board_utils.rb", __FILE__)
require board_utils_path

game_piece_path = File.expand_path("../game_piece.rb", __FILE__)
require game_piece_path

game_instance_path = File.expand_path("../game_instance.rb", __FILE__)
require game_instance_path

module Base
  class BaseGameBoard
    include BaseGameBoardUtils
    attr_reader :game_board, :game_instance
    BLANK_SPACE = {
      shape: "??",
      color: Curses::COLOR_RED,
      attribute: Curses::A_DIM
    }

    # Where n is the number of rows and k is the number of columns.
    def initialize(*parameters)
      board = generate_board(*parameters)
      @game_board = board
      "done"
    end

    def place_piece(piece, location)
      err_unless_game_piece(piece)
      err_unless_valid_location(location)
      set_location_of_piece(location ,piece)
      return "done"
    end

    def move_piece(piece, to)
      err_unless_game_piece(piece)
      from = location_of_piece(piece)
      if from.nil?
        raise IllegalMove, "#{piece} is not in play" # *
      end
      err_unless_valid_location(to)
      unless is_enterable?(to)
        raise IllegalMove, "Location #{to} contains #{piece_at(to)}" # *
      end
      err_unless_adjacent(from, to)

      set_location_of_piece(to, piece)
      set_location_of_piece(from, self.class::BLANK_SPACE)
      return "done"
    end

    def remove_piece(piece)
      err_unless_game_piece(piece)
      piece_loc = location_of_piece(piece)
      unless piece_loc
        raise IllegalMove, "#{piece} is not in play" # *
      end
      set_location_of_piece(piece_loc, self.class::BLANK_SPACE)
      return "done"
    end

    def set_game_instance(instance)
      if instance.is_a? GameInstance
        @game_instance = instance
      else
        raise ArgumentError, "#{instance} is not a GameInstance"
      end
    end

    def vector_from_location_to_location(from_loc,to_loc)
      [from_loc, to_loc].each { |loc| err_unless_valid_location(loc) }
      return vector_between_valid_locations(from_loc, to_loc)
    end

    def generate_board(parameters)
      raise NoMethodError, "Implement me!"
    end

    def print_board
      raise NoMethodError, "Implement me!"
    end

  # * I'm using "IllegalMove" to mean,
  # "any operation that would be valid if it did not violate the rules or assumptions of the game."
  # Grouping these together will make exception handling easier later on.
  end
end
