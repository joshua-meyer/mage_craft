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

    def vector_from_piece(piece)
      my_position = @game_board.location_of_piece(self)
      other_position = @game_board.location_of_piece(piece)
      @game_board.vector_from_location_to_location(other_position,my_position)
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
      my_position = @game_board.location_of_piece(self)
      unless @game_board.are_2_locations_adjacent?(my_position,position)
        raise IllegalMove, "Not adjacent to #{position}."
      end
    end

  end
end
