module Base
  module GamePieceUtils

    def require_controller_file(controller_symbol)
      search_results = `find .. -name '*#{controller_symbol.to_s}*'`
      matching_files = search_results.split("\n")
      matching_files.each do |file_path|
        require file_path
      end
    end

    def fetch_class_from_symbol(symbol)
      words = symbol.to_s.split("_")
      class_name = words.inject("") { |name,word| name += word.capitalize }
      return Kernel.const_get(class_name.to_sym)
    end

    def position_relative_to(piece)
      my_position = @game_board.location_of_piece(self)
      other_position = @game_board.location_of_piece(piece)
      vertical = my_position[0] - other_position[0]
      horizontal = my_position[1] - other_position[1]
      return [vertical,horizontal]
    end

    def give_mp!(n)
      if n < 0
        raise IllegalMove, "Why are you trying to 'give' negative mp? Use take_mp! instead."
      else
        @manna += n
      end

      return "done"
    end

    def take_mp!(n)
      if n > @manna
        raise IllegalMove, "#{self} only has #{@mp} mp"
      elsif n < 0
        raise IllegalMove "Why are you trying to 'take' negative mp? Use give_mp! instead."
      else
        @manna -= n
      end
      return "done"
    end

    def err_unless_adjacent_to(position)
      unless my_distance_from(position) == 1
        raise IllegalMove, "Not adjacent to #{position}."
      end
    end

    def my_distance_from(location)
      my_position = @game_board.location_of_piece(self)
      return @game_board.distance(my_position,location)
    end

  end
end
