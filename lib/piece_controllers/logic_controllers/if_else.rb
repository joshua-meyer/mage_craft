base_controller_file = File.expand_path("../../base_controller.rb",__FILE__)
require base_controller_file

module Base
  class IfElse < BaseController

    def take
      if @sensor_readings[@sub_controllers[:inputs][0]]
        sub_controller = load_controller_class_from_symbol(@sub_controllers[true][:function])
      else
        sub_controller = load_controller_class_from_symbol(@sub_controllers[false][:function])
      end
      sub_turn = sub_controller.new({
        :game_board =>  @game_board,
        :game_piece =>  @game_piece,
        :sensor_readings => @sensor_readings, # Should at least be an empty hash
      })
      return sub_turn.take
    end

    def self.default_manna_cost
      0
    end

  end
end
