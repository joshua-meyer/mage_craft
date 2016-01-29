base_spec_path = File.expand_path("../../base_spec.rb", __FILE__)
require base_spec_path

include Base

describe SquareGameBoard, GamePiece do
  TEST_CONTROLLER = { function: :base_controller }
  let(:basic_piece) { GamePiece.new ({ controller: TEST_CONTROLLER }) }
  let(:piece_with_substance) { GamePiece.new({ controller: TEST_CONTROLLER, has_substance: true }) }
  let(:piece_without_substance) { GamePiece.new({ controller: TEST_CONTROLLER, has_substance: false }) }
  let(:board_2) { SquareGameBoard.new(2) }

before(:each) do
    TEST_BOARD_2 = [
      [SquareGameBoard::BLANK_SPACE, piece_with_substance],
      [piece_without_substance, "test"]
    ]

    TEST_BOARD_2B = [
      [piece_without_substance, piece_with_substance],
      [SquareGameBoard::BLANK_SPACE, SquareGameBoard::BLANK_SPACE]
    ]
  end

  context "from base_game_board_utils" do
    let(:test_board) { SquareGameBoard.new }
    before(:each) do
      SquareGameBoard.any_instance.stub(:generate_board).and_return(TEST_BOARD_2)
    end

    it "is_enterable?" do
      expect{ test_board.is_enterable?([-1, -1]) }.to raise_error(IllegalMove)
      expect(test_board.is_enterable?([0, 0])).to be true
      expect(test_board.is_enterable?([0, 1])).to be false
      expect(test_board.is_enterable?([1, 0])).to be true
      expect{ test_board.is_enterable?([1, 1]) }.to raise_error(IllegalMove)
    end

    it "piece_at" do
      expect{ test_board.piece_at([-1, -1]) }.to raise_error(IllegalMove)
      expect(test_board.piece_at([0, 0])).to eq(nil)
      expect(test_board.piece_at([0, 1])).to eq(piece_with_substance)
      expect(test_board.piece_at([1, 0])).to eq(piece_without_substance)
      expect{ test_board.piece_at([1, 1]) }.to raise_error(IllegalMove)
    end

    it "symbol_at" do
      expect{ test_board.symbol_at([-1, -1]) }.to raise_error(IllegalMove)
      expect(test_board.symbol_at([0, 0])).to eq(SquareGameBoard::BLANK_SPACE)
      expect(test_board.symbol_at([0, 1])).to eq(BaseController.default_symbol)
      expect(test_board.symbol_at([1, 0])).to eq(BaseController.default_symbol)
      expect(test_board.symbol_at([1, 1])).to eq(SYMBOL_FOR_UNKNOWN)
    end

  end

  context "from base_game_board" do

    it "remove_piece" do
      board_2.instance_variable_set("@game_board", TEST_BOARD_2B)

      expect{ board_2.remove_piece("test") }.to raise_error(IllegalMove)
      expect{ board_2.remove_piece(basic_piece) }.to raise_error(IllegalMove)
      board_2.remove_piece(piece_with_substance)
      expect(board_2.game_board[0][1]).to eq(SquareGameBoard::BLANK_SPACE)
      board_2.game_board.each_with_index do |row, i|
        row.each_index do |j|
          location = [i, j]
          expect(board_2.piece_at(location)).not_to eq(piece_with_substance)
        end
      end
      location_after_being_removed = board_2.location_of_piece(piece_with_substance)
      board_2.game_board.each do |row|
        row.each do |location|
          expect(location).not_to eq(location_after_being_removed)
        end
      end
    end

    it "move_piece" do
      board_2.instance_variable_set("@game_board", TEST_BOARD_2B)
      piece_without_substance.instance_variable_set("@game_board", board_2)

      expect{ board_2.move_piece(basic_piece, [0, 0]) }.to raise_error(IllegalMove)
      expect{ board_2.move_piece(piece_without_substance, [0, -1]) }.to raise_error(IllegalMove)
      expect{ board_2.move_piece(piece_without_substance, [1, 1]) }.to raise_error(IllegalMove)
      expect{ board_2.move_piece(piece_without_substance, [0, 0]) }.to raise_error(IllegalMove)
      expect{ board_2.move_piece(piece_without_substance, [0, 1]) }.to raise_error(IllegalMove)
      board_2.move_piece(piece_without_substance, [1, 0])
      expect(board_2.location_of_piece(piece_without_substance)).to eq([1, 0])
      expect(board_2.piece_at([0, 0])).to eq(nil)
      expect(board_2.game_board[0][0]).to eq(SquareGameBoard::BLANK_SPACE)
    end

    it "place_piece" do
      expect{ board_2.place_piece("test", [0, 0]) }.to raise_error(IllegalMove)
      expect{ board_2.place_piece(basic_piece, [-1, -1]) }.to raise_error(IllegalMove)
      board_2.place_piece(basic_piece, [0, 0])
      expect(board_2.game_board[0][0]).to eq(basic_piece)
      expect(board_2.location_of_piece(basic_piece)).to eq([0, 0])
    end

  end

  context "from game_piece_utils" do

    it "vector_from_piece" do
      board_2.instance_variable_set("@game_board", TEST_BOARD_2B)
      piece_with_substance.instance_variable_set("@game_board", board_2)

      expect{ piece_with_substance.vector_from_piece(basic_piece) }.to raise_error
      expect(piece_with_substance.vector_from_piece(piece_with_substance)).to eq([0,0])
      expect(piece_with_substance.vector_from_piece(piece_without_substance)).to eq([0,1])
    end

  end

end
