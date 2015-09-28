base_path = File.expand_path("../base.rb",__FILE__)
require base_path

piece_utils_path = File.expand_path("../utils/game_piece_utils.rb",__FILE__)
require piece_utils_path

game_board_path = File.expand_path("../base_game_board.rb",__FILE__)
require game_board_path

module Base
  class GamePiece
    include GamePieceUtils

    attr_reader :controller, :symbol, :game_board, :has_substance, :manna, :parent_piece,
    :vfps, :vfps_updatable, :spells, :sensors, :turn_spawned

    def initialize(hash_args)
      @controller = load_controller_class_from_symbol(hash_args[:controller][:function])
      @sub_controllers = hash_args[:controller][:arguments]
      @sensors = load_sensors(hash_args[:controller][:sensors])
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
      @vfps_updatable = false
      @turn_spawned = current_turn
    end

    def load_sensors(sensor_list)
      sensors = {}
      if sensor_list
        sensor_list.each do |sensor|
          sensors[sensor] = load_controller_class_from_symbol(sensor)
        end
      end
      return sensors
    end

    def take_turn(game_board)
      sensor_readings = take_readings(@sensors)
      turn = @controller.new({
        :game_board =>  game_board,
        :game_piece =>  self,
        :sensor_readings => sensor_readings, # Should at least be an empty hash
        :sub_controllers => @sub_controllers
      })
      @vfps_updatable = true
      response =  turn.take
      @vfps_updatable = false
      return response
    end

    def take_readings(sensor_hash)
      results = {}
      sensor_hash.each do |name,sensor|
        reading = sensor.new({
          :game_board => game_board,
          :game_piece => self
        })
        results[name] = reading.take
      end
      return results
    end

    def update_vfps(new_vfps)
      if @vfps_updatable
        @vfps = new_vfps
      else
        raise NoMethodError, "method `update_vfps' not accessible at the time it was called"
      end
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
