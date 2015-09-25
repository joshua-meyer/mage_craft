base_path = File.expand_path("../../lib/base.rb",__FILE__); require base_path
file_path = File.expand_path("../../lib/game_instance.rb",__FILE__); require file_path
player_path = File.expand_path("../../lib/piece_controllers/player.rb",__FILE__); require player_path
include Base

module Base
  class TestPlayer < Player
    def get_input
      puts "Use wasd to move."
      gets.chomp.downcase
    end
  end
end

test_board = GameBoard.new(20)
test_piece = GamePiece.new({
  :controller =>        :test_player,
  :symbol =>            "TP".light_blue,
  :has_substance =>     true,
  :manna =>             0,
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
