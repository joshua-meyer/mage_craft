game_instance_path = File.expand_path("../../../lib/game_instance.rb", __FILE__)
require game_instance_path

include Base

describe GameInstance do
  let(:stub_board) { BaseGameBoard.new(nil) }

  context "spot checks" do

    it "initializes" do
      BaseGameBoard.any_instance.stub(:generate_board).and_return(nil)

      expect{ GameInstance.new({}) }.to raise_error
      GameInstance.new(stub_board)
    end

  end

end
