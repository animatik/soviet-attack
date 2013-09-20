function newWindow(title_of_window,width_of_window,height_of_window,x_of_window,y_of_window)
   window = {
      title = title_of_window
      width = width_of_window
      height = height_of_window
      x = x_of_window
      y = y_of_window
      border_color = {0,0,0,255}
      border_color = {12,12,12,255}
      rows = {}
      draging = {
         active = false,
         diffx = 0,
         diffy = 0
      }
   }
end

function addRow(win,name_of_row)
   table.insert(win.rows,{name,element})
end