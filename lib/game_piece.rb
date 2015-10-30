base_path = File.expand_path("../base.rb", __FILE__)
require base_path

piece_utils_path = File.expand_path("../utils/game_piece_utils.rb", __FILE__)
require piece_utils_path

game_board_path = File.expand_path("../base_game_board.rb", __FILE__)
require game_board_path

module Base
  class GamePiece
    include GamePieceUtils

    attr_reader :controller_class, :controller, :symbol, :game_board, :has_substance, :manna, :parent_piece,
    :vfps, :vfps_updatable, :spells, :sensors, :turn_spawned

    def initialize(hash_args)
      @controller_class = load_controller_class_from_symbol(hash_args[:controller][:function])
      @game_board = hash_args[:game_board]
      @sub_controllers = hash_args[:controller][:arguments]
      # Initializing the controller requires that all of the above instance variables be set.
      @controller = @controller_class.new(game_variables)

      @game_board.place_piece(self, hash_args[:starting_position]) if hash_args[:starting_position]
      load_sensors(hash_args[:controller][:sensors])
      @symbol = hash_args[:symbol] || @controller_class.default_symbol
      @game_board.err_unless_symbol_is_valid(@symbol) if @game_board
      @has_substance = hash_args[:has_substance]
      @manna = hash_args[:manna]
      @parent_piece = hash_args[:parent_piece]
      # VFPS: Vector From Parent when Spawned
      @vfps = vector_from_piece(@parent_piece) if @parent_piece
      @spells = hash_args[:spells]
      @turn_spawned = current_turn
    end

    def game_variables
      {
        :game_board =>  @game_board,
        :game_piece =>  self,
        :sub_controllers => @sub_controllers
      }
    end

    def load_sensors(sensor_list)
      @sensors = {}
      if sensor_list
        sensor_list.each do |sensor|
          @sensors[sensor] = load_controller_class_from_symbol(sensor)
        end
      end
      return "done"
    end

    def take_turn
      sensor_readings = take_readings(@sensors)
      response =  @controller.take_turn({
        :sensor_readings => sensor_readings # Should at least be an empty hash
      })
      return response
    end

    def take_readings(sensor_hash)
      results = {}
      sensor_hash.each do |name, sensor|
        reading = sensor.new({
          :game_board => game_board,
          :game_piece => self
        })
        results[name] = reading.take_turn
      end
      return results
    end

    def update_vfps(new_vfps)
      @game_board.err_unless_vector_is_unit_vector(new_vfps)
      @vfps = new_vfps
    end

    def spawn_piece(spell, location)
      @game_board.err_unless_adjacent(location, @game_board.location_of_piece(self))
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
        :has_substance =>   template[:has_substance],
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
