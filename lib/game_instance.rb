module Base
  class GameInstance
    include GameInstanceUtils
    attr_reader :game_board, :characters, :win_conditions, :lose_conditions, :turn_number, :user_interface
    attr_accessor :ncps, :spectate

    def initialize(game_board,
          win_conditions: [], lose_conditions: [],
          if_win_do: DEFAULT_IF_WIN_DO, if_lose_do: DEFAULT_IF_LOSE_DO,
          characters: [], ncps: [],
          user_interface: nil, spectate: false
        )
      @game_board = game_board
      @user_interface = user_interface
      @user_interface.game_instance = self if @user_interface
      @user_interface.game_board = game_board if @user_interface
      @user_interface.new_screen! if @user_interface

      @characters = characters
      @characters.each { |character| err_unless_piece_is_on_the_board(character, @game_board) }
      @ncps = ncps
      @win_conditions = win_conditions
      @lose_conditions = lose_conditions
      @if_win_do = if_win_do
      @if_lose_do = if_lose_do

      @spectate = spectate
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
