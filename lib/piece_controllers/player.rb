base_path = File.expand_path("../base_controller.rb",__FILE__); require base_path

module Base
  class Player < BaseController

    def take
      loop do
        input = get_input
        new_location = derive_new_location(input)
        begin
          if new_location == @current_location
            @game_piece.give_mp!(1)
          else
            @game_board.move_piece(@game_piece,new_location)
          end
          break
        rescue IllegalMove
          @game_board.print_board
          puts "That's not a valid move. Press Ctrl + C to quit, or try again."
        end
      end
      return "done"
    end

    def get_input
      puts "Use wasd to move, or space to rest and restore mp."
      gets.chomp.downcase
    end

    def derive_new_location(input)
      case input
      when "w"
        return [@current_location[0] - 1, @current_location[1]]
      when "a"
        return [@current_location[0], @current_location[1] - 1]
      when "s"
        return [@current_location[0] + 1, @current_location[1]]
      when "d"
        return [@current_location[0], @current_location[1] + 1]
      when " "
        return @current_location
      else
        return nil
      end
    end

  end
end
