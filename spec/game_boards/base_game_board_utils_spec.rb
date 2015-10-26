square_board_path = File.expand_path("../../../lib/game_boards/square_board.rb", __FILE__)
require square_board_path

include Base

describe SquareGameBoard do
  let(:board_1) { SquareGameBoard.new(1) }
  let(:board_1_3) { SquareGameBoard.new(1, 3) }
  let(:board_2) { SquareGameBoard.new(2) }

  context "spot checks" do
    TEST_BOARD_1_3 = [
      [SquareGameBoard::BLANK_SPACE, SquareGameBoard::BLANK_SPACE , "test"]
    ]

    it "err_unless_symbol_is_valid" do
      expect{ board_1_3.err_unless_symbol_is_valid("[]".light_black) }.to raise_error(FormatError)
      expect(board_1_3.err_unless_symbol_is_valid(SquareGameBoard::BLANK_SPACE)).to eq(nil)
    end

    it "err_unless_valid_location" do
      expect{ board_1_3.err_unless_valid_location([-1, -1]) }.to raise_error(IllegalMove)
      expect( board_1_3.err_unless_valid_location([0, 2])).to eq(nil)
    end

    it "are_2_locations_adjacent?" do
      expect{ board_1_3.are_2_locations_adjacent?([0, -1], [-1, 0]) }.to raise_error(IllegalMove)
      expect{ board_1_3.are_2_locations_adjacent?([0, 1], [-1, 0]) }.to raise_error(IllegalMove)
      expect{ board_1_3.are_2_locations_adjacent?([0, -1], [0, 0]) }.to raise_error(IllegalMove)
      expect(board_1_3.are_2_locations_adjacent?([0, 1], [0, 0])).to eq(board_1_3.are_2_valid_locations_adjacent([0, 1], [0, 0]))
    end

    it "distance" do
      expect{ board_1_3.distance([0, -1], [-1, 0]) }.to raise_error(IllegalMove)
      expect{ board_1_3.distance([0, 1], [-1, 0]) }.to raise_error(IllegalMove)
      expect{ board_1_3.distance([0, -1], [0, 0]) }.to raise_error(IllegalMove)
      expect(board_1_3.distance([0, 1], [0, 0])).to eq(board_1_3.distance_between_2_valid_locations([0, 1], [0, 0]))
    end

    it "is_enterable?" do
      expect{ board_1_3.is_enterable?([-1, -1]) }.to raise_error(IllegalMove)
    end

    it "symbol_at" do
      SquareGameBoard.any_instance.stub(:generate_board).and_return(TEST_BOARD_1_3)

      expect{ board_1_3.symbol_at([-1, -1]) }.to raise_error(IllegalMove)
      expect(board_1_3.game_board).to eq(TEST_BOARD_1_3)
    end

    it "err_unless_adjacent" do
      expect{ board_2.err_unless_adjacent([0,0], [-1, -1]) }.to raise_error
      expect{ board_2.err_unless_adjacent([0,0], [-1, 0]) }.to raise_error
      expect{ board_2.err_unless_adjacent([0,0], [0, -1]) }.to raise_error
      expect{ board_2.err_unless_adjacent([0,0], [0, 0]) }.to raise_error
      expect{ board_2.err_unless_adjacent([0,0], [1, 1]) }.to raise_error
      board_2.err_unless_adjacent([0,0], [0, 1])
      board_2.err_unless_adjacent([0,0], [1, 0])
    end

  end

end
