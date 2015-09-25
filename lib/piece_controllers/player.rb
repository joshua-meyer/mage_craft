base_path = File.expand_path("../base_controller.rb",__FILE__); require base_path

module Base
  class Player < BaseController

    def take
      @looping = true
      while @looping
        input = get_input
        new_location = derive_new_location(input)
        begin
          unless new_location == @current_location
            @game_board.move_piece(@game_piece,new_location)
          end
        rescue IllegalMove => e
          @game_board.print_board
          puts "#{e} Press Ctrl + C to quit, or try again."
          @looping = true
        end
      end
      return "done"
    end

    def get_input
      puts "You have #{@game_piece.manna} manna."
      puts "Use wasd to move, k to cast a spell, or space to rest and restore mp."
      gets.chomp.downcase
    end

    def derive_new_location(input)
      if ["w","a","s","d"].include? input
        @looping = false
        return interpret_wasd(input)
      elsif input == " "
        @game_piece.give_mp!(1)
        @looping = false
        return @current_location
      elsif input == "k"
        cast_spell
        return @current_location
      else
        return nil
      end
    end

    def interpret_wasd(input)
      case input
      when "w"
        return [@current_location[0] - 1, @current_location[1]]
      when "a"
        return [@current_location[0], @current_location[1] - 1]
      when "s"
        return [@current_location[0] + 1, @current_location[1]]
      when "d"
        return [@current_location[0], @current_location[1] + 1]
      else
        return input
      end
    end

    def cast_spell
      puts "Select a spell to cast:"
      loop do
        spell_selection = get_spell_selection
        if @game_piece.spells.has_key?(spell_selection)
          select_spell_location(spell_selection)
          break
        elsif spell_selection.downcase == "q"
          break
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
        spell_location = ask_for_spell_location
        break if spell_location == "q"
        begin
          @game_piece.spawn_piece(spell,spell_location)
          @looping = false
          break
        rescue IllegalMove => e
          puts "#{e} Press q to not cast a spell, or try again."
          @looping = true
        end
      end
      return "done"
    end

    def ask_for_spell_location
      puts "Where would you like to cast the spell?"
      puts "Use wasd to pick a square adjacent to you."
      return interpret_wasd(gets.chomp.downcase)
    end

    def self.default_symbol
      "TP".light_blue
    end

  end
end
