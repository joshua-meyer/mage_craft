base_controller_file = File.expand_path("../every_nth_turn.rb",__FILE__)
require base_controller_file

module Base
  class EveryOtherTurn < EveryNthTurn
    N = 2
  end
end
