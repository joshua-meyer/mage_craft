base_path = File.expand_path("../../lib/base.rb", __FILE__)
require base_path

include Base

describe Base do

  context "spot checks" do

    it "require_controller_file" do
      expect{ BaseController.class }.to raise_error(NameError)
      require_controller_file(:base_controller)
      BaseController.class # Testing that it does not raise an error
    end

    it "fetch_class_from_symbol" do
      expect(fetch_class_from_symbol(:base_controller)).to eq(BaseController)
    end

    it "load_controller_class_from_symbol" do
      expect { Player.class }.to raise_error(NameError)
      expect(load_controller_class_from_symbol(:player)).to eq(Player)
    end

  end

end
