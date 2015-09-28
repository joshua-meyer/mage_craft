base_controller_file = File.expand_path("../../base_controller.rb",__FILE__)
require base_controller_file

module Base
  class GoForward < BaseController

    def take
      begin
        @game_board.move_piece(@game_piece,square_directly_in_front_of_me)
      rescue IllegalMove
        @game_board.remove_piece(@game_piece)
      end
      return "done"
    end

    def self.default_manna_cost
      1
    end

  end
end
