base_path = File.expand_path("../../base.rb",__FILE__); require base_path

module Base
  class BaseController

    def initialize(hash_args)
      @game_board = hash_args[:game_board]
      @game_piece = hash_args[:game_piece]
      @current_location = current_location(@game_board,@game_piece)
    end

    def current_location(game_board,game_piece)
      begin
        @game_board.location_of_piece(@game_piece)
      rescue NameError
        return nil
      end
    end

    def self.default_symbol
      "##"
    end

    def self.default_manna_cost
      0
    end

    def take
      return "implement me"
    end

    def square_directly_in_front_of_me
      new_vertical = @current_location[0] + @game_piece.prps[0]
      new_horizontal = @current_location[1] + @game_piece.prps[1]
      return [new_vertical,new_horizontal]
    end

  end
end
