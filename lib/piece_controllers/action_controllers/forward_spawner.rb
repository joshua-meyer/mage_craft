base_controller_file = File.expand_path("../../base_controller.rb",__FILE__); require base_controller_file

module Base
  class ForwardSpawner < BaseController

    def take
      begin
        @game_piece.spawn_piece(@game_piece.spells.first[0],square_directly_in_front_of_me)
      rescue IllegalMove => e
        puts e
        return "done"
      end
      return "done"
    end

    def self.default_symbol
      "::".magenta
    end

    def self.default_manna_cost
      5
    end

  end
end
