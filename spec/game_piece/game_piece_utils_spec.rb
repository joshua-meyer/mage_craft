base_spec_path = File.expand_path("../../base_spec.rb", __FILE__)
require base_spec_path

include Base

describe GamePiece do
  TEST_CONTROLLER = { function: :base_controller }
  let(:test_piece_without_manna) { GamePiece.new ({ controller: TEST_CONTROLLER }) }
  let(:test_piece_with_0_manna) { GamePiece.new ({ controller: TEST_CONTROLLER, manna: 0 }) }
  let(:test_piece_with_10_manna) { GamePiece.new ({ controller: TEST_CONTROLLER, manna: 10 }) }

  context "spot checks" do

    it "give_mp!" do
      expect{ test_piece_with_0_manna.give_mp!(0.5) }.to raise_error(ArgumentError)
      expect{ test_piece_with_0_manna.give_mp!(-1) }.to raise_error(IllegalMove)
      expect{ test_piece_without_manna.give_mp!(0) }.to raise_error(NoMethodError)
      test_piece_with_0_manna.give_mp!(0) # Testing that it does not raise an error
      for n in 1..10 do
        test_piece_with_0_manna.give_mp!(n)
        expect(test_piece_with_0_manna.manna).to eq((1..n).inject(0) { |x, y| x += y })
      end
    end

    it "take_mp!" do
      expect{ test_piece_with_10_manna.take_mp!(0.5) }.to raise_error(ArgumentError)
      expect{ test_piece_with_10_manna.take_mp!(-1) }.to raise_error(IllegalMove)
      expect{ test_piece_with_10_manna.take_mp!(11) }.to raise_error(IllegalMove)
      test_piece_with_0_manna.take_mp!(0) # Testingig that it does not raise an error
      for n in 1..4 do
        test_piece_with_10_manna.take_mp!(n)
        expect(test_piece_with_10_manna.manna).to eq(10 - (1..n).inject(0) { |x, y| x += y })
      end
    end

  end

  context "from Base" do

    it "err_unless_game_piece" do
      err_unless_game_piece(test_piece_without_manna) # Testing that it does not raise an error
      [{}, "test", 1, 0.1, [], :test].each do |not_a_piece|
        expect{ err_unless_game_piece(not_a_piece) }.to raise_error(IllegalMove)
      end
    end

  end

end
