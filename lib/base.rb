require 'colorize'
require 'pry'
require "curses"

module Base

  class IllegalMove < StandardError; end
  class FormatError < StandardError; end

  SYMBOL_FOR_UNKNOWN = {
    shape: "??",
    color: Curses::COLOR_RED,
    attribute: Curses::A_NORMAL
  }
  DEFAULT_IF_LOSE_DO = Proc.new do |game|
    display_end_message(game, "Oh no, you lost!", Curses::COLOR_RED)
  end
  DEFAULT_IF_WIN_DO = Proc.new do |game|
    display_end_message(game, "Yay, you won!", Curses::COLOR_GREEN)
  end

  def display_end_message(game_instance, message, curses_color)
    end_screen = game_instance.game_board.refresh_board!
    Curses.init_pair(curses_color, curses_color, Curses::COLOR_BLACK)
    end_screen.attron(Curses.color_pair(curses_color)|Curses::A_BLINK) do
      end_screen.addstr(message)
    end
    end_screen.refresh
    sleep(1)
    end_screen.getch
  end

  def err_unless_game_piece(object)
    unless object.is_a? GamePiece
      raise IllegalMove, "#{object} is not a valid game piece" # *
    end
  end

  def require_controller_file(controller_symbol)
    # File.expand_path is sensitive to the file environment,
    # but invariant under where the program was invoked from
    lib_directory = File.expand_path("..", __FILE__)
    search_results = `find #{lib_directory}/piece_controllers -name '*#{controller_symbol.to_s}*'`
    matching_files = search_results.split("\n").select { |f| f.split(".").last == "rb" }
    matching_files.each do |file_path|
      require file_path
    end
  end

  def fetch_class_from_symbol(symbol)
    words = symbol.to_s.split("_")
    class_name = words.inject("") { |name, word| name += word.capitalize }
    return Kernel.const_get(class_name.to_sym)
  end

  def load_controller_class_from_symbol(controller_symbol)
    already_tried = false
    begin
      controller_class = fetch_class_from_symbol(controller_symbol)
    rescue NameError => e
      if already_tried
        raise NameError, e
      else
        require_controller_file(controller_symbol)
        already_tried = true
        retry
      end
    end
    return controller_class
  end

end
