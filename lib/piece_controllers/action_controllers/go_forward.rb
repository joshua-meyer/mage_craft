base_controller_file = File.expand_path("../../base_controller.rb",__FILE__); require base_controller_file

module Base
  class GoForward < BaseController

    def take
      new_vertical = @current_location[0] + @game_piece.prps[0]
      new_horizontal = @current_location[1] + @game_piece.prps[1]
      new_position = [new_vertical,new_horizontal]
      begin
        @game_board.move_piece(@game_piece,new_position)
      rescue IllegalMove
        @game_board.remove_piece(@game_piece)
      end
      return "done"
    end

  end
end
