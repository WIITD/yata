local sd = require("res/savedata")
local cs = require("res/cscreen")
require("res/theme")

-- ----------COMMANDS----------
function commands()
  local words = {}
  if _u_input == "" then return end
  for word in _u_input:gmatch("%w+") do table.insert(words, word) end

  -- ----------HELP----------
  if  words[1] == "help" then
    mem()
    _todo_table = {}
    if words[2] == nil then
      table.insert(_todo_table, "> add              (add entry)")
      table.insert(_todo_table, "> rm               (remove entry)")
      table.insert(_todo_table, "> edit             (edit entry)")
      table.insert(_todo_table, "> rep              (edit word)")
      table.insert(_todo_table, "> copy             (copy entry to copyboard)")
      table.insert(_todo_table, "> insert           (insert entry to index)")
      table.insert(_todo_table, "> undo             (undo last action)")
      table.insert(_todo_table, "> sep              (insert separator)")
      table.insert(_todo_table, "> save             (save current list)")
      table.insert(_todo_table, "> load             (load list)")
      table.insert(_todo_table, "> export           (export list)")
      table.insert(_todo_table, "> theme            (change app theme)")
      table.insert(_todo_table, "> clear            (clear list)")
      table.insert(_todo_table, "> dir              (open save directory)")
      table.insert(_todo_table, "> index            (display index number)")
      table.insert(_todo_table, "> resize           (turn on/off resizing window)")
      table.insert(_todo_table, "> quit             (quit from app)")
      table.insert(_todo_table, "> help             (display commands list)")
      _g_input = "type 'help command' for more info"

    elseif words[2] == "add" then
      table.insert(_todo_table, "'add' allows you to add")
      table.insert(_todo_table, "new entry to the list")
      _g_input = "enter 'clear' to clear the list"

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

    elseif words[2] == "unsert" then
      table.insert(_todo_table, "'insert' allows you to insert entry")
      table.insert(_todo_table, "to given index and push other below")

    elseif words[2] == "sep" then
      table.insert(_todo_table, "'sep' will add separator as a next entry")
      _g_input = "enter 'clear' to clear the list"

    elseif words[2] == "export" then
      table.insert(_todo_table, "'export' allows you to export list as")
      table.insert(_todo_table, "image of text file")
      table.insert(_todo_table, ">    export text 'name'")
      table.insert(_todo_table, ">    export image 'name'")
      table.insert(_todo_table, "file will be saved to app save directory")
      table.insert(_todo_table, "which on your device is:")
      table.insert(_todo_table, "'".._app.dir.."'")
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
      table.insert(_todo_table, "'undo' allows you to undo actions")
      table.insert(_todo_table, "of the last 20 commands that")
      table.insert(_todo_table, "in some way changed list")
      _g_input = "enter 'clear' to clear the list"

    elseif words[2] == "clear" then
      table.insert(_todo_table, "'clear' clears curren list")
      _g_input = "enter 'clear' to clear the list"

     elseif words[2] == "dir" then
      table.insert(_todo_table, "'dir' opens save directory")
      table.insert(_todo_table, "'".._app.dir.."'")
      _g_input = "enter 'clear' to clear the list"

    elseif words[2] == "index" then
      table.insert(_todo_table, "'index' allows you to turn on/off displaying")
      table.insert(_todo_table, "numbers of indexes")
      _g_input = "enter 'clear' to clear the list"

    elseif words[2] == "resize" then
      table.insert(_todo_table, "'resize' allows you to turn on/off")
      table.insert(_todo_table, "window resizeing")
      _g_input = "enter 'clear' to clear the list"

    elseif words[2] == "quit" then
      table.insert(_todo_table, "'quit' quits from the app")
      _g_input = "enter 'clear' to clear the list"

    elseif words[2] == "theme" then
      table.insert(_todo_table, "'theme' allows you to change the theme")
      table.insert(_todo_table, "built-in themes: eclipse, ice, nord")
      table.insert(_todo_table, "")
      table.insert(_todo_table, "custom theme can be also created by:")
      table.insert(_todo_table, ">     theme custom 'name'")
      table.insert(_todo_table, "to edit theme type 'dir' to open save directory")
      table.insert(_todo_table, "and edit file 'name'.yatf")
      table.insert(_todo_table, "colors are rgb values divided by 255")
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

  -- ----------ADD----------
  elseif words[1] == "add" then
    if #_todo_table >= 18 then _u_input = "" return end
    local str = _u_input:gsub("add ", "")
    mem()
    table.insert(_todo_table, str)

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

  -- ----------INSERT----------
  elseif  words[1] == "insert" then
    if tonumber(words[2]) == nil or _todo_table[tonumber(words[2])] == nil then
      _u_input = ""
      _g_input = "undefined index"
      return
    end
    local num_index = tonumber(words[2])
    if words[3] == nil then words[3] = "" end
    mem()
    table.insert(_todo_table, num_index, words[3])
    _g_input = "entry inserted to index "..num_index

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
    _g_input = "index "..num_index.." edited"

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
    _g_input = "word from index "..num_index.." replaced"


  -- ----------SEP----------
  elseif  words[1] == "sep" then
    if #_todo_table >= 18 then _u_input = "" return end
    mem()
    table.insert(_todo_table, "------------------------------------------------")
    _g_input = "separator inserted"

  -- ----------EXPORT----------
  elseif  words[1] == "export" then
    if words[2] == nil then
      _u_input = ""
      _g_input = "no export type"
      return
    end

    -- ----------IMAGE----------
    if words[2] == "image" then
      if words[3] == nil then
        _u_input = ""
        love.graphics.captureScreenshot("image.png")
        _g_input = "image saved"
        return
      end
      _u_input = ""
      love.graphics.captureScreenshot(words[3]..".png")
      _g_input = "image saved"

    -- ----------TEXT----------
    elseif words[2] == "text" then
      local text = ""

      for i = 1, #_todo_table do
        text = text.._todo_table[i].."\n"
      end
      if words[3] == nil then
        _u_input = ""
        love.filesystem.write("text.txt", text)
        _g_input = "list saved as 'text.txt'"
        return
      end
      _u_input = ""
      love.filesystem.write(words[3]..".txt", text)
      _g_input = "list saved as '"..words[3]..".txt'"
    else
      _u_input = ""
      _g_input = "export type not found"
    end

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
    if #_mem == 0 then
      _u_input = ""
      _g_input = ""
      return
    end
    _todo_table = _mem[#_mem]
    table.remove(_mem, #_mem)
    _g_input = "last action undone"

  -- ----------THEME----------
  elseif  words[1] == "theme" then
    if words[2] == nil then _u_input = "" _g_input = "themes: eclipse, ice, nord" return end
    if words[2] == "custom" then theme_save(words[3])
    elseif words[2] == "eclipse" then _app.theme = theme_eclipse()
    elseif words[2] == "ice" then _app.theme = theme_ice()
    elseif words[2] == "nord" then _app.theme = theme_nord()
    else
      local theme = theme_load(words[2])
      if theme == nil then return end
      _app.theme = theme
    end

  -- ----------QUIT----------
  elseif  words[1] == "quit" then
    love.event.quit()

  -- ----------RESIZE----------
  elseif  words[1] == "index" then
    _app.index = not _app.index
   if _app.index then
      _g_input = "index number on"
    else
      _g_input = "index number off"
    end

  -- ----------RESIZE----------
  elseif  words[1] == "resize" then
    _app.flags.resizable = not _app.flags.resizable
    cs.update(_app.w, _app.h)
    love.window.setMode(_app.w, _app.h, _app.flags)
    if _app.flags.resizable then
      _g_input = "window is now resizable"
    else
      _g_input = "window is not resizable now"
    end

  -- ----------DIR----------
  elseif  words[1] == "dir" then
    love.system.openURL("file://".._app.dir)
    _g_input = "save directory opened"

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
  if #str > 52 then
    _u_input = ""
    _g_input = "cannot past more then 52 chars + command"
    return
  end
  _u_input = _u_input..love.system.getClipboardText()
end

-- ----------MEMORY----------
function mem()
  table.insert(_mem, tb_copy(_todo_table))
  if #_mem > 20 then table.remove(_mem, 1) end
end

function tb_copy(table)
  local table2 = {}
  for k,v in pairs(table) do
    table2[k] = v
  end
  return table2
end
