module Base
  class TurnAndGo < BaseController

    def initialize(hash_args)
      super(hash_args)
      go_forward_class = fetch_class_from_symbol(:go_forward)
      @go_forward_instance = go_forward_class.new({
        :game_board => @game_board,
        :game_piece => @game_piece
      })
    end

    def take
      new_vfps = turn(@game_piece.vfps)
      @game_piece.update_vfps(new_vfps)
      return @go_forward_instance.take_turn({
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
