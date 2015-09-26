base_path = File.expand_path("../base.rb",__FILE__)
require base_path

board_utils_path = File.expand_path("../utils/base_game_board_utils.rb",__FILE__)
require board_utils_path

game_piece_path = File.expand_path("../game_piece.rb",__FILE__)
require game_piece_path

game_instance_path = File.expand_path("../game_instance.rb",__FILE__)
require game_instance_path

module Base
  class BaseGameBoard
    include BaseGameBoardUtils
    attr_reader :game_board, :game_instance

    # Where n is the number of rows and k is the number of columns.
    def initialize(*parameters)
      board = generate_board(*parameters)
      @game_board = board
      return "done"
    end

    def place_piece(piece,location)
      err_unless_game_piece(piece)
      err_unless_valid_location(location)
      set_location_to_piece(location,piece)
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
      set_location_to_piece(to,piece)
      set_location_to_piece(from,BLANK_SPACE)
      return "done"
    end

    def remove_piece(piece)
      err_unless_game_piece(piece)
      piece_loc = location_of_piece(piece)
      unless piece_loc
        raise IllegalMove, "#{piece} is not in play" # *
      end
      set_location_to_piece(piece_loc,BLANK_SPACE)
      return "done"
    end

    def set_game_instance(instance)
      if instance.is_a? GameInstance
        @game_instance = instance
      else
        raise ArgumentError, "#{instance} is not a GameInstance"
      end
    end

    def generate_board(parameters)
      raise NameError, "Implement me!"
    end

    def print_board
      raise NameError, "Implement me!"
    end

  # * I'm using "IllegalMove" to mean,
  # "any operation that would be valid if it did not violate the rules or assumptions of the game."
  # I feel like grouping these together will make exception handling easier later on.
  end
end
