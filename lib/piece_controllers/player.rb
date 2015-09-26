base_path = File.expand_path("../base_controller.rb",__FILE__); require base_path

module Base
  class Player < BaseController

    def secondary_initialization
      @key_map = @game_board.map_keyboard_keys_to_adjacent_positions(@current_location)
    end

    def take
      @game_board.print_board
      loop do
        input = get_input
        if @key_map.keys.include? input
          break if attempt_to_move_to(@key_map[input]) == "done"
        elsif input == " "
          @game_piece.give_mp!(1)
          break
        elsif input == "k"
          break if cast_spell == "done"
        else
          puts "Sorry, I don't know what you mean by #{input}."
        end
      end
      return "done"
    end

    def get_input
      puts "You have #{@game_piece.manna} manna."
      puts "Use #{@key_map.keys.join("")} to move, k to cast a spell, or space to rest and restore mp."
      gets.chomp.downcase
    end

    def attempt_to_move_to(location)
      begin
        @game_board.move_piece(@game_piece,location)
        return "done"
      rescue IllegalMove => e
        @game_board.print_board
        puts "#{e} Press Ctrl + C to quit, or try again."
        return "fail"
      end
    end

    def cast_spell
      puts "Select a spell to cast:"
      loop do
        spell_selection = get_spell_selection
        if @game_piece.spells.has_key?(spell_selection)
          break if select_spell_location(spell_selection) == "done"
        elsif spell_selection.downcase == "q"
          return "quit"
        else
          puts "That's not a spell in your inventory."
          puts "Select a spell to cast, or enter q to not cast a spell."
        end
      end
      return "done"
    end

    def get_spell_selection
      @game_piece.spells.each do |spell_name,spell_template|
        puts spell_name
      end
      return gets.chomp.downcase
    end

    def select_spell_location(spell)
      loop do
        location_choice = ask_for_spell_location
        if @key_map.keys.include? location_choice
          break if try_to_spawn_piece(spell,@key_map[location_choice]) == "done"
        elsif location_choice == "q"
          return "quit"
        else
          puts "Sorry, I don't know what you mean by #{location_choice}."
        end
      end
      return "done"
    end

    def ask_for_spell_location
      puts "Where would you like to cast the spell?"
      puts "Use #{@key_map.keys.join("")} to pick a square adjacent to you."
      return gets.chomp.downcase
    end

    def try_to_spawn_piece(spell,location)
      begin
        @game_piece.spawn_piece(spell,location)
        return "done"
      rescue IllegalMove, ArgumentError => e
        @game_board.print_board
        puts "#{e} Press q to not cast a spell, or try again."
        return "quit"
      end
    end

    def self.default_symbol
      "TP".light_blue
    end

  end
end
