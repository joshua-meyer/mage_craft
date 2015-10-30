square_board_path = File.expand_path("../../../lib/game_boards/square_board.rb", __FILE__)
require square_board_path

game_instance_path = File.expand_path("../../../lib/game_instance.rb", __FILE__)
require game_instance_path

include Base

describe SquareGameBoard, GameInstance do
  let(:board_2) { SquareGameBoard.new(2) }

  context "from base_game_board" do

    it "set_game_instance" do
      test_instance = GameInstance.new({ game_board: board_2 })
      expect(board_2.game_instance).to eq(test_instance)
    end

  end

end
