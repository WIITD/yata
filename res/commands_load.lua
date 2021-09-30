  -- #HELP
cmd:add("help",
  function(c)
    if c[2] == "debug" then
      local str = ""
      for cm=1, #cmd do
        str = str..cmd[cm][3].."\n"
      end
      love.filesystem.write("debug_help.txt", str)
      _g_input = "debug help list saved"
      return
    end

    if c[2] == nil then
      _u_input = ""
      _g_input = "type 'help 'command'' for more info"
      cmds = ""
      for i=1, #cmd do
        if type(cmd[i][1]) == "table" then
          cmds = cmds.."{ "
          for w=1, #cmd[i][1] do
            cmds = cmds..cmd[i][1][w].." "
          end
          cmds = cmds.."}|"
        else
          cmds = cmds..cmd[i][1].."|"
        end
        if i%5 == 0 then
          cmds = cmds.."\n"
        end
      end
      love.window.showMessageBox("yata: help", cmds, "info", false)
      return
    end
    
    local command = c[2]
    for cm=1, #cmd do
      if type(cmd[cm][1]) == "table" then
        for w=1, #cmd[cm][1] do
          if cmd[cm][1][w] == command then _g_input = cmd[cm][3] end
        end
      else
        if cmd[cm][1] == command then _g_input = cmd[cm][3] end
      end
    end
  end,
  "> help -> (display commands list)"
)
  
  -- #ADD
cmd:add("add",
  function(c)
    if #_todo_table >= 90 or c[2] == nil then
      _g_input = "undefined input"
      return
    end
    local str = _u_input:gsub(c[1].." ", "")
    mem()
    cmd:todo_add(str)
  end,
  "> rm 'index' -> (remove entry)"
)
  
  -- #RM
cmd:add({"rm", "remove"},
  function(c)
    if tonumber(c[2]) == nil or _todo_table[tonumber(c[2])] == nil then
      _u_input = ""
      _g_input = "undefined index"
      return
    end
    local num_index = tonumber(c[2])
    mem()
    table.remove(_todo_table, num_index)
    _g_input = "index "..num_index.." removed"
  end,
  "> rm/remove 'index' -> (remove entry)"
)
  -- #INSERT
cmd:add({"ins", "insert"},
  function(c)
    if #_todo_table >= 90 then _u_input = "" return end
    if tonumber(c[2]) == nil or _todo_table[tonumber(c[2])] == nil or #_todo_table >= 18 then
      _u_input = ""
      _g_input = "undefined index"
      return
    end
    local num_index = tonumber(c[2])
    if c[3] == nil then c[3] = "" end
    local str = _u_input:gsub(c[1].." "..c[2].." ", "")
    mem()
    cmd:todo_add(str, 0, num_index)
    _g_input = "entry inserted to index "..num_index
  end,
  "> ins/insert 'index' -> (insert entry to index)"
)
  
  -- #EDIT
cmd:add({"edi", "edit"},
  function(c)
    if tonumber(c[2]) == nil or _todo_table[tonumber(c[2])] == nil then
      _u_input = ""
      _g_input = "undefined index"
      return
    end
    if c[3] == nil then
      _u_input = ""
      _g_input = "undefined new entry"
      return
    end
    local num_index = tonumber(c[2])
    local str = _u_input:gsub(c[1].." "..num_index.." ", "")
    mem()
    _todo_table[num_index][1] = str
    _g_input = "index "..num_index.." edited"
  end,
  "> edi/edit 'index' 'new' -> (edit entry)"
)
  
  -- #REP
cmd:add({"rep", "replace"},
  function(c)
    if tonumber(c[2]) == nil or _todo_table[tonumber(c[2])] == nil then
      _u_input = ""
      _g_input = "undefined index"
      return
    end
    if c[3] == nil then
      _u_input = ""
      _g_input = "undefined word to replace"
      return
    end
    if c[4] == nil then
      _u_input = ""
      _g_input = "undefined new word"
      return
    end
    local num_index = tonumber(c[2])
    local old = c[3]
    local str = _u_input:gsub(c[1].." "..num_index.." "..old.." ", "")
    local str_entry = _todo_table[num_index][1]
    print(str_entry)
    str_entry = str_entry:gsub(old, str)
    print(str_entry)
    mem()
    _todo_table[num_index][1] = str_entry
    _g_input = "word from index "..num_index.." replaced"
  end,
  "> rep/replace 'index' 'old' 'new' -> (edit word)"
)
  
  -- #SEP
 cmd:add("sep",
  function(c)
    if #_todo_table >= 90 then _u_input = "" return end
    mem()
    cmd:todo_add("------------------------------------------------")
    _g_input = "separator inserted"
  end,
  "> sep -> (insert separator)"
)

  -- #STATE
 cmd:add({"st", "status"},
  function(c)
    if tonumber(c[2]) == nil or _todo_table[tonumber(c[2])] == nil then
      _u_input = ""
      _g_input = "undefined index"
      return
    end
    if tonumber(c[3]) < 0 or tonumber(c[3]) > #_app.theme - 4 then
      _u_input = ""
      _g_input = "undefined state"
      return
    end
    mem()
    _todo_table[tonumber(c[2])][2] = tonumber(c[3])
    _g_input = "state of index "..c[2].." changed"
  end,
  "> st/status 'number 0-3' -> (change entry state/color)"
)
  
  -- #EXPORT
cmd:add("export",
  function(c)
    if c[2] == nil then
      _u_input = ""
      _g_input = "no export type"
      return
    end
      
    -- ----------IMAGE----------
    if c[2] == "image" then
      if c[3] == nil then
        _u_input = ""
        love.graphics.captureScreenshot("image.png")
        _g_input = "image saved"
        _g_input = "list saved as 'image.png'"
        return
      end
      _u_input = ""
      love.graphics.captureScreenshot(c[3]..".png")
      _g_input = "list saved as '"..c[3]..".png'"
  
    -- ----------TEXT----------
    elseif c[2] == "text" then
      local text = ""
  
      for i = 1, #_todo_table do
        text = text.._todo_table[i][1].."\n"
      end
      if c[3] == nil then
        _u_input = ""
        love.filesystem.write("text.txt", text)
        _g_input = "list saved as 'text.txt'"
        return
      end
      _u_input = ""
      love.filesystem.write(c[3]..".txt", text)
      _g_input = "list saved as '"..c[3]..".txt'"
    else
      _u_input = ""
      _g_input = "export type not found"
    end
  end,
  "> export 'image/text' 'name' -> (export list)"
)
  
  -- #SAVE
cmd:add("save",
  function(c)
    if c[2] == nil then
      _u_input = ""
      _g_input = "save file name was not given"
      return
    end
    sd.save(_todo_table, c[2]..".yasf")
    _g_input = "file saved"
  end,
  "> save 'name' -> (save current list)"
)
  
  -- #LOAD
cmd:add("load",
  function(c)
    if c[2] == nil then _u_input = "" _g_input = "file not found" return end
    if love.filesystem.getInfo(c[2]..".yasf", "file") == nil then
      _u_input = ""
      _g_input = "file not found"
      return
    end
    mem()
    _todo_table = sd.load(c[2]..".yasf")
    _g_input = "file loaded"
  end,
  "> load 'name' -> (load list)"
)
  
  -- #COPY
cmd:add({"cp", "copy"},
  function(c)
    if c[2] == nil then
      _u_input = ""
      _g_input = "no number given"
      return
    end
    if tonumber(c[2]) > #_todo_table then
      _u_input = ""
      _g_input = "index not found"
      return
    end
    love.system.setClipboardText(_todo_table[tonumber(c[2])][1])
    _g_input = "entry copied to copyboard"
  end,
  "> copy 'index' -> (copy entry to copyboard)"
)
  
  -- #UNDO
cmd:add({"back", "undo"},
  function(c)
    if #_mem == 0 then
      _u_input = ""
      _g_input = ""
      return
    end
    _todo_table = _mem[#_mem]
    table.remove(_mem, #_mem)
    _g_input = "last action undone"
  end,
  "> back/undo -> (undo last action)"
)
  
  -- #THEME
cmd:add("theme",
  function(c)
    if c[2] == nil then _u_input = "" _g_input = "themes: eclipse, snow, nord, custom" return end
    if c[2] == "custom" then 
      if c[3] == nil then
        _g_input = "invalid name"
        return
      end
      theme_save(c[3])
    elseif c[2] == "eclipse" then _app.theme = theme_eclipse()
    elseif c[2] == "snow" then _app.theme = theme_snow()
    elseif c[2] == "nord" then _app.theme = theme_nord()
    else
      local theme = theme_load(c[2])
      if theme == nil then return end
      _app.theme = theme
    end
  end,
  "> theme 'name' -> (change app theme)"
)

  -- #DIR
cmd:add({"dir", "folder"},
  function(c)
    love.system.openURL("file://".._app.dir)
    _g_input = "save directory opened"
  end,
  "> dir/folder -> (open save directory)"
)

  -- #QUIT
cmd:add({"quit", "exit"},
  function(c)
    love.event.quit()    
  end,
  "> quit/exit -> (quit from app)"
)

  -- #INDEX
cmd:add("index",
  function(c)
    _app.index = not _app.index
    _g_input = "index "..tostring(_app.index)
  end,
  "> index -> (display index number)"
)

  -- #PAGE
cmd:add({"p", "page"},
  function(c)
    local page = tonumber(c[2])
    if page == nil or page < 1 or page > #_app.pages[1] then
      _g_input = "invalid page"
      return
    end
    _app.page_sel = page
    _g_input = "page changed"
  end,
  "> p/page 'number 1-5' -> (change page)"
)

  -- #FULLSCREEN
cmd:add("fullscreen",
  function(c)
    local fscr = love.window.getFullscreen()
    love.window.setFullscreen(not fscr)
  end,
  "> fullscreen -> (toggle fullscreen)"
)

  -- #CLS
cmd:add({"cls", "clear"},
  function(c)
    mem()
    _todo_table = {}
    _g_input = "list cleared"
  end,
  "> cls/clear -> (clear list)"
)
