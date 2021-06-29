local utf8 = require("utf8")
local sd = require("res/savedata")
 
function love.load(args)
  love.graphics.setBackgroundColor(0.15,0.15,0.16)
  love.graphics.setDefaultFilter("nearest", "nearest")
  FONT = love.graphics.setNewFont("res/JetBrainsMono.ttf", 30)
  love.keyboard.setKeyRepeat(true)

  SCREEN = {}
  SCREEN.w = love.graphics.getWidth()
  SCREEN.h = love.graphics.getHeight()
  SCREEN.sx = 1
  SCREEN.sy = 1

  TODO_TABLE = {}

  ACTION_TABLE = {
                  {action = "return", func = function() commands() end},
                  {action = "backspace", func = function() _u_input = _u_input:sub(1, -2) end},
                  {action = "escape", func = function() love.event.quit() end},
  }

  TIME = 0

  INPUT = true
  INPUT_CHAR = "█"

  _u_input = ""
  _g_input = ""
  
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
  love.graphics.setColor(0.38,0.38,0.44)
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

  if key == "rcontrol" and "v" then paste() end

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
    table.insert(TODO_TABLE, str)

  -- ----------EDIT----------
  elseif words[1] == "edit" then
    local num_index = tonumber(words[2])
    local str = _u_input:gsub("edit "..num_index.." ", "")
    table.remove(TODO_TABLE, num_index)
    table.insert(TODO_TABLE, num_index, str)

  -- ----------RM----------
  elseif  words[1] == "rm" then
    local num_index = tonumber(words[2])
    table.remove(TODO_TABLE, num_index)

  -- ----------HELP----------
  elseif  words[1] == "help" then
    TODO_TABLE = {}
    table.insert(TODO_TABLE, 1, "> add 'entry'      (add entry)")
    table.insert(TODO_TABLE, 2, "> rm 'num'         (remove entry)")
    table.insert(TODO_TABLE, 3, "> edit 'num' 'text'(edit entry)")
    table.insert(TODO_TABLE, 4, "> sep              (insert separator)")
    table.insert(TODO_TABLE, 5, "> save 'name'      (save current list)")
    table.insert(TODO_TABLE, 6, "> load 'name'      (load list)")
    table.insert(TODO_TABLE, 7, "> clip 'num'       (copy entry to clipboard)")
    table.insert(TODO_TABLE, 8, "> clear            (clear list)")
    table.insert(TODO_TABLE, 9, "> quit             (quit from app)")

  -- ----------SEP----------
  elseif  words[1] == "sep" then
    table.insert(TODO_TABLE, "---------------------------------------------")

  -- ----------SAVE----------
  elseif  words[1] == "save" then
    if words[2] == nil then
      _u_input = ""
      _g_input = "save file name was not given"
      return
    end
    sd.save(TODO_TABLE, words[2]..".yasf")

  -- ----------LOAD----------
  elseif  words[1] == "load" then
    if words[2] == nil then _u_input = "" _g_input = "file not found" return end
    if love.filesystem.getInfo(words[2]..".yasf", "file") == nil then
      _u_input = ""
      _g_input = "file not found"
      return
    end
    TODO_TABLE = sd.load(words[2]..".yasf")

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

  -- ----------QUIT----------
  elseif  words[1] == "quit" then
    love.event.quit()

  -- ----------CLEAR----------
  elseif  words[1] == "clear" then
    TODO_TABLE = {}
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
