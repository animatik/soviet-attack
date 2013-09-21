--This is just a test file.
require "wmaker"

function love.load()
   window = newWindow('   hello world!',300,400,100,100,{128,50,50,255},{235,0,0,255},{255,230,0,255},2,12,'furore.otf')
end

function love.update(dt)

end

function love.draw()
   drawWindow(window)
end