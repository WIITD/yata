-- MEMORY
function mem()
  table.insert(_mem, tb_copy(_todo_table))
  if #_mem > 20 then table.remove(_mem, 1) end
end

-- COPY TABLE
function tb_copy(table)
  local table2 = {}
  for k,v in pairs(table) do
    table2[k] = v
  end
  return table2
end
