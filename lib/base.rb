require 'colorize'
require 'pry'
require 'curses'
require 'require_all'
lib_folder = File.expand_path("..", __FILE__)
require_all lib_folder

module Base

  class IllegalMove < StandardError; end
  class FormatError < StandardError; end

  NEW_LINE_SYMBOL = "\n"

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
    end_screen = game_instance.user_interface.refresh_board!
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

  def fetch_class_from_symbol(symbol)
    words = symbol.to_s.split("_")
    class_name = words.inject("") { |name, word| name += word.capitalize }
    return Kernel.const_get(class_name.to_sym)
  end

end
