--This is just a test file.

wmaker = require "wmaker"

function love.load()
   win1 = wmaker.window('hello world',200,300,50,50)
   win1.border_color = {255,0,0,255}
   win1.window_color = {255,112,10,245}
   wmaker.addRow(win1,'image')
   wmaker.addRow(win1,'text')
   wmaker.addImage(win1,'image','img.png')
   wmaker.addText(win1,'text','hello world!',36,'furore.otf','center')
end

function love.update(dt)

end

function love.draw()
   wmaker.drawWindow(win1)
end