base_path = File.expand_path("../base.rb",__FILE__)
require base_path

instance_utils_path = File.expand_path("../utils/game_instance_utils.rb",__FILE__)
require instance_utils_path

game_board_path = File.expand_path("../base_game_board.rb",__FILE__)
require game_board_path

module Base
  class GameInstance
    include GameInstanceUtils
    attr_reader :game_board, :characters, :win_conditions, :lose_conditions, :turn_number
    attr_accessor :ncps

    def initialize(hash_args)
      @game_board = hash_args[:game_board]
      @characters = hash_args[:characters] || []
      @characters.each { |character| err_unless_piece_is_on_the_board(character, @game_board) }
      @ncps = [] #Non-Character Pieces
      @win_conditions = hash_args[:win_conditions]
      @lose_conditions = hash_args[:lose_conditions]
      @if_win_do = hash_args[:if_win_do] || DEFAULT_IF_WIN_DO
      @if_lose_do = hash_args[:if_lose_do] || DEFAULT_IF_LOSE_DO

      @spectate = hash_args[:spectate]
      @game_board.start_board! if @spectate

      @game_board.set_game_instance(self)
      return "done"
    end

    def show_board_to_spectator
      board = @game_board.refresh_board!
      board.getch
    end

    def do_round # Spells shouldn't move until the players have finished moving.
      @turn_number += 1 if @turn_number
      show_board_to_spectator if @spectate
      [@characters, @ncps].each do |piece_list|
        piece_list.each do |piece|
          if @game_board.location_of_piece(piece)
            piece.take_turn
          end
        end
      end
    end

    def play
      @turn_number = 0
      loop do
        self.do_round
        if any_are_met(@lose_conditions)
          @if_lose_do.call(self)
          break
        elsif any_are_met(@win_conditions)
          @if_win_do.call(self)
          break
        end
      end
    end

  end
end
