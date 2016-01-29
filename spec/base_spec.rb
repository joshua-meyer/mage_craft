base_path = File.expand_path("../../lib/base.rb", __FILE__)
require base_path

include Base

describe Base do

  context "spot checks" do
    it "fetch_class_from_symbol" do
      expect(fetch_class_from_symbol(:base_controller)).to eq(BaseController)
    end
  end

end
