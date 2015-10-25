require "curses"

base_board_path = File.expand_path("../../base_game_board.rb",__FILE__)
require base_board_path

square_utils_path = File.expand_path("../board_utils/square_board_utils.rb",__FILE__)
require square_utils_path

module Base
  class SquareGameBoard < BaseGameBoard
    include SquareBoardUtils
    attr_reader :left_edge_position, :bottom_edge_position
    BLANK_SPACE = { :shape => "[]", :color => Curses::COLOR_WHITE, :attribute => Curses::A_DIM }

    def generate_board(n,k = n)
      row = []
      for i in (0...k)
        row << self.class::BLANK_SPACE
      end
      board = []
      for i in (0...n)
        # Using Marshal to create a deep copy.
        board << Marshal.load(Marshal.dump(row))
      end
      return board
    end

    def start_board!
      board_width = @game_board.first.count * 2 + 1
      board_height = @game_board.count + 2
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
      @win.addstr("\n")
      @game_board.each_with_index do |row, i|
        row.each_index do |j|
          symbol = symbol_at([i,j])
          color = symbol[:color] || Curses::COLOR_WHITE
          attribute = symbol[:attribute] || Curses::A_NORMAL
          Curses.init_pair(color, color, Curses::COLOR_BLACK)
          @win.attron(Curses.color_pair(color)|attribute) do
            @win.addstr(symbol[:shape])
          end
        end
        @win.addstr("\n")
      end
      Curses.refresh
      return @win
    end

  end
end
