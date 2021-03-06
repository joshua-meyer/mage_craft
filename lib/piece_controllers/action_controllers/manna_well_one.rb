module Base
  class MannaWellOne < BaseController

    def take
      @game_piece.parent_piece.give_mp!(1)
      return "done"
    end

    def self.default_symbol
      {
        shape:     "$$",
        color:     Curses::COLOR_GREEN,
        attribute: Curses::A_DIM
      }
    end

    def self.default_manna_cost
      2
    end

  end
end
