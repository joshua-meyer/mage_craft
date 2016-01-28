square_board_path = File.expand_path("../../../lib/game_boards/square_board.rb", __FILE__)
require square_board_path

game_piece_path = File.expand_path("../../../lib/game_piece.rb", __FILE__)
require game_piece_path

game_instance_path = File.expand_path("../../../lib/game_instance.rb", __FILE__)
require game_instance_path

include Base

describe "SquareGameBoard, GameInstance, GamePiece" do
  TEST_CONTROLLER = { function: :base_controller }
  let(:board_2) { SquareGameBoard.new(2) }

  context "from game_instance_utils" do

    it "err_unless_piece_is_on_the_board" do
      tp1 = GamePiece.new({ controller: TEST_CONTROLLER, game_board: board_2, starting_position: [0,0] })
      tp2 = GamePiece.new({ controller: TEST_CONTROLLER, game_board: board_2 })
      tp3 = GamePiece.new({ controller: TEST_CONTROLLER })

      expect{ GameInstance.new(board_2, characters: [tp3]) }.to raise_error(IllegalMove)
      expect{ GameInstance.new(board_2, characters: [tp2]) }.to raise_error(IllegalMove)
      GameInstance.new(board_2, characters: [tp1])
    end

    it "do_round" do
      BaseController.any_instance.stub(:take_turn).and_return(nil)
      test_piece = GamePiece.new({ controller: TEST_CONTROLLER, game_board: board_2, starting_position: [0,0] })
      game_instance = GameInstance.new(board_2, characters: [test_piece])
      expect(test_piece.controller).to receive(:take_turn)
      game_instance.do_round
    end

  end

  context "from game_piece_utils" do

    it "current_turn" do
      BaseController.any_instance.stub(:take_turn).and_return(nil)
      test_piece = GamePiece.new({ controller: TEST_CONTROLLER, game_board: board_2, starting_position: [0,0] })
      test_instance = GameInstance.new(board_2, characters: [test_piece])
      expect(test_piece.current_turn).to eq(0)
      GameInstance.any_instance.stub(:turn_number).and_return(5)
      expect(test_piece.current_turn).to eq(5)
    end

  end

end
