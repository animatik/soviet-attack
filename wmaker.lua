function newWindow(title_of_window,width_of_window,height_of_window,x_of_window,y_of_window,bc,wc,tc,sb,sf,fnt)
   window = {
      title = title_of_window,
      width = width_of_window,
      height = height_of_window,
      x = x_of_window,
      y = y_of_window,
      border_color = bc,
      window_color = wc,
      title_color = tc,
      border_size = sb,
      font_size = sf,
      font = love.graphics.newFont(fnt,sf),
      rows = {},
      draging = {
         active = false,
         diffx = 0,
         diffy = 0
      }
   }
   return window
end

function addRow(win,name_of_row)
   table.insert(win.rows,{name,elements})
   win.rows[#win.rows].name = name_of_row
   win.rows[#win.rows].elements = {}
end

function addText(win,name_of_row,name_of_element,text_of_text,sz,fnt)
end

function drawWindow(win)
   local lastx
   lastx = win.x
   love.graphics.setColor(win.border_color[1],win.border_color[2],win.border_color[3],win.border_color[4])
   love.graphics.rectangle('fill',win.x-win.border_size,win.y-win.border_size,win.width+win.border_size*2,win.height+win.border_size*2)
   love.graphics.setColor(win.window_color[1],win.window_color[2],win.window_color[3],win.window_color[4])
   love.graphics.rectangle('fill',win.x,win.y,win.width,win.height)
   love.graphics.setColor(win.border_color[1],win.border_color[2],win.border_color[3],win.border_color[4])
   love.graphics.setLine(win.border_size)
   love.graphics.line(win.x,win.y+win.font_size,win.x+win.width,win.y+win.font_size)
   love.graphics.line(win.x+win.font_size,win.y,win.x+win.font_size,win.y+win.font_size)
   love.graphics.setLine(win.border_size/2)
   love.graphics.line(win.x+win.font_size/5,win.y+win.font_size/5,win.x+win.font_size-win.font_size/5,win.y+win.font_size-win.font_size/5)
   love.graphics.line(win.x+win.font_size-win.font_size/5,win.y+win.font_size/5,win.x+win.font_size/5,win.y+win.font_size-win.font_size/5)
   love.graphics.setFont(win.font)
   love.graphics.setColor(win.title_color[1],win.title_color[2],win.title_color[3],win.title_color[4])
   love.graphics.print(win.title,win.x+win.font_size,win.y)
end