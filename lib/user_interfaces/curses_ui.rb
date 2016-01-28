module Base
  class CursesUI
    attr_reader :left_edge_position, :bottom_edge_position, :board_window
    attr_accessor :game_board, :game_instance

    def new_screen!
      Curses.init_screen
      ObjectSpace.define_finalizer(self, self.class.finalize)
      Curses.setpos((Curses.lines - 5) / 2, (Curses.cols - 10) / 2)
      Curses.start_color
      @board_window = start_board!
    end

    def self.finalize
      Proc.new { Curses.close_screen }
    end

    def start_board!
      board_width = @game_board.game_board.first.count * 2 + 1
      board_height = @game_board.game_board.count + 2
      @left_edge_position = (Curses.cols / 2) - (board_width / 2)
      top_edge_position = (Curses.lines / 2) - (board_height / 2)
      window_height = Curses.lines - top_edge_position
      window_width = Curses.cols - @left_edge_position
      @win = Curses::Window.new(window_height, window_width, top_edge_position, @left_edge_position)
      @bottom_edge_position = (Curses.lines / 2) + (board_height / 2) + 1
      refresh_board!
    end

    def refresh_board!
      @win.clear
      @win.setpos(0, 0)
      @game_board.yield_elements_of_board do |symbol|
        print_symbol(symbol)
      end
      Curses.refresh
      return @win
    end

    def print_symbol(symbol)
      if symbol == NEW_LINE_SYMBOL
        @win.addstr("\n")
      else
        color = symbol[:color] || Curses::COLOR_WHITE
        attribute = symbol[:attribute] || Curses::A_NORMAL
        Curses.init_pair(color, color, Curses::COLOR_BLACK)
        @win.attron(Curses.color_pair(color)|attribute) do
          @win.addstr(symbol[:shape])
        end
      end
    end

  end
end
