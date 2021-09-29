

-- TABLE OF COMMANDS
local cmd = {}
  -- {command, func, help}
function cmd:add(c, func, help)
  table.insert(cmd, {c, func, help})
end

function cmd:todo_add(entry, status, index)
  local en = entry or ""
  local st = status or 0
  if index == nil then
    table.insert(_todo_table, {entry, 0})
  else
    table.insert(_todo_table, index,{entry, 0})
  end
end

-- INVOKE COMMAND
function cmd:run()
 local words = {}
  if _u_input == "" then return end
  _cmd_mem = _u_input
  for word in _u_input:gmatch("%w+") do table.insert(words, word) end
  
  for c=1, #cmd do
    if type(cmd[c][1]) == "table" then
      for w=1, #cmd[c][1] do
        if cmd[c][1][w] == words[1] then cmd[c][2](words) end
      end
    else
      if cmd[c][1] == words[1] then cmd[c][2](words) end
    end
  end
  _u_input = ""
end

function cmd:back()
  _u_input = _cmd_mem
end

return cmd
