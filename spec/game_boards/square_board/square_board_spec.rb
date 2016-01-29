base_spec_path = File.expand_path("../../../base_spec.rb", __FILE__)
require base_spec_path

include Base

describe SquareGameBoard do
  let(:board_3) { SquareGameBoard.new(3) }
  let(:board_4_2) { SquareGameBoard.new(4, 2) }

  context "when initializing" do
    BOARD_3_TEST = [
      [SquareGameBoard::BLANK_SPACE, SquareGameBoard::BLANK_SPACE, SquareGameBoard::BLANK_SPACE],
      [SquareGameBoard::BLANK_SPACE, SquareGameBoard::BLANK_SPACE, SquareGameBoard::BLANK_SPACE],
      [SquareGameBoard::BLANK_SPACE, SquareGameBoard::BLANK_SPACE, SquareGameBoard::BLANK_SPACE]
    ]

    BOARD_2_4_TEST = [
      [SquareGameBoard::BLANK_SPACE, SquareGameBoard::BLANK_SPACE],
      [SquareGameBoard::BLANK_SPACE, SquareGameBoard::BLANK_SPACE],
      [SquareGameBoard::BLANK_SPACE, SquareGameBoard::BLANK_SPACE],
      [SquareGameBoard::BLANK_SPACE, SquareGameBoard::BLANK_SPACE]
    ]

    it "should initialize a square board correctly" do
      expect(board_3.game_board).to eq(BOARD_3_TEST)
    end

    it "should initialize a rectangle board correctly" do
      expect(board_4_2.game_board).to eq(BOARD_2_4_TEST)
    end

  end

end
