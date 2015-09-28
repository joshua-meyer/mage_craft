base_controller_file = File.expand_path("../turn_and_go.rb",__FILE__)
require base_controller_file

module Base
  class TurnLeft < TurnAndGo

    def turn(vector)
      @game_board.rotate_negative(vector)
    end

  end
end
