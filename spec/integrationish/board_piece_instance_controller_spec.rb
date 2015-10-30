square_board_path = File.expand_path("../../../lib/game_boards/square_board.rb", __FILE__)
require square_board_path

game_piece_path = File.expand_path("../../../lib/game_piece.rb", __FILE__)
require game_piece_path

game_instance_path = File.expand_path("../../../lib/game_instance.rb", __FILE__)
require game_instance_path

include Base

describe "SquareGameBoard, GameInstance, GamePiece" do

  context "from game_piece" do

    it "spawn_piece" do
    end

    it "take_readings" do
    end

    it "take_turn" do
    end

  end

  context "from game_instance" do

    it "play" do
    end

  end

end
