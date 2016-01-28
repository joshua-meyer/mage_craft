base_controller_file = File.expand_path("../../base_controller.rb",__FILE__)
require base_controller_file

module Base
  class EveryNthTurn < BaseController
    attr_reader :n

    def initialize(hash_args)
      super(hash_args)
      @n = nil
    end

    def take
      return (@game_board.game_instance.turn_number - @game_piece.turn_spawned) % @n == 0
    end

    def self.construct(n)
      Class.new(self) do
      end
    end

  end

end
