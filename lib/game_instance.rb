base_path = File.expand_path("../base.rb",__FILE__); require base_path
game_board_path = File.expand_path("../game_board.rb",__FILE__); require game_board_path

module Base
  class GameInstance

    def initialize(hash_args)
      @game_board = hash_args[:game_board]
      @characters = hash_args[:characters]
      @characters.each { |character| err_unless_piece_is_on_the_board(character,@game_board) }
      @ncps = [] #Non-Character Pieces
      @win_conditions = hash_args[:win_conditions]
      @lose_conditions = hash_args[:lose_conditions]

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
          if @game_board.location_of_piece(piece) # *
            piece.take_turn(@game_board)
            @game_board.print_board
          end
        end
      end
    end

    def play
      loop do
        self.do_round
        if any_are_met(@lose_conditions)
          lose_result
          break
        elsif any_are_met(@win_conditions)
          win_result
          break
        end
      end
    end

    def any_are_met(conditions)
      return false unless conditions
      conditions.each do |condition|
        return true if condition.call
      end
      return false
    end

    def lose_result
      puts "Oh no, you lost!".red
      return ":("
    end

    def win_result
      puts "Yay, you won!".green
      return ":)"
    end

  # * A piece that is not on the board should not get a turn.
  end
end
