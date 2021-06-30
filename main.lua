local utf8 = require("utf8")
local sd = require("res/savedata")

function love.load(args)
  love.graphics.setDefaultFilter("nearest", "nearest")
  FONT = love.graphics.setNewFont("res/JetBrainsMono.ttf", 30)
  love.keyboard.setKeyRepeat(true)

  SCREEN = {}
  SCREEN.w = love.graphics.getWidth()
  SCREEN.h = love.graphics.getHeight()
  SCREEN.sx = 1
  SCREEN.sy = 1

  love.graphics.setBackgroundColor(0.15,0.15,0.16)

  TODO_TABLE = {}
  MEM = {}

  ACTION_TABLE = {
                  {action = "return", func = function() commands() end},
                  {action = "backspace", func = function() _u_input = _u_input:sub(1, -2) end},
                  {action = "escape", func = function() love.event.quit() end},
  }

  TIME = 0

  INPUT = true
  INPUT_CHAR = "█"

  _u_input = ""
  _g_input = "type 'help' to get info about commands"

  if args[1] ~= nil then
    if love.filesystem.getInfo(args[1]..".yasf", "file") == nil then
      _u_input = ""
      _g_input = "file not found"
      return
    end
    TODO_TABLE = sd.load(args[1]..".yasf")
  end
end

-- ----------DRAW----------
function love.draw()
  love.graphics.setColor(0.20,0.20,0.22)
  love.graphics.rectangle("fill", 0, SCREEN.h-50, SCREEN.w, SCREEN.h)
  if _u_input == "" and _g_input ~= "" then
    love.graphics.setColor(0.68,0.28,0.44)
    love.graphics.print(">> ".._g_input, 5, SCREEN.h-45, 0)
  else
    love.graphics.setColor(0.38,0.38,0.44)
    love.graphics.print(">> ".._u_input..INPUT_CHAR, 5, SCREEN.h-45, 0)
  end
  for i = 1, #TODO_TABLE do
    love.graphics.setColor(0.38,0.38,0.44)
    love.graphics.print(TODO_TABLE[i], 5, -25+(i*30), 0)
  end
end


-- ----------UPDATE----------
function love.update()
  TIME = TIME + 1

  if TIME >= 20 then
    if INPUT_CHAR == "█" then INPUT_CHAR = " "
    else INPUT_CHAR = "█" end
    TIME = 0
  end
end

-- ----------KEYPRESSED----------
function love.keypressed(key)
  for i = 1, #ACTION_TABLE do
    if key == ACTION_TABLE[i].action then
      ACTION_TABLE[i].func()
      break
    end
  end

  if key == "lctrl" and "v" then paste() end

  print("KEY >> "..key)
end

-- ----------TEXTINPUT----------
function love.textinput(text)
  if INPUT then
    if #_u_input < 40 then
      _u_input = _u_input..text
      if _g_input ~= "" then _g_input = "" end
    end
  end
end

