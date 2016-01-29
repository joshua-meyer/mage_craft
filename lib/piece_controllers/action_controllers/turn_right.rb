module Base
  class TurnRight < TurnAndGo

    def turn(vector)
      @game_board.rotate_positive(vector)
    end

  end
end
