base_path = File.expand_path("../base.rb",__FILE__); require base_path

module Base
  class GamePiece

    attr_reader :controller, :symbol, :has_substance, :mp

    def initialize(hash_args)
      require controller_file(hash_args[:controller])
      @controller = fetch_class_from_symbol(hash_args[:controller])
      @symbol = hash_args[:symbol]
      err_unless_symbol_is_valid(@symbol)
      @game_board = hash_args[:game_board]
      @has_substance = hash_args[:has_substance] || false
      @manna = hash_args[:manna] if hash_args[:manna]
      @mp = @manna if @manna
      @parent_piece = hash_args[:parent_piece]
      # PRTS: Position Relative to Parent when Spawned
      @prts = position_relative_to_parent if @parent_piece
    end

    def controller_file(controller_symbol)
      File.expand_path("../piece_controllers/#{controller_symbol.to_s}.rb",__FILE__)
    end

    def fetch_class_from_symbol(symbol)
      words = symbol.to_s.split("_")
      class_name = words.inject("") { |name,word| name += word.capitalize }
      return Kernel.const_get(class_name.to_sym)
    end

    def position_relative_to_parent
      my_position = @game_board.position_of_piece(self)
      parent_position = @game_board.position_of_piece(@parent_piece)
      vertical = parent_position[0] - my_position[0]
      horizontal = parent_position[1] - my_position[1]
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
        @mp += n
      end

      @mp = @manna if @mp > @manna
      return "done"
    end

    def take_mp!(n)
      if n > @mp
        raise IllegalMove, "#{self} only has #{@mp} mp"
      elsif n < 0
        raise IllegalMove "Why are you trying to 'take' negative mp? Use give_mp! instead."
      else
        @mp -= n
      end
      return "done"
    end

  end
end
