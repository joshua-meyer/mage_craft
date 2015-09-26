base_path = File.expand_path("../base.rb",__FILE__)
require base_path

instance_utils_path = File.expand_path("../utils/game_instance_utils.rb",__FILE__)
require instance_utils_path

game_board_path = File.expand_path("../base_game_board.rb",__FILE__)
require game_board_path

module Base
  class GameInstance
    include GameInstanceUtils
    attr_reader :game_board, :characters, :win_conditions, :lose_conditions
    attr_accessor :ncps

    def initialize(hash_args)
      @game_board = hash_args[:game_board]
      @characters = hash_args[:characters]
      @characters.each { |character| err_unless_piece_is_on_the_board(character,@game_board) }
      @ncps = [] #Non-Character Pieces
      @win_conditions = hash_args[:win_conditions]
      @lose_conditions = hash_args[:lose_conditions]
      @print_board_each_round = hash_args[:print_board_each_round]
      @if_win_do = hash_args[:if_win_do] || DEFAULT_IF_WIN_DO
      @if_lose_do = hash_args[:if_lose_do] || DEFAULT_IF_LOSE_DO

      @game_board.set_game_instance(self)
      return "done"
    end

    def do_round # Spells shouldn't move until the players have finished moving.
      @game_board.print_board if @print_board_each_round
      [@characters,@ncps].each do |piece_list|
        piece_list.each do |piece|
          if @game_board.location_of_piece(piece)
            piece.take_turn(@game_board)
          end
        end
      end
    end

    def play
      loop do
        self.do_round
        if any_are_met(@lose_conditions)
          @game_board.print_board
          @if_lose_do.call
          break
        elsif any_are_met(@win_conditions)
          @game_board.print_board
          @if_win_do.call
          break
        end
      end
    end

  end
end
