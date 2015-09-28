base_controller_file = File.expand_path("../../base_controller.rb",__FILE__)
require base_controller_file

module Base
  class TurnAndGo < BaseController

    def take
      new_vfps = turn(@game_piece.vfps)
      @game_piece.update_vfps(new_vfps)
      go_forward = load_controller_class_from_symbol(:go_forward)
      move_forward = go_forward.new({
        :game_board => @game_board,
        :game_piece => @game_piece
      })
      return move_forward.take
    end

    def turn(vector)
      raise NoMethodError, "Implement me!"
    end

    def self.default_manna_cost
      1
    end

  end
end
