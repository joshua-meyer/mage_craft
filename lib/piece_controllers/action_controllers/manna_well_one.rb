base_controller_file = File.expand_path("../../base_controller.rb",__FILE__); require base_controller_file

module Base
  class MannaWellOne < BaseController

    def take
      @game_piece.parent_piece.give_mp!(1)
      return "done"
    end

    def self.default_symbol
      "$$".light_green
    end

    def self.default_manna_cost
      1
    end

  end
end