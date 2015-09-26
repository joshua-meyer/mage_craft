base_path = File.expand_path("../base.rb",__FILE__)
require base_path

board_utils_path = File.expand_path("../utils/game_board_utils.rb",__FILE__)
require board_utils_path

game_piece_path = File.expand_path("../game_piece.rb",__FILE__)
require game_piece_path

module Base
  class GameBoard
    include GameBoardUtils

    attr_reader :game_board
    attr_accessor :game_instance

    # Where n is the number of rows and k is the number of columns.
    def initialize(n,k = n)
      row = []
      for i in (0...k)
        row << BLANK_SPACE
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
      @game_board[from[0]][from[1]] = BLANK_SPACE

      return "done"
    end

    def remove_piece(piece)
      err_unless_game_piece(piece)

      piece_loc = location_of_piece(piece)
      unless piece_loc
        raise IllegalMove, "#{piece} is not in play" # *
      end

      @game_board[piece_loc[0]][piece_loc[1]] = BLANK_SPACE

      return "done"
    end

  # * I'm using "IllegalMove" to mean,
  # "any operation that would be valid if it did not violate the rules or assumptions of the game."
  # I feel like grouping these together will make exception handling easier later on.
  end
end
