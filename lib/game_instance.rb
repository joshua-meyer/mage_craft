base_path = File.expand_path("../base.rb",__FILE__); require base_path
game_board_path = File.expand_path("../game_board.rb",__FILE__); require game_board_path

module Base
  class GameInstance

    def initialize(game_board,*characters)
      @game_board = game_board
      @characters = *characters
      characters.each { |character| err_unless_piece_is_on_the_board(character,@game_board) }
      @ncps = [] #Non-Character Pieces

      @game_board.print_board
      return "done"
    end

    def err_unless_piece_is_on_the_board(piece,board)
      unless board.location_of_piece(piece)
        raise IllegalMove, "Character #{piece} is not on the board"
      end
    end

    def do_round # Spells shouldn't move until the players have finished moving.
      [@characters,@ncps].each do |piece_list|
        piece_list.each do |piece|
          piece.take_turn(@game_board) if @game_board.location_of_piece(piece) # *
          @game_board.print_board
        end
      end
    end

  # * A piece that is not on the board should not get a turn.
  end
end
