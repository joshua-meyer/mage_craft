base_path = File.expand_path("../../base.rb",__FILE__); require base_path

module Base
  class BaseController

    def initialize(hash_args)
      @game_board = hash_args[:game_board]
      @game_piece = hash_args[:game_piece]
      @current_location = @game_board.location_of_piece(@game_piece)
    end

    def take
      return "implement me"
    end

  end
end
