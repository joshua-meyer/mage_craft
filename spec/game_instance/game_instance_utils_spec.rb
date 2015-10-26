game_instance_path = File.expand_path("../../../lib/game_instance.rb", __FILE__)
require game_instance_path

include Base

describe GameInstance do

  context "spot checks" do
    let(:true_proc) { Proc.new { true } }
    let(:false_proc) { Proc.new { false } }
    let(:truthy_proc) { Proc.new { "" } }

    it "any_are_met" do
      GameInstance.any_instance.stub(:initialize).and_return(nil)
      test_instance = GameInstance.new

      expect{ test_instance.any_are_met({}) }.to raise_error(ArgumentError)
      expect{ test_instance.any_are_met([true_proc, "test", true_proc])}.to raise_error(ArgumentError)

      expect(test_instance.any_are_met([])).to be false

      expect(test_instance.any_are_met([true_proc])).to be true
      expect(test_instance.any_are_met([false_proc])).to be false
      expect(test_instance.any_are_met([truthy_proc])).to be true

      expect(test_instance.any_are_met([false_proc, false_proc])).to be false
      expect(test_instance.any_are_met([false_proc, true_proc])).to be true
      expect(test_instance.any_are_met([false_proc, truthy_proc])).to be true
      expect(test_instance.any_are_met([true_proc, false_proc])).to be true
      expect(test_instance.any_are_met([true_proc, true_proc])).to be true
      expect(test_instance.any_are_met([true_proc, truthy_proc])).to be true
      expect(test_instance.any_are_met([truthy_proc, false_proc])).to be true
      expect(test_instance.any_are_met([truthy_proc, true_proc])).to be true
      expect(test_instance.any_are_met([truthy_proc, truthy_proc])).to be true
    end


  end

end
