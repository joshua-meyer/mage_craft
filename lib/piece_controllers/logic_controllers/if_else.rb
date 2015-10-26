base_controller_file = File.expand_path("../../base_controller.rb",__FILE__)
require base_controller_file

module Base
  class IfElse < BaseController

    def take
      if @sensor_readings[@sub_controllers[:inputs][0]]
        sub_controller = @sub_controllers[true]
      else
        sub_controller = @sub_controllers[false]
      end

      sub_controller_class = load_controller_class_from_symbol(sub_controller[:function])

      unless sub_controller[:instance]
        sub_controller[:instance] = sub_controller_class.new({
          game_board:  @game_board,
          game_piece:  @game_piece,
          sub_controllers: sub_controller[:arguments]
        })
      end

      return sub_controller[:instance].take_turn({
        :sensor_readings => @sensor_readings # Should at least be an empty hash
      })
    end

    def self.default_manna_cost
      0
    end

  end
end
