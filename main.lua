--This file is part of soviet-attack.

--Soviet-attack is free software: you can redistribute it and/or modify
--it under the terms of the GNU General Public License as published by
--the Free Software Foundation, either version 3 of the License, or
--(at your option) any later version.

--Soviet-attack is distributed in the hope that it will be useful,
--but WITHOUT ANY WARRANTY; without even the implied warranty of
--MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--GNU General Public License for more details.

--You should have received a copy of the GNU General Public License
--along with soviet-attack.  If not, see <http://www.gnu.org/licenses/>.

--Loading media for main menu
soundtrecks = love.filesystem.enumerate("snd/mus")
far_bombs = {}
furthest_bombs = {}
function make_particles(tb,count)
   for i = 1,count do
      table.insert(tb,{x,y})
      tb[i].x = math.random(-300,450)
      if tb[i].x < 0 then
         tb[i].y = math.random(200)
      else
         tb[i].y = math.random(200)*-1
      end
   end
end

function change_particles(tb,speed,shift,delta)
   for i = 1,#tb do
      if tb[i].y > 360 then
         tb[i].x = math.random(-300,450)
	 if tb[i].x < 0 then
	    tb[i].y = math.random(200)
	 else
            tb[i].y = math.random(200)*-1
	 end
      end
      tb[i].y = tb[i].y + (speed*delta)
      tb[i].x = tb[i].x + (shift*delta)
   end
end

function  draw_particles(tb,img)
   for i = 1,#tb do
      love.graphics.draw(img,tb[i].x,tb[i].y)
   end
end
function love.load()
   play_address = soundtrecks[math.random(3)]
   playing = love.audio.newSource("snd/mus/"..soundtrecks[math.random(#soundtrecks)])
   love.audio.play(playing)
   background = love.graphics.newImage("img/bkg/sky.png")
   city = love.graphics.newImage("img/bkg/city.png")
   title = love.graphics.newImage("img/bkg/title.png")
   foot = love.graphics.newImage("img/bkg/foot.png")
   rocket = love.graphics.newImage("img/bkg/rocket.png")
   far_bomb = love.graphics.newImage("img/bkg/far_bomb.png")
   furthest_bomb = love.graphics.newImage("img/bkg/furthest_bomb.png")
   make_particles(far_bombs,10)
   make_particles(furthest_bombs,10)
   print(furthest_bombs[1].x)
end

--function for updating
function love.update(dt)
   if playing:isStopped()then
      playing = love.audio.newSource("snd/mus/"..soundtrecks[math.random(#soundtrecks)])
      love.audio.play(playing)
   end
   change_particles(far_bombs,50,70,dt)
   change_particles(furthest_bombs,40,60,dt)
end

--Draw result
function love.draw()
   love.graphics.draw(background,0,0)
   draw_particles(furthest_bombs,furthest_bomb)
   draw_particles(far_bombs,far_bomb)
   love.graphics.draw(city,0,260)
   love.graphics.draw(title,15,14)
   love.graphics.draw(foot,-8,490)
   love.graphics.draw(rocket,500,50)
end
