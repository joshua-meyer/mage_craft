file_path = File.expand_path("../../lib/game_instance.rb",__FILE__)
require file_path

square_board_path = File.expand_path("../../lib/game_boards/square_board.rb",__FILE__)
require square_board_path

include Base

test_board = SquareGameBoard.new(10)

FIRE_BALL_CONTROLLER = {
  :function => :go_forward
}

FIRE_BALL = {
  :controller => FIRE_BALL_CONTROLLER,
  :symbol => "@@".red,
  :game_board => test_board,
  :manna_cost => 1
}

TURN_LEFT = {
  :function => :turn_left
}

TURN_RIGHT = {
  :function => :turn_right
}

STAIR_CONTROLLER = {
  :function => :if_else,
  :sensors => [
    :every_other_turn
  ],
  :arguments => {
    :inputs => [
      :every_other_turn
    ],
    true =>  TURN_RIGHT,
    false => TURN_LEFT
  }
}

STAIR_WALKER = {
  :controller =>  STAIR_CONTROLLER,
  :symbol =>      "@@".red,
  :game_board =>  test_board,
  :manna_cost =>  1
}

PLAYER_CONTROLLER = {
  :function => :player
}

test_piece = GamePiece.new({
  :controller =>        PLAYER_CONTROLLER,
  :symbol =>            "TP".light_blue,
  :has_substance =>     true,
  :manna =>             0,
  :game_board =>        test_board,
  :starting_position => [1,1],
  :spells => {
    "fireball" => FIRE_BALL,
    "slanty_fireball" => STAIR_WALKER
  }
})

test_game = GameInstance.new({
  :game_board =>  test_board,
  :characters => [test_piece]
})

test_game.play
