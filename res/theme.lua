local sd = require("res/savedata")

function theme_eclipse()
  local theme= {}
  theme.bg = {0.15,0.15,0.16}
  theme.fg = {0.20,0.20,0.22}
  theme.tx = {0.38,0.38,0.44}
  theme.wt = {0.68,0.28,0.44}
  return theme
end

function theme_ice()
  local theme= {}
  theme.bg = {0.91,0.91,1.00}
  theme.fg = {0.82,0.82,1.00}
  theme.tx = {0.50,0.50,1.00}
  theme.wt = {0.64,0.64,0.86}
  return theme
end

function theme_nord()
  local theme= {}
  theme.bg = {0.18,0.20,0.25}
  theme.fg = {0.23,0.26,0.32}
  theme.tx = {0.72,0.75,0.78}
  theme.wt = {0.40,0.45,0.53}
  return theme
end

-- ----------THEME FUNCTIONS----------