-- ----------COMMANDS----------
function commands()
  local words = {}
  if _u_input == "" then return end
  if #TODO_TABLE >= 18 then return end
  for word in _u_input:gmatch("%w+") do table.insert(words, word) end

  -- ----------ADD----------
  if words[1] == "add" then
    local str = _u_input:gsub("add ", "")
    mem()
    table.insert(TODO_TABLE, str)

  -- ----------EDIT----------
  elseif words[1] == "edit" then
    local num_index = tonumber(words[2])
    local str = _u_input:gsub("edit "..num_index.." ", "")
    mem()
    table.remove(TODO_TABLE, num_index)
    table.insert(TODO_TABLE, num_index, str)

  -- ----------REPLACE----------
  elseif words[1] == "rep" then
    local num_index = tonumber(words[2])
    local old = words[3]
    local str = _u_input:gsub("rep "..num_index.." "..old.." ", "")
    local str_entry = TODO_TABLE[num_index]
    print(str_entry)
    str_entry = str_entry:gsub(old, str)
    print(str_entry)
    mem()
    table.remove(TODO_TABLE, num_index)
    table.insert(TODO_TABLE, num_index, str_entry)

  -- ----------RM----------
  elseif  words[1] == "rm" then
    local num_index = tonumber(words[2])
    mem()
    table.remove(TODO_TABLE, num_index)
    _g_input = "index "..num_index.." removed"

  -- ----------HELP----------
  elseif  words[1] == "help" then
    mem()
    TODO_TABLE = {}
    if words[2] == nil then
      table.insert(TODO_TABLE, "> add              (add entry)")
      table.insert(TODO_TABLE, "> rm               (remove entry)")
      table.insert(TODO_TABLE, "> edit             (edit entry)")
      table.insert(TODO_TABLE, "> rep              (edit entry)")
      table.insert(TODO_TABLE, "> sep              (insert separator)")
      table.insert(TODO_TABLE, "> save             (save current list)")
      table.insert(TODO_TABLE, "> load             (load list)")
      table.insert(TODO_TABLE, "> clip             (copy entry to clipboard)")
      table.insert(TODO_TABLE, "> undo             (undo last action)")
      table.insert(TODO_TABLE, "> clear            (clear list)")
      table.insert(TODO_TABLE, "> quit             (quit from app)")
      table.insert(TODO_TABLE, "> help             (display commands list)")
      _g_input = "type 'help command' for more info"

    elseif words[2] == "add" then
      table.insert(TODO_TABLE, "'add' allows you to add")
      table.insert(TODO_TABLE, "new entry to the list")

    elseif words[2] == "rm" then
      table.insert(TODO_TABLE, "'rm' allows you to remove specific entry")
      table.insert(TODO_TABLE, "from the list, for example:")
      table.insert(TODO_TABLE, "    rm 1")
      table.insert(TODO_TABLE, "this will remove first entry on a list")
      _g_input = "enter 'clear' to clear the list"

    elseif words[2] == "edit" then
      table.insert(TODO_TABLE, "'edit' allows you to edit specific entry")
      table.insert(TODO_TABLE, "from the list, for example:")
      table.insert(TODO_TABLE, "    edit 1 text here")
      table.insert(TODO_TABLE, "this will edit first entry and")
      table.insert(TODO_TABLE, "relpace text within it for 'text here'")
      _g_input = "enter 'clear' to clear the list"

    elseif words[2] == "rep" then
      table.insert(TODO_TABLE, "'rep' allows you to replace specific word")
      table.insert(TODO_TABLE, "from the list, for example:")
      table.insert(TODO_TABLE, "    rep 3 entyr entry")
      table.insert(TODO_TABLE, "this will replace word 'entyr' from the")
      table.insert(TODO_TABLE, "third entry with 'entry'")
      table.insert(TODO_TABLE, "relpace text within it for 'text here'")
      _g_input = "enter 'clear' to clear the list"

    elseif words[2] == "sep" then
      table.insert(TODO_TABLE, "'sep' will add separator as a next entry")
      _g_input = "enter 'clear' to clear the list"

    elseif words[2] == "save" then
      table.insert(TODO_TABLE, "'save' allows you to save list for example:")
      table.insert(TODO_TABLE, "    save test")
      table.insert(TODO_TABLE, "this will save list as a file named 'test'")
      _g_input = "enter 'clear' to clear the list"

    elseif words[2] == "load" then
      table.insert(TODO_TABLE, "'load' allows you to load list from ")
      table.insert(TODO_TABLE, "a file to list")
      table.insert(TODO_TABLE, "    load test")
      table.insert(TODO_TABLE, "this will load list from file named 'test'")
      _g_input = "enter 'clear' to clear the list"

    elseif words[2] == "clip" then
      table.insert(TODO_TABLE, "'clip' allows you to copy entry to clipboard")
      table.insert(TODO_TABLE, "    clip 1")
      table.insert(TODO_TABLE, "this will copy first entry to a clipboard")
      _g_input = "enter 'clear' to clear the list"

    elseif words[2] == "undo" then
      table.insert(TODO_TABLE, "'undo' allows you to undo actions ")
      table.insert(TODO_TABLE, "'of the last command")
      _g_input = "enter 'clear' to clear the list"

    elseif words[2] == "clear" then
      table.insert(TODO_TABLE, "'clear' clears curren list")
      _g_input = "enter 'clear' to clear the list"


    elseif words[2] == "quit" then
      table.insert(TODO_TABLE, "'quit' quits from the app")
      _g_input = "enter 'clear' to clear the list"


    elseif words[2] == "help" then
      table.insert(TODO_TABLE, "you...you want to know more about me???")
      table.insert(TODO_TABLE, "finally, so...emm...you can use me to")
      table.insert(TODO_TABLE, "get more info about other commands")
      table.insert(TODO_TABLE, "and don't worry, i'm always here ;>")
      _g_input = "enter 'clear' to clear the list"
    end
  -- ----------SEP----------
  elseif  words[1] == "sep" then
    mem()
    table.insert(TODO_TABLE, "---------------------------------------------")
    _g_input = "separator inserted"

  -- ----------SAVE----------
  elseif  words[1] == "save" then
    if words[2] == nil then
      _u_input = ""
      _g_input = "save file name was not given"
      return
    end
    sd.save(TODO_TABLE, words[2]..".yasf")
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
    TODO_TABLE = sd.load(words[2]..".yasf")
    _g_input = "file loaded"

  -- ----------CLIP----------
  elseif  words[1] == "clip" then
    if words[2] == nil then
      _u_input = ""
      _g_input = "no number given"
      return
    end
    if tonumber(words[2]) > #TODO_TABLE then
      _u_input = ""
      _g_input = "index not found"
      return
    end
    love.system.setClipboardText(TODO_TABLE[tonumber(words[2])])
    _g_input = "entry copied to clipboard"

  -- ----------QUIT----------
  elseif  words[1] == "undo" then
    TODO_TABLE = MEM


  -- ----------QUIT----------
  elseif  words[1] == "quit" then
    love.event.quit()

  -- ----------CLEAR----------
  elseif  words[1] == "clear" then
    mem()
    TODO_TABLE = {}
    _g_input = "list cleared"
  end
  _u_input = ""
end

function paste()
  local str = _u_input..love.system.getClipboardText()
  if #str > 40 then
    _u_input = ""
    _g_input = "clipboard text size is greater than 40"
    return
  end
  _u_input = _u_input..love.system.getClipboardText()
end

function mem()
  MEM = {}
  for i = 1, #TODO_TABLE do
    MEM[i] = TODO_TABLE[i]
  end
end

