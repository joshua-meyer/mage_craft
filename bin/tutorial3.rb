file_path = File.expand_path("../../lib/game_instance.rb",__FILE__)
require file_path

square_board_path = File.expand_path("../../lib/game_boards/square_board.rb",__FILE__)
require square_board_path

include Base

test_board = SquareGameBoard.new(10,10)

BASE_CONTROLLER = {
  :function => :base_controller
}

wall = GamePiece.new({
  :controller =>    BASE_CONTROLLER,
  :symbol =>        "##".black,
  :has_substance => true
})
wall_locations = [
  [0,0],[0,1],[0,2],[0,3],[0,4],
  [1,0],[1,1],[1,2],[1,3],[1,4],
  [3,0],[3,1],[3,2],[3,3],[3,4],
  [4,0],[4,1],[4,2],[4,3],[4,4],
  [5,0],[5,1],[5,2],[5,3],[5,4],
  [6,0],[6,1],[6,2],[6,3],[6,4],
  [7,0],[7,1],[7,2],[7,3],[7,4],
  [8,0],[8,1],[8,2],[8,3],[8,4],
  [9,0],[9,1],[9,2],[9,3],[9,4]
]
wall_locations.each do |wl|
  test_board.place_piece(wall,wl)
end

GO_FORWARD_CONTROLLER = {
  :function => :go_forward
}

RED_MISSILE_RIGHT = {
  :controller => GO_FORWARD_CONTROLLER,
  :symbol =>     "->".red,
  :game_board => test_board,
  :manna_cost => 1
}

RED_MISSILE_UP = {
  :controller => GO_FORWARD_CONTROLLER,
  :symbol =>     "/\\".red,
  :manna_cost => 1,
  :game_board => test_board
}

RED_MISSILE_UP_FREE = {
  :controller => GO_FORWARD_CONTROLLER,
  :symbol =>     "/\\".red,
  :game_board => test_board
}

FORWARD_SPAWNER_CONTROLLER = {
  :function => :forward_spawner
}

RED_MISSILE_SPAWNER = {
  :controller => FORWARD_SPAWNER_CONTROLLER,
  :game_board => test_board,
  :manna =>      0,
  :manna_cost => 5,
  :spells => {
    "red_missile" => RED_MISSILE_UP_FREE
  }
}

reference_square = GamePiece.new({
  :controller =>        BASE_CONTROLLER,
  :symbol =>            "##".black,
  :game_board =>        test_board,
  :has_substance =>     true,
  :starting_position => [2,1]
})

missile_spawner = GamePiece.new({
  :controller =>        FORWARD_SPAWNER_CONTROLLER,
  :starting_position => [2,2],
  :symbol =>            "=}".magenta,
  :parent_piece =>      reference_square,
  :game_board =>        test_board,
  :manna =>             0,
  :spells => {
    "red_missile" => RED_MISSILE_RIGHT
  }
})

MANNA_WELL_ONE_CONTROLLER = {
  :function => :manna_well_one
}

manna_tap = GamePiece.new({
  :controller =>         MANNA_WELL_ONE_CONTROLLER,
  :game_board =>         test_board,
  :symbol =>             "##".black,
  :starting_position =>  [2,0],
  :parent_piece =>       missile_spawner
})

victory = GamePiece.new({
  :controller =>        BASE_CONTROLLER,
  :symbol =>            "[]".green,
  :game_board =>        test_board,
  :starting_position => [0,7]
})

PLAYER_CONTROLLER = {
  :function => :player
}

test_piece = GamePiece.new({
  :controller =>        PLAYER_CONTROLLER,
  :symbol =>            "TP".light_blue,
  :manna =>             0,
  :game_board =>        test_board,
  :starting_position => [9,7],
  :spells => {
    "red_missile" => RED_MISSILE_UP,
    "missile_spawner" => RED_MISSILE_SPAWNER
  }
})

test_game = GameInstance.new({
  :game_board => test_board,
  :characters => [manna_tap,missile_spawner,test_piece],
  :win_conditions => [
    Proc.new { test_board.location_of_piece(test_piece) == [0,7] }
  ],
  :lose_conditions => [
    Proc.new { test_board.location_of_piece(test_piece).nil? }
  ]
})

test_game.play
