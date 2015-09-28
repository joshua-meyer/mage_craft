file_path = File.expand_path("../../lib/game_instance.rb",__FILE__)
require file_path

square_board_path = File.expand_path("../../lib/game_boards/hex_board.rb",__FILE__)
require square_board_path

include Base

test_board = HexGameBoard.new(10)

GO_FORWARD = {
  :function => :go_forward
}

FIRE_BALL = {
  :controller => GO_FORWARD,
  :symbol =>     [" @@ ".red, " @@ ".red],
  :game_board => test_board,
  :manna_cost => 1
}

PLAYER_CONTROLLER = {
  :function => :player
}

test_piece = GamePiece.new({
  :controller =>        PLAYER_CONTROLLER,
  :symbol =>            ["test".light_blue, "pice".light_blue],
  :has_substance =>     true,
  :manna =>             0,
  :game_board =>        test_board,
  :starting_position => [1,1],
  :spells => {
    "fire_ball" => FIRE_BALL
  }
})


test_game = GameInstance.new({
  :game_board =>  test_board,
  :characters => [test_piece]
})

test_game.play
