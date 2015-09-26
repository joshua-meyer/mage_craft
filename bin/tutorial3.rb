file_path = File.expand_path("../../lib/game_instance.rb",__FILE__)
require file_path

include Base

test_board = GameBoard.new(10,10)

wall = GamePiece.new({
  :controller =>    :base_controller,
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

RED_MISSILE_RIGHT = {
  :controller => :go_forward,
  :symbol =>     "->".red,
  :game_board => test_board,
  :manna_cost => 1
}

RED_MISSILE_UP = {
  :controller => :go_forward,
  :symbol =>     "/\\".red,
  :manna_cost => 1,
  :game_board => test_board
}

RED_MISSILE_UP_FREE = {
  :controller => :go_forward,
  :symbol =>     "/\\".red,
  :game_board => test_board
}

RED_MISSILE_SPAWNER = {
  :controller => :forward_spawner,
  :game_board => test_board,
  :manna =>      0,
  :manna_cost => 5,
  :spells => {
    "red_missile" => RED_MISSILE_UP_FREE
  }
}

reference_square = GamePiece.new({
  :controller =>        :base_controller,
  :symbol =>            "##".black,
  :game_board =>        test_board,
  :has_substance =>     true,
  :starting_position => [2,1]
})

missile_spawner = GamePiece.new({
  :controller =>        :forward_spawner,
  :starting_position => [2,2],
  :symbol =>            "=}".magenta,
  :parent_piece =>      reference_square,
  :game_board =>        test_board,
  :manna =>             0,
  :spells => {
    "red_missile" => RED_MISSILE_RIGHT
  }
})

manna_tap = GamePiece.new({
  :controller =>         :manna_well_one,
  :game_board =>         test_board,
  :symbol =>             "##".black,
  :starting_position =>  [2,0],
  :parent_piece =>       missile_spawner
})

victory = GamePiece.new({
  :controller =>        :base_controller,
  :symbol =>            "[]".green,
  :game_board =>        test_board,
  :starting_position => [0,7]
})

test_piece = GamePiece.new({
  :controller =>        :player,
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
