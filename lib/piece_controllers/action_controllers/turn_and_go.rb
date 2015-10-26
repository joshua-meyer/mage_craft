base_controller_file = File.expand_path("../../base_controller.rb",__FILE__)
require base_controller_file

module Base
  class TurnAndGo < BaseController

    def secondary_initialization
      go_forward_class = load_controller_class_from_symbol(:go_forward)
      go_forward_instance = go_forward_class.new({
        :game_board => @game_board,
        :game_piece => @game_piece
      })
    end

    def take
      new_vfps = turn(@game_piece.vfps)
      @game_piece.update_vfps(new_vfps)
      return go_forward_instance.take_turn({
        sensor_readings: @sensor_readings
      })
    end

    def turn(vector)
      raise NoMethodError, "Implement me!"
    end

    def self.default_manna_cost
      1
    end

  end
end
