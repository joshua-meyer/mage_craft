file_path = File.expand_path("../../lib/game_instance.rb",__FILE__)
require file_path

player_path = File.expand_path("../../lib/piece_controllers/player.rb",__FILE__)
require player_path

include Base

module Base
  class TestPlayer < Player
    def get_input
      puts "Use wasd to move."
      gets.chomp.downcase
    end
  end
end

test_board = GameBoard.new(17,21)

wall = GamePiece.new({
  :controller =>    :base_controller,
  :symbol =>        "##".black,
  :has_substance => true
})
wall_locations = [
  [1,1],[3,0],[3,1],[3,2],[3,3],[2,3],[2,5],[3,5],[4,5],[5,5],[6,5],[1,6],[1,7],[1,8],[1,9],
  [4,7],[5,7],[5,6],[5,8],[3,9],[0,1],[1,3],[1,5],[2,9],[3,7],[3,3],[4,3],[5,1],[6,1],[7,1],
  [8,1],[9,1],[10,1],[11,1],[3,10],[3,11],[4,11],[5,11],[5,3],[5,9],[7,2],[7,3],[7,4],[9,3],
  [7,5],[13,0],[13,1],[11,2],[11,3],[12,3],[13,3],[14,3],[15,3],[15,2],[15,1],[16,1],[9,4],
  [9,5],[9,6],[9,7],[10,5],[11,5],[12,5],[13,5],[14,5],[15,5],[16,5],[7,7],[7,8],[7,9],[8,9],
  [9,9],[10,9],[11,9],[11,8],[11,7],[12,7],[13,7],[14,7],[15,7],[11,10],[11,11],[12,11],[13,11],
  [14,11],[15,11],[15,9],[16,9],[14,9],[13,9],[13,12],[13,13],[10,11],[9,11],[8,11],[7,11],
  [7,12],[7,13],[7,14],[7,15],[8,15],[9,15],[9,16],[9,17],[10,17],[11,17],[12,17],[13,17],
  [14,17],[15,17],[7,17],[8,17],[6,17],[5,17],[4,17],[3,17],[2,17],[1,17],[15,19],[14,19],
  [13,19],[12,19],[11,19],[10,19],[9,19],[9,20],[7,19],[7,18],[5,16],[5,15],[5,14],[5,13],
  [5,12],[5,20],[5,19],[1,18],[1,19],[2,19],[3,19],[1,15],[2,15],[3,15],[3,14],[15,15],
  [3,13],[2,13],[1,13],[1,12],[1,11],[0,11],[16,15],[15,14],[15,13],[14,15],[13,15],
  [12,15],[11,15],[11,14],[11,13],[10,13],[9,13]
]
wall_locations.each do |wl|
  test_board.place_piece(wall,wl)
end

door1 = GamePiece.new({
  :controller =>        :base_controller,
  :symbol =>            "||".yellow,
  :game_board =>        test_board,
  :starting_position => [0,5]
})
door2 = GamePiece.new({
  :controller =>        :base_controller,
  :symbol =>            "==".yellow,
  :game_board =>        test_board,
  :starting_position => [11,16]
})
victory = GamePiece.new({
  :controller =>        :base_controller,
  :symbol =>            "[]".green,
  :game_board =>        test_board,
  :starting_position => [10,20]
})

test_piece = GamePiece.new({
  :controller =>        :test_player,
  :symbol =>            "TP".light_blue,
  :has_substance =>     true,
  :manna =>             0,
  :game_board =>        test_board,
  :starting_position => [0,0]
})

test_game = GameInstance.new({
  :game_board => test_board,
  :characters => [test_piece],
  :win_conditions => [
    Proc.new { test_board.location_of_piece(test_piece) == [10,20] }
  ]
})

test_game.play
