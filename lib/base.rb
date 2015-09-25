require 'colorize'

module Base

  class IllegalMove < StandardError; end
  class FormatError < StandardError; end

  def blank_space
    "[]".light_black
  end

  def symbol_for_unknown_thing
    "??".red
  end

  def reserved_symbols
    [blank_space,symbol_for_unknown_thing]
  end

  def is_valid_symbol?(symbol)
    begin
      return false unless symbol.is_a? String
      return false unless symbol.uncolorize.length == 2 # Needs to be the same width as blank_space
      return false if reserved_symbols.include? symbol
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

end
