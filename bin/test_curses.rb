require "curses"
include Curses

def prompt
  h = 5
  w = 5
  win = Window.new(h, w, (lines - h) / 2, (cols - w) / 2)
  win.setpos(0,0)

  r = win.getch
  win.close
  return r
end

begin
  init_screen
  crmode
  setpos((lines - 5) / 2, (cols - 5) / 2)
  test = prompt
ensure
  close_screen
end

puts "#{test}"
