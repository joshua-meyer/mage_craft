require "curses"

base_path = File.expand_path("../../base_controller.rb", __FILE__); require base_path
utils_path = File.expand_path("../player_utils.rb", __FILE__); require utils_path

module Base
  class Player < BaseController
    include PlayerUtils

    def standard_message
      <<-M
You have #{@game_piece.manna} manna.
Use #{@key_map.keys.join("")} to move, k to cast a spell.
Or, space to rest and restore mp.
      M
    end

    def take
      @key_map = @game_board.map_keyboard_keys_to_adjacent_positions(@current_location)
      @user_interface.refresh_board!
      message = standard_message
      loop do
        input = get_input(message)
        message = standard_message
        if @key_map.keys.include? input
          result = attempt_to_move_to(@key_map[input])
          if result == "done"
            break
          else
            message = result + "\n" + standard_message
          end
        elsif input == " "
          @game_piece.give_mp!(1)
          break
        elsif input == "k"
          break if cast_spell == "done"
        else
          message = "Sorry, I don't know what you mean by #{input}.\n" + standard_message
        end
      end
      return "done"
    end

    def standard_spell_message
      <<-SM
Use w,s, and ENTER to select a spell to cast.
Or, enter q to not cast a spell.
spell_name - manna_cost:
      SM
    end

    def cast_spell
      if @game_piece.spells
        spell_message = standard_spell_message
        loop do
          spell_selection = have_player_pick_from_spell_list(@game_piece.spells, spell_message)
          spell_message = standard_spell_message
          if spell_selection == "q"
            return "quit"
          elsif not @game_piece.spells.has_key?(spell_selection)
            spell_message = <<-SM1
That's not a spell in your inventory.
Use w,s, and ENTER to select a spell to cast:
Or, enter q to not cast a spell:
spell_name - manna_cost
            SM1
          elsif @game_piece.spells[spell_selection][:manna_cost] > @game_piece.manna
            spell_message = <<-SM2
You don't have enough manna to cast that spell.
Use w,s, and ENTER to select a spell to cast:
Or, enter q to not cast a spell:
spell_name - manna_cost
            SM2
          else @game_piece.spells.has_key?(spell_selection)
            break if select_spell_location(spell_selection) == "done"
          end
        end
        return "done"
      else
        get_input("You don't have any spells")
        return "quit"
      end
    end

    def select_spell_location(spell)
      spell_location_message = standard_spell_location_message
      loop do
        location_choice = get_input(spell_location_message)
        spell_location_message = standard_spell_location_message
        if @key_map.keys.include? location_choice
          break if try_to_spawn_piece(spell,@key_map[location_choice]) == "done"
        elsif location_choice == "q"
          return "quit"
        else
          spell_location_message = <<-SLM1
Sorry, I don't know what you mean by #{location_choice}.
Use #{@key_map.keys.join("")} to pick a square adjacent to you.
Or, press q to return to the previous menu.
          SLM1
        end
      end
      return "done"
    end

    def standard_spell_location_message
      <<-SLM
Where would you like to cast the spell?
Use #{@key_map.keys.join("")} to pick a square adjacent to you.
      SLM
    end

    def self.default_symbol
      {
        shape:     "TP",
        color:     Curses::COLOR_CYAN,
        attribute: Curses::A_NORMAL
      }
    end

  end
end
