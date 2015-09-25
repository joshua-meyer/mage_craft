base_path = File.expand_path("../base.rb",__FILE__); require base_path

module Base
  class GamePiece

    attr_reader :controller, :symbol, :game_board, :has_substance, :manna, :parent_piece, :prps, :spells

    def initialize(hash_args)
      require_controller_file(hash_args[:controller])
      @controller = fetch_class_from_symbol(hash_args[:controller])
      @symbol = hash_args[:symbol] || @controller.default_symbol
      err_unless_symbol_is_valid(@symbol)
      @has_substance = hash_args[:has_substance]
      @manna = hash_args[:manna]
      @game_board = hash_args[:game_board]
      @game_board.place_piece(self,hash_args[:starting_position]) if hash_args[:starting_position]
      @parent_piece = hash_args[:parent_piece]
      # PRPS: Position Relative to Parent when Spawned
      @prps = position_relative_to(@parent_piece) if @parent_piece
      @spells = hash_args[:spells]
    end

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

    def take_turn(game_board)
      turn = @controller.new({
        :game_board =>  game_board,
        :game_piece =>  self
      })
      return turn.take
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

    def spawn_piece(spell,location)
      err_unless_adjacent_to(location)
      template = @spells[spell]
      manna_cost = template[:manna_cost] || 0

      if @manna < manna_cost
        raise IllegalMove, "Costs #{manna_cost}, but you only have #{@manna}."
      else
        self.take_mp!(manna_cost)
      end

      new_piece = GamePiece.new({
        :controller =>        template[:controller],
        :symbol =>            template[:symbol],
        :has_substance =>     template[:has_substance],
        :manna =>             template[:manna],
        :spells =>            template[:spells],
        :game_board =>        @game_board,
        :parent_piece =>      self,
        :starting_position => location
      })
      @game_board.game_instance.ncps << new_piece

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
