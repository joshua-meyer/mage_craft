base_path = File.expand_path("../../lib/base.rb",__FILE__); require base_path
file_path = File.expand_path("../../lib/game_instance.rb",__FILE__); require file_path
include Base

test_board = GameBoard.new(20)
test_piece = GamePiece.new({
  :controller =>        :player,
  :symbol =>            "TP".light_blue,
  :has_substance =>     true,
  :game_board =>        test_board,
  :starting_position => [1,1]
})

test_game = GameInstance.new({
  :game_board =>  test_board,
  :characters => [test_piece]
})

loop do
  test_game.do_round
end
