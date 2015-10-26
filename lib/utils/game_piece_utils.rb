module Base
  module GamePieceUtils

    def vector_from_piece(piece)
      my_position = @game_board.location_of_piece(self)
      other_position = @game_board.location_of_piece(piece)
      @game_board.vector_from_location_to_location(other_position, my_position)
    end

    def give_mp!(n)
      unless n.is_a? Integer
        raise ArgumentError, "#{n} is not an integer"
      end
      if n < 0
        raise IllegalMove, "Why are you trying to 'give' negative mp? Use take_mp! instead."
      else
        @manna += n
      end

      return "done"
    end

    def take_mp!(n)
      unless n.is_a? Integer
        raise ArgumentError, "#{n} is not an integer"
      end
      if n > @manna
        raise IllegalMove, "#{self} only has #{@mp} mp"
      elsif n < 0
        raise IllegalMove, "Why are you trying to 'take' negative mp? Use give_mp! instead."
      else
        @manna -= n
      end
      return "done"
    end

    def current_turn
      begin
        @game_board.game_instance.turn_number || 0
      rescue NoMethodError
        0
      end
    end

  end
end
