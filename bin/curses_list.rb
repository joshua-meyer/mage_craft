require "curses"
include Curses

def max_length(list_of_strings)
  list_of_strings.inject(0) { |t,s| [t,s.length].max }
end

OPTIONS = [
  "ape",
  "bear",
  "cat",
  "dog",
  "elephant"
]

def show_list(list, list_position)
  width = max_length(list) + 3
  height = list.count + 4
  win = Window.new(height, width, lines - height - 1, cols - width)
  win.setpos(2, 3)
  win.addstr("\n")
  list.each_with_index do |word, i|
    win.addstr(word)
    win.addstr(" <-") if i == list_position
    win.addstr("\n")
  end
  response = win.getch
  win.close
  return response
end

def interpret_response(response)
  begin
    if response.downcase == "w"
      return -1
    elsif response.downcase == "s"
      return 1
    else
      return 0
    end
  rescue NoMethodError
    return 0
  end
end

begin
  init_screen
  option = 0
  crmode
#  show_message("Hit any key")
  setpos((lines - 5) / 2, (cols - 10) / 2)
  resp = nil
  until resp == 10
    resp = show_list(OPTIONS, option)
    option += interpret_response(resp)
    option = 0 if option < 0
    option = OPTIONS.length - 1 if option >= OPTIONS.length
    refresh
  end
  refresh
ensure
  close_screen
end

puts resp
puts OPTIONS[option]
