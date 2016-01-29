base_spec_path = File.expand_path("../../base_spec.rb", __FILE__)
require base_spec_path

include Base

module Base
  class Test
    def err_unless_vector_is_unit_vector(test)
      raise IllegalMove
    end
  end
end

describe GamePiece do
  BASIC_CONTROLLER = { function: :base_controller }
  let(:basic_piece) { GamePiece.new ({ controller: BASIC_CONTROLLER }) }
  let(:test_class) { Test.new }

  context "spot checks" do

    it "can initialize" do
      basic_piece
    end

    it "load_sensors" do
      basic_piece.load_sensors([:every_other_turn])
      expect(basic_piece.sensors).to eq({ every_other_turn: EveryOtherTurn })
    end

    it "update_vfps should err when err_unless_vector_is_unit_vector errs" do
      basic_piece.instance_variable_set("@game_board", test_class)
      expect{ basic_piece.update_vfps([0,0]) }.to raise_error(IllegalMove)
    end

    it "update_vfps should update vfps when err_unless_vector_is_unit_vector does not err" do
      test_class.stub(:err_unless_vector_is_unit_vector) { nil }
      basic_piece.instance_variable_set("@game_board", test_class)
      basic_piece.update_vfps([0,0])
      expect(basic_piece.vfps).to eq([0,0])
    end

  end

end
