module Base
  class TurnLeft < TurnAndGo

    def turn(vector)
      @game_board.rotate_negative(vector)
    end

  end
end
