base_spec_path = File.expand_path("../../base_spec.rb", __FILE__)
require base_spec_path

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
