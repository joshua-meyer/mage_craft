base_spec_path = File.expand_path("../../base_spec.rb", __FILE__)
require base_spec_path

include Base

describe SquareGameBoard, GameInstance do
  let(:board_2) { SquareGameBoard.new(2) }

  context "from base_game_board" do

    it "set_game_instance" do
      test_instance = GameInstance.new(board_2)
      expect(board_2.game_instance).to eq(test_instance)
    end

  end

end
