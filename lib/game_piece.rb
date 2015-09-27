base_path = File.expand_path("../base.rb",__FILE__)
require base_path

piece_utils_path = File.expand_path("../utils/game_piece_utils.rb",__FILE__)
require piece_utils_path

game_board_path = File.expand_path("../base_game_board.rb",__FILE__)
require game_board_path

module Base
  class GamePiece
    include GamePieceUtils

    attr_reader :controller, :symbol, :game_board, :has_substance, :manna, :parent_piece, :vfps, :spells

    def initialize(hash_args)
      require_controller_file(hash_args[:controller])
      @controller = fetch_class_from_symbol(hash_args[:controller])
      @has_substance = hash_args[:has_substance]
      @manna = hash_args[:manna]
      @game_board = hash_args[:game_board]
      @symbol = hash_args[:symbol] || @controller.default_symbol
      @game_board.err_unless_symbol_is_valid(@symbol) if @game_board
      @game_board.place_piece(self,hash_args[:starting_position]) if hash_args[:starting_position]
      @parent_piece = hash_args[:parent_piece]
      # VFPS: Vector From Parent when Spawned
      @vfps = vector_from_piece(@parent_piece) if @parent_piece
      @spells = hash_args[:spells]
    end

    def take_turn(game_board)
      turn = @controller.new({
        :game_board =>  game_board,
        :game_piece =>  self
      })
      return turn.take
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
      @game_board.game_instance.ncps << new_piece if @game_board.game_instance

      return "done"
    end

  end
end
