file_path = File.expand_path("../../lib/game_instance.rb",__FILE__)
require file_path

square_board_path = File.expand_path("../../lib/game_boards/square_board.rb",__FILE__)
require square_board_path

player_path = File.expand_path("../../lib/piece_controllers/player.rb",__FILE__)
require player_path

include Base

module Base
  class TestPlayer < Player
    def get_input
      puts "Use wasd to move, or space to rest."
      gets.chomp.downcase
    end
  end
end

test_board = SquareGameBoard.new(1,10)

PLAYER_CONTROLLER = {
  :function => :test_player
}

test_piece = GamePiece.new({
  :controller =>        PLAYER_CONTROLLER,
  :symbol =>            "TP".light_blue,
  :manna =>             0,
  :game_board =>        test_board,
  :starting_position => [0,0]
})

BASE_CONTROLLER = {
  :function => :base_controller
}

spawner = GamePiece.new({
  :controller =>        BASE_CONTROLLER,
  :symbol =>            "##".black,
  :has_substance =>      true,
  :game_board =>        test_board,
  :starting_position => [0,9]
})

GO_FORWARD_CONTROLLER = {
  :function => :go_forward
}

red_missile = GamePiece.new({
  :controller =>        GO_FORWARD_CONTROLLER,
  :symbol =>            "<-".red,
  :game_board =>        test_board,
  :starting_position => [0,8],
  :parent_piece =>      spawner
})

test_game = GameInstance.new({
  :game_board => test_board,
  :characters => [test_piece,red_missile],
  :win_conditions => [
    Proc.new { test_board.location_of_piece(red_missile).nil? }
  ],
  :lose_conditions => [
    Proc.new { test_board.location_of_piece(test_piece).nil? }
  ]
})

test_game.play
