utf8 = require("utf8")
sd = require("res.savedata")
cs = require("res.cscreen")
cmd = require("res.commands_base")
require("res.commands_load")
require("res.theme")
require("res.misc")

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
  _app.pages = {0}
  for i = 2, 5 do
    _app.pages[i] = -542 * (i-1)
  end
  _app.page_sel = 1

  cs.init(_app.w, _app.h, true)

  _todo_table = {}
  _mem = {}
  _cmd_mem = ""

  _action_table = {
                  {action = "return", func = function() cmd:run() sd.save(_todo_table,".cache") end},
                  {action = "backspace", func = function() _u_input = _u_input:sub(1, -2) end},
                  {action = "escape", func = function() love.event.quit() end},
                  {action = "up", func = function() cmd:back() end},
                  {action = "down", func = function() _u_input = "" end},
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
  cs.setColor(_app.theme[1])
  love.graphics.setBackgroundColor(_app.theme[1])
  love.graphics.setColor(_app.theme[2])
  if _app.index then
    love.graphics.rectangle("fill", 0, 0, 22, _app.h)
  end
  if _app.index then
    for i = 1, 18*_app.page_sel do
      if i > #_todo_table then break end
      love.graphics.setColor(_app.theme[4])
      love.graphics.print(i, _i_font, 1, _app.pages[_app.page_sel]+(-18+(i*30)), 0)

      if _todo_table[i][2] > 0 and _todo_table[i][2] <= 3 then
        love.graphics.setColor(_app.theme[_todo_table[i][2]+4])
      else
        love.graphics.setColor(_app.theme[3])
      end
      love.graphics.print(_todo_table[i][1] or "", _l_font, 23, _app.pages[_app.page_sel]+(-25+(i*30)), 0)
    end
  else
    for i = 1, 18*_app.page_sel do
      if i > #_todo_table then break end
      if _todo_table[i][2] > 0 and _todo_table[i][2] <= 3 then
        love.graphics.setColor(_app.theme[_todo_table[i][2]+4])
      else
        love.graphics.setColor(_app.theme[3])
      end
      love.graphics.print(_todo_table[i][1] or "", _l_font, 15, _app.pages[_app.page_sel]+(-25+(i*30)), 0)
    end
  end

  love.graphics.setColor(_app.theme[2])
  love.graphics.rectangle("fill", 0, _app.h-40, _app.w, _app.h)
  love.graphics.rectangle("line", 0, 0, _app.w, _app.h)
  if _u_input == "" and _g_input ~= "" then
    love.graphics.setColor(_app.theme[4])
    love.graphics.print(">> ".._g_input, _u_font, 5, _app.h-35, 0)
  else
    love.graphics.setColor(_app.theme[3])
    love.graphics.print(">> ".._u_input.._cursor, _u_font, 5, _app.h-35, 0)
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
  _key = key
  if _g_input ~= ""  then _g_input = "" end
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

