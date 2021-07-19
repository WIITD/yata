local utf8 = require("utf8")
local sd = require("res/savedata")
local cs = require("res/cscreen")
require("res/commands")
require("res/theme")

function love.load(args)
  _l_font = love.graphics.newFont("res/JetBrainsMono.ttf", 26)
  _u_font = love.graphics.newFont("res/JetBrainsMono.ttf", 24)
  _i_font = love.graphics.newFont("res/JetBrainsMono.ttf", 16)
  love.keyboard.setKeyRepeat(true)

  _app = {}
  _app.w, _app.h, _app.flags = love.window.getMode()
  _app.dir = love.filesystem.getSaveDirectory()
  _app.theme = config_theme() or theme_eclipse()
  _app.index = false

  cs.init(_app.w, _app.h, true)

  _todo_table = {}
  _mem = {}

  _action_table = {
                  {action = "return", func = function() commands() sd.save(_todo_table,".cache") end},
                  {action = "backspace", func = function() _u_input = _u_input:sub(1, -2) end},
                  {action = "escape", func = function() love.event.quit() end},
  }

  _timer = 0

  _cursor = "█"

  _u_input = ""
  _g_input = "type 'help' to get info about commands"
  
  if love.filesystem.getInfo(".cache", "file") == nil then
    sd.save(_todo_table, ".cache")
  else
    _todo_table = sd.load(".cache")
  end
end


-- ----------DRAW----------
function love.draw()
  cs.apply()
  cs.setColor(_app.theme.bg)
  love.graphics.setBackgroundColor(_app.theme.bg)
  love.graphics.setColor(_app.theme.fg)
  if _app.index then
    love.graphics.rectangle("fill", 0, 0, 22, _app.h)
  end
  love.graphics.rectangle("fill", 0, _app.h-40, _app.w, _app.h)
  if _u_input == "" and _g_input ~= "" then
    love.graphics.setColor(_app.theme.cm)
    love.graphics.print(">> ".._g_input, _u_font, 5, _app.h-35, 0)
  else
    love.graphics.setColor(_app.theme.tx)
    love.graphics.print(">> ".._u_input.._cursor, _u_font, 5, _app.h-35, 0)
  end

  if _app.index then
    for i = 1, #_todo_table do
      love.graphics.setColor(_app.theme.cm)
      love.graphics.print(i, _i_font, 1, -18+(i*30), 0)

      love.graphics.setColor(_app.theme.tx)
      love.graphics.print(_todo_table[i] or "", _l_font, 22, -25+(i*30), 0)
    end
  else
    for i = 1, #_todo_table do
      love.graphics.setColor(_app.theme.tx)
      love.graphics.print(_todo_table[i] or "", _l_font, 15, -25+(i*30), 0)
    end
  end
  cs.cease()
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
  if _g_input ~= "" then _g_input = "" end
  for i = 1, #_action_table do
    if key == _action_table[i].action then
      _action_table[i].func()
      break
    end
  end

  if love.keyboard.isDown("lctrl")  and key == "v" then
    paste()
  end

  print("KEY >> "..key)
end

function love.keyreleased(key)

end


-- ----------TEXTINPUT----------
function love.textinput(text)
  if #_u_input < 52 then
    _u_input = _u_input..text
  end
end

function love.lowmemory()
    collectgarbage()
end


-- ----------FILE DROPPED----------
function love.filedropped(file)
  local temp = tostring(os.time())
  print(temp)
  file:open("r")
  local data = file:read()
  if data:sub(1, 6) ~= "return" then return end
  love.filesystem.write(temp, data)
  mem()
  local list = sd.load(temp)
  love.filesystem.remove(temp)
  _todo_table = list
end


-- ----------RESIZE----------
function love.resize(w, h)
	cs.update(w, h)
end


-- ----------QUIT----------
function love.quit()
    sd.save(_app.theme, "theme.yacf")
end

