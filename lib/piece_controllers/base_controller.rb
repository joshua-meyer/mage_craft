require "curses"

game_instance_path = File.expand_path("../../game_instance.rb",__FILE__)
require game_instance_path

module Base
  class BaseController

    def initialize(hash_args)
      @game_board = hash_args[:game_board]
      @game_piece = hash_args[:game_piece]
      @sub_controllers = hash_args[:sub_controllers]
      @turn_variables = []

      secondary_initialization
    end

    def secondary_initialization
      nil
    end

    def current_location(game_board,game_piece)
      begin
        @game_board.location_of_piece(@game_piece)
      rescue NameError
        return nil
      end
    end

    def self.default_symbol
      {
        shape: "##",
        color: Curses::COLOR_WHITE,
        attribute: Curses::A_NORMAL
      }
    end

    def self.default_manna_cost
      0
    end

    def take_turn(hash_args)
      @sensor_readings = hash_args[:sensor_readings]
      @current_location = current_location(@game_board, @game_piece)
      take
    end

    def take
      raise NoMethodError, "Implement me!"
    end

    def square_directly_in_front_of_me
      @game_board.apply_vector_to_position(@game_piece.vfps, @current_location)
    end

  end
end
