require 'colorize'

module Base

  class IllegalMove < StandardError; end
  class FormatError < StandardError; end

  BLANK_SPACE = "[]".light_black
  SYMBOL_FOR_UNKNOWN = "??".red
  RESERVED_SYMBOLS = [BLANK_SPACE,SYMBOL_FOR_UNKNOWN]
  DEFAULT_IF_LOSE_DO = Proc.new { puts "Oh no, you lost!".red }
  DEFAULT_IF_WIN_DO = Proc.new { puts "Yay, you won!".green }

  def is_valid_symbol?(symbol)
    begin
      return false unless symbol.is_a? String
      return false unless symbol.uncolorize.length == 2 # Needs to be the same width as blank_space
      return false if RESERVED_SYMBOLS.include? symbol
      return true
    rescue TypeError
      return false
    rescue NoMethodError
      return false
    end
  end

  def err_unless_symbol_is_valid(game_symbol)
    unless is_valid_symbol?(game_symbol)
      raise FormatError, "#{game_symbol} is not a valid symbol"
    end
  end

  def err_unless_game_piece(object)
    unless object.is_a? GamePiece
      raise IllegalMove, "#{object} is not a valid game piece" # *
    end
  end

end
