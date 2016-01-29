module Base
  class BaseUI
    attr_reader :left_edge_position, :bottom_edge_position, :board_window
    attr_accessor :game_board, :game_instance

    def new_screen!
      nil
    end

    def start_board!
      refresh_board!
    end

    def refresh_board!
      @game_board.yield_elements_of_board do |symbol|
        print_symbol(symbol)
      end
    end

    def print_symbol(symbol)
      raise NotImplementedError
    end

  end
end

