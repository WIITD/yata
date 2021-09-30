local sd = require("res/savedata")

function theme_eclipse()
  local theme= {
    {0.15,0.15,0.16}, -- bg
    {0.20,0.20,0.22}, -- input bat
    {0.38,0.38,0.44}, -- text
    {0.68,0.28,0.44}, -- info text on input bar
    {0.47,0.75,0.18}, -- done
    {0.75,0.18,0.27}, -- fix
    {0.93,0.87,0.16}, -- important
  }
  _g_input = "theme changed"
  return theme
end

function theme_snow()
  local theme= {
    {0.96,0.96,0.96},
    {0.90,0.91,0.90},
    {0.13,0.13,0.13},
    {0.32,0.32,0.32},
    {0.17,0.92,0.31},
    {0.92,0.17,0.24},
    {0.92,0.77,0.17},
  }
  _g_input = "theme changed"
  return theme
end

function theme_nord()
  local theme= {
    {0.18,0.20,0.25},
    {0.23,0.26,0.32},
    {0.72,0.75,0.78},
    {0.40,0.45,0.53},
    {0.63,0.74,0.54},
    {0.74,0.38,0.41},
    {0.92,0.79,0.54},
  }
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

  for i = 1, 7 do
    for j = 1, 3 do
      if type(theme[i][j]) ~= "number" then
        _u_input = ""
        _g_input = "error while loading one of the colors"
        return
      end
    end
  end

  _g_input = "theme changed"
  return theme
end

function theme_save(name)
  if name == nil or name == " " then
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
  for i = 1, 7 do
    for j = 1, 3 do
      if type(theme[i][j]) ~= "number" then
        print("error: theme"..theme[j].." "..theme[i][j])
        return
      end
    end
  end

  return theme
end
