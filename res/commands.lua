local sd = require("res/savedata")
require("res/theme")

-- ----------COMMANDS----------
function commands()
  local words = {}
  if _u_input == "" then return end
  if #_todo_table >= 18 then return end
  for word in _u_input:gmatch("%w+") do table.insert(words, word) end

  -- ----------ADD----------
  if words[1] == "add" then
    local str = _u_input:gsub("add ", "")
    mem()
    table.insert(_todo_table, str)

  -- ----------EDIT----------
  elseif words[1] == "edit" then
    if tonumber(words[2]) == nil or _todo_table[tonumber(words[2])] == nil then
      _u_input = ""
      _g_input = "undefined index"
      return
    end
    if words[3] == nil then
      _u_input = ""
      _g_input = "undefined new entry"
      return
    end
    local num_index = tonumber(words[2])
    local str = _u_input:gsub("edit "..num_index.." ", "")
    mem()
    table.remove(_todo_table, num_index)
    table.insert(_todo_table, num_index, str)

  -- ----------REPLACE----------
  elseif words[1] == "rep" then
    if tonumber(words[2]) == nil or _todo_table[tonumber(words[2])] == nil then
      _u_input = ""
      _g_input = "undefined index"
      return
    end
    if words[3] == nil then
      _u_input = ""
      _g_input = "undefined word to replace"
      return
    end
    if words[4] == nil then
      _u_input = ""
      _g_input = "undefined new word"
      return
    end
    local num_index = tonumber(words[2])
    local old = words[3]
    local str = _u_input:gsub("rep "..num_index.." "..old.." ", "")
    local str_entry = _todo_table[num_index]
    print(str_entry)
    str_entry = str_entry:gsub(old, str)
    print(str_entry)
    mem()
    table.remove(_todo_table, num_index)
    table.insert(_todo_table, num_index, str_entry)

  -- ----------RM----------
  elseif  words[1] == "rm" then
    if tonumber(words[2]) == nil or _todo_table[tonumber(words[2])] == nil then
      _u_input = ""
      _g_input = "undefined index"
      return
    end
    local num_index = tonumber(words[2])
    mem()
    table.remove(_todo_table, num_index)
    _g_input = "index "..num_index.." removed"

  -- ----------HELP----------
  elseif  words[1] == "help" then
    mem()
    _todo_table = {}
    if words[2] == nil then
      table.insert(_todo_table, "> add              (add entry)")
      table.insert(_todo_table, "> rm               (remove entry)")
      table.insert(_todo_table, "> edit             (edit entry)")
      table.insert(_todo_table, "> rep              (edit word)")
      table.insert(_todo_table, "> sep              (insert separator)")
      table.insert(_todo_table, "> save             (save current list)")
      table.insert(_todo_table, "> load             (load list)")
      table.insert(_todo_table, "> copy             (copy entry to copyboard)")
      table.insert(_todo_table, "> undo             (undo last action)")
      table.insert(_todo_table, "> theme            (change app theme)")
      table.insert(_todo_table, "> clear            (clear list)")
      table.insert(_todo_table, "> quit             (quit from app)")
      table.insert(_todo_table, "> help             (display commands list)")
      _g_input = "type 'help command' for more info"

    elseif words[2] == "add" then
      table.insert(_todo_table, "'add' allows you to add")
      table.insert(_todo_table, "new entry to the list")

    elseif words[2] == "rm" then
      table.insert(_todo_table, "'rm' allows you to remove specific entry")
      table.insert(_todo_table, "from the list, for example:")
      table.insert(_todo_table, ">    rm 1")
      table.insert(_todo_table, "this will remove first entry on a list")
      _g_input = "enter 'clear' to clear the list"

    elseif words[2] == "edit" then
      table.insert(_todo_table, "'edit' allows you to edit specific entry")
      table.insert(_todo_table, "from the list, for example:")
      table.insert(_todo_table, ">    edit 1 text here")
      table.insert(_todo_table, "this will edit first entry and")
      table.insert(_todo_table, "relpace text within it for 'text here'")
      _g_input = "enter 'clear' to clear the list"

    elseif words[2] == "rep" then
      table.insert(_todo_table, "'rep' allows you to replace specific word")
      table.insert(_todo_table, "from the list, for example:")
      table.insert(_todo_table, ">    rep 3 entyr entry")
      table.insert(_todo_table, "this will replace word 'entyr' from the")
      table.insert(_todo_table, "third entry with 'entry'")
      table.insert(_todo_table, "relpace text within it for 'text here'")
      _g_input = "enter 'clear' to clear the list"

    elseif words[2] == "sep" then
      table.insert(_todo_table, "'sep' will add separator as a next entry")
      _g_input = "enter 'clear' to clear the list"

    elseif words[2] == "save" then
      table.insert(_todo_table, "'save' allows you to save list for example:")
      table.insert(_todo_table, ">    save test")
      table.insert(_todo_table, "this will save list as a file named 'test'")
      _g_input = "enter 'clear' to clear the list"

    elseif words[2] == "load" then
      table.insert(_todo_table, "'load' allows you to load list from ")
      table.insert(_todo_table, "a file to list")
      table.insert(_todo_table, ">    load test")
      table.insert(_todo_table, "this will load list from file named 'test'")
      _g_input = "enter 'clear' to clear the list"

    elseif words[2] == "copy" then
      table.insert(_todo_table, "'copy' allows you to copy entry to copyboard")
      table.insert(_todo_table, ">    copy 1")
      table.insert(_todo_table, "this will copy first entry to a copyboard")
      _g_input = "enter 'clear' to clear the list"

    elseif words[2] == "undo" then
      table.insert(_todo_table, "'undo' allows you to undo actions ")
      table.insert(_todo_table, "'of the last command")
      _g_input = "enter 'clear' to clear the list"

    elseif words[2] == "clear" then
      table.insert(_todo_table, "'clear' clears curren list")
      _g_input = "enter 'clear' to clear the list"


    elseif words[2] == "quit" then
      table.insert(_todo_table, "'quit' quits from the app")
      _g_input = "enter 'clear' to clear the list"

    elseif words[2] == "theme" then
      table.insert(_todo_table, "'theme' allows you to change the theme")
      table.insert(_todo_table, "themes: eclipse, ice, nord")
      _g_input = "enter 'clear' to clear the list"

    elseif words[2] == "help" then
      table.insert(_todo_table, "you...you want to know more about me???")
      table.insert(_todo_table, "finally, so...emm...you can use me to")
      table.insert(_todo_table, "get more info about other commands")
      table.insert(_todo_table, "and don't worry, i'm always here ;>")
      _g_input = "enter 'clear' to clear the list"
    else
      _g_input = "help entry not found"
    end
  -- ----------SEP----------
    elseif  words[1] == "sep" then
      mem()
      table.insert(_todo_table, "---------------------------------------------")
      _g_input = "separator inserted"

  -- ----------SAVE----------
  elseif  words[1] == "save" then
    if words[2] == nil then
      _u_input = ""
      _g_input = "save file name was not given"
      return
    end
    sd.save(_todo_table, words[2]..".yasf")
    _g_input = "file saved"

  -- ----------LOAD----------
  elseif  words[1] == "load" then
    if words[2] == nil then _u_input = "" _g_input = "file not found" return end
    if love.filesystem.getInfo(words[2]..".yasf", "file") == nil then
      _u_input = ""
      _g_input = "file not found"
      return
    end
    mem()
    _todo_table = sd.load(words[2]..".yasf")
    _g_input = "file loaded"

  -- ----------COPY----------
  elseif  words[1] == "copy" then
    if words[2] == nil then
      _u_input = ""
      _g_input = "no number given"
      return
    end
    if tonumber(words[2]) > #_todo_table then
      _u_input = ""
      _g_input = "index not found"
      return
    end
    love.system.setClipboardText(_todo_table[tonumber(words[2])])
    _g_input = "entry copied to copyboard"

  -- ----------UNDO----------
  elseif  words[1] == "undo" then
    _todo_table = _mem
    _g_input = "last action undone"

  -- ----------THEME----------
  elseif  words[1] == "theme" then
    if words[2] == nil then _u_input = "" _g_input = "themes: eclipse, ice, nord" return end
    if words[2] == "eclipse" then _app.theme = theme_eclipse()
    elseif words[2] == "ice" then _app.theme = theme_ice()
    elseif words[2] == "nord" then _app.theme = theme_nord()
    else _u_input = "" _g_input = "theme not found" return end
    _g_input = "theme changed"

  -- ----------QUIT----------
  elseif  words[1] == "quit" then
    love.event.quit()

  -- ----------CLEAR----------
  elseif  words[1] == "clear" then
    mem()
    _todo_table = {}
    _g_input = "list cleared"
  end
  _u_input = ""
end

-- ----------PASTE FROM CLIPBOARD----------
function paste()
  local str = _u_input..love.system.getClipboardText()
  if #str > 40 then
    _u_input = ""
    _g_input = "cannot past more then 40 chars + command"
    return
  end
  _u_input = _u_input..love.system.getClipboardText()
end

-- ----------MEMORY----------
function mem()
  _mem = {}
  for i = 1, #_todo_table do
    _mem[i] = _todo_table[i]
  end
end

