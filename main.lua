local utf8 = require("utf8")
local sd = require("res/savedata")
require("res/commands")
require("res/theme")

function love.load(args)
  _font = love.graphics.setNewFont("res/JetBrainsMono.ttf", 30)
  love.keyboard.setKeyRepeat(true)

  _app = {}
  _app.w = love.graphics.getWidth()
  _app.h = love.graphics.getHeight()
  _app.sx = 1
  _app.sy = 1
  _app.theme = theme_eclipse()
  _app.dir = love.filesystem.getSaveDirectory()

  _todo_table = {}
  _mem = {}

  _action_table = {
                  {action = "return", func = function() commands() end},
                  {action = "backspace", func = function() _u_input = _u_input:sub(1, -2) end},
                  {action = "escape", func = function() love.event.quit() end},
  }

  _timer = 0

  _cursor = "█"

  _u_input = ""
  _g_input = "type 'help' to get info about commands"

  if args[1] ~= nil then
    if love.filesystem.getInfo(args[1]..".yasf", "file") == nil then
      _u_input = ""
      _g_input = "file not found"
      return
    end
    _todo_table = sd.load(args[1]..".yasf")
  end
end


-- ----------DRAW----------
function love.draw()
  love.graphics.setBackgroundColor(_app.theme.bg)
  love.graphics.setColor(_app.theme.fg)
  love.graphics.rectangle("fill", 0, _app.h-50, _app.w, _app.h)
  if _u_input == "" and _g_input ~= "" then
    love.graphics.setColor(_app.theme.wt)
    love.graphics.print(">> ".._g_input, 5, _app.h-45, 0)
  else
    love.graphics.setColor(_app.theme.tx)
    love.graphics.print(">> ".._u_input.._cursor, 5, _app.h-45, 0)
  end
  for i = 1, #_todo_table do
    love.graphics.setColor(_app.theme.tx)
    love.graphics.print(_todo_table[i], 5, -25+(i*30), 0)
  end
end


-- ----------UPDATE----------
function love.update()
  _timer = _timer + 1

  if _timer >= 20 then
    if _cursor == "█" then _cursor = " "
    else _cursor = "█" end
    _timer = 0
  end
end


-- ----------KEYPRESSED----------
function love.keypressed(key)
  for i = 1, #_action_table do
    if key == _action_table[i].action then
      _action_table[i].func()
      break
    end
  end

  if key == "lctrl" and key == "v" then
    paste()
  end

  print("KEY >> "..key)
end


-- ----------TEXTINPUT----------
function love.textinput(text)
  if #_u_input < 40 then
    _u_input = _u_input..text
    if _g_input ~= "" then _g_input = "" end
  end
end

function love.lowmemory()
    collectgarbage()
end
