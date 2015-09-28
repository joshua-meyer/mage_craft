base_controller_file = File.expand_path("../../base_controller.rb",__FILE__)
require base_controller_file

module Base
  class EveryNthTurn < BaseController
    N = nil

    def take
      return (@game_board.game_instance.turn_number - @game_piece.turn_spawned) % self.class::N == 0
    end

  end
end
