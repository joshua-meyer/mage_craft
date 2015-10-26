square_board_path = File.expand_path("../../../lib/game_boards/square_board.rb", __FILE__)
require square_board_path

include Base

describe SquareGameBoard do
  let(:board_1_2) { SquareGameBoard.new(1, 2) }

  context "for square boards" do

    it "vector_from_location_to_location" do
      expect{ board_1_2.vector_from_location_to_location([-1, 0], [0, -1]) }.to raise_error(IllegalMove)
      expect{ board_1_2.vector_from_location_to_location([0, 0], [0, -1]) }.to raise_error(IllegalMove)
      expect{ board_1_2.vector_from_location_to_location([-1, 0], [0, 1]) }.to raise_error(IllegalMove)
      expect(board_1_2.vector_from_location_to_location([0, 0], [0, 1])).to eq(board_1_2.vector_between_valid_locations([0, 0], [0, 1]))
    end

  end

end
