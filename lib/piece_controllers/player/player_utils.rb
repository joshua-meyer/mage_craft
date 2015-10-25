require "curses"

module Base
  module PlayerUtils

  def get_input(info_string = nil)
    i_win = @game_board.refresh_board!
    @board_window.addstr(info_string)
    resp = @board_window.getch
    i_win.clear
    @game_board.refresh_board!
    return resp
  end

  def attempt_to_move_to(location)
    begin
      @game_board.move_piece(@game_piece,location)
      return "done"
    rescue IllegalMove => e
      @game_board.refresh_board!
      return "#{e}\nPress Ctrl + C to quit, or try again."
    end
  end

  def try_to_spawn_piece(spell,location)
    begin
      @game_piece.spawn_piece(spell,location)
      return "done"
    rescue IllegalMove, ArgumentError => e
      @game_board.refresh_board!
      return "#{e}\nPress q to not cast a spell, or try again."
    end
  end

  def have_player_pick_from_spell_list(list, instruction_text)
    option_index = 0
    resp = nil
    until resp == 10 or resp == "q"
      resp = show_list(list, option_index, instruction_text)
      option_index += interpret_response(resp)
      option_index = 0 if option_index < 0
      option_index = list.length - 1 if option_index >= list.length
      Curses.refresh
    end

    if resp == "q"
      return "q"
    else
      return list.keys[option_index]
    end
  end

  def show_list(list, list_position, message)
    spell_list = construct_spell_list(list)
    list_win = @game_board.refresh_board!
    list_win.addstr(message + "\n")
    spell_list.each_with_index do |word, i|
      list_win.addstr(word)
      list_win.addstr(" <-") if i == list_position
      list_win.addstr("\n")
    end
    response = list_win.getch
    response.downcase! if response.is_a? String
    list_win.clear
    @game_board.refresh_board!
    return response
  end

  def construct_spell_list(spells)
    sl = []
    spells.each do |name, spell|
      sl << "#{name} - #{spell[:manna_cost]}"
    end
    return sl
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

  end
end
