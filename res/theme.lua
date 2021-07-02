local sd = require("res/savedata")

function theme_eclipse()
  local theme= {}
  theme.bg = {0.15,0.15,0.16}
  theme.fg = {0.20,0.20,0.22}
  theme.tx = {0.38,0.38,0.44}
  theme.cm = {0.68,0.28,0.44}
  _g_input = "theme changed"
  return theme
end

function theme_ice()
  local theme= {}
  theme.bg = {0.91,0.91,1.00}
  theme.fg = {0.82,0.82,1.00}
  theme.tx = {0.50,0.50,1.00}
  theme.cm = {0.64,0.64,0.86}
  _g_input = "theme changed"
  return theme
end

function theme_nord()
  local theme= {}
  theme.bg = {0.18,0.20,0.25}
  theme.fg = {0.23,0.26,0.32}
  theme.tx = {0.72,0.75,0.78}
  theme.cm = {0.40,0.45,0.53}
  _g_input = "theme changed"
  return theme
end

-- ----------THEME FUNCTIONS----------

function theme_load(name)
  if love.filesystem.getInfo(name..".yatf", "file") == nil then
    _u_input = ""
    _g_input = "file not found"
    return
  end
  local theme = sd.load(name..".yatf")

  for i = 1, 3 do
    if type(theme.bg[i]) ~= "number" then
      _u_input = ""
      _g_input = "error while loading background color"
      return

    elseif type(theme.fg[i]) ~= "number" then
      _u_input = ""
      _g_input = "error while loading foreground color"
      return

    elseif type(theme.tx[i]) ~= "number" then
      _u_input = ""
      _g_input = "error while loading text color"
      return

    elseif type(theme.cm[i]) ~= "number" then
      _u_input = ""
      _g_input = "error while loading commnets color"
      return
    end
  end

  _g_input = "theme changed"
  return theme
end

function theme_save(name)
  if name == nil then
    _u_input = ""
    _g_input = "theme name not defined"
  end
  if name == " " then
    _u_input = ""
    _g_input = "theme name not defined"
  end
  if love.filesystem.getInfo(name..".yatf", "file") ~= nil then
    _u_input = ""
    _g_input = "theme already exist"
    return
  else
    sd.save(theme_eclipse(), name..".yatf")
    _u_input = ""
    _g_input = "theme created, type 'dir' to open save directory"
    return
  end
end

function config_theme()
  if love.filesystem.getInfo("theme.yacf", "file") ~= nil then
    print("theme already saved")
  else
    sd.save(theme_eclipse(), "theme.yacf")
  end
  local theme = sd.load("theme.yacf")

  for i = 1, 3 do
    if type(theme.bg[i]) ~= "number" then
      return
    elseif type(theme.fg[i]) ~= "number" then
      return
    elseif type(theme.tx[i]) ~= "number" then
      return
    elseif type(theme.cm[i]) ~= "number" then
      return
    end
  end

  return theme
end
