require 'colorize'
require 'pry'

module Base

  class IllegalMove < StandardError; end
  class FormatError < StandardError; end

  SYMBOL_FOR_UNKNOWN = "??".red
  DEFAULT_IF_LOSE_DO = Proc.new { puts "Oh no, you lost!".red }
  DEFAULT_IF_WIN_DO = Proc.new { puts "Yay, you won!".green }

  def err_unless_game_piece(object)
    unless object.is_a? GamePiece
      raise IllegalMove, "#{object} is not a valid game piece" # *
    end
  end

end
