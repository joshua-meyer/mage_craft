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

  def require_controller_file(controller_symbol)
    # File.expand_path is sensitive to the file environment,
    # but invariant under where the program was invoked from
    lib_directory = File.expand_path("..",__FILE__)
    search_results = `find #{lib_directory}/piece_controllers -name '*#{controller_symbol.to_s}*'`
    matching_files = search_results.split("\n")
    matching_files.each do |file_path|
      require file_path
    end
  end

  def fetch_class_from_symbol(symbol)
    words = symbol.to_s.split("_")
    class_name = words.inject("") { |name,word| name += word.capitalize }
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
