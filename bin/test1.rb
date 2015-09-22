base_path = File.expand_path("../../lib/base.rb",__FILE__); require base_path
file_path = File.expand_path("../../lib/game_instance.rb",__FILE__); require file_path
include Base

test_board = GameBoard.new(20)
test_piece = GamePiece.new({
  :controller =>    :player,
  :symbol =>        "TP",
  :has_substance => true
})
test_board.place_piece(test_piece,[1,1])
test_game = GameInstance.new(test_board,test_piece)

loop do
  test_game.do_round
end
