function window_close()
   win.show = false
   win.drag.active = false
end

function new_window(t,w,h,s,a)
   window = {
      title = t,
      width =  w,
      height = h,
      show = s,
      drag = {
         active = a
      }
   }
   return window
end