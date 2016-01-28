base_controller_file = File.expand_path("../every_nth_turn.rb",__FILE__)
require base_controller_file

module Base
  class EveryOtherTurn < EveryNthTurn

    def initialize(hash_args)
      super(hash_args)
      @n = 2
    end

  end
end
