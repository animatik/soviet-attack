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
bombs = {}
function make_particles(tb,count)
   for i = 1,count do
      table.insert(tb,{x,y,status})
      tb[i].x = math.random(-300,450)
      if tb[i].x < 0 then
         tb[i].y = math.random(200)
      else
         tb[i].y = math.random(200)*-1
      end
      tb[i].status = -1
      tb[i].maxy = math.random(360,500)
   end
end

function change_particles(tb,speed,shift,delta)
   for i = 1,#tb do
      if tb[i].y > tb[i].maxy then
         if tb[i].status > 0 then
            tb[i].status = tb[i].status - 1
         elseif tb[i].status == 0 then
            tb[i].status = -1
            tb[i].x = math.random(-300,450)
            if tb[i].x < 0 then
               tb[i].y = math.random(200)
            else
               tb[i].y = math.random(200)*-1
            end
            tb[i].maxy = math.random(360,500)
         else
            tb[i].status = 5
         end
      else
         tb[i].y = tb[i].y + (speed*delta)
         tb[i].x = tb[i].x + (shift*delta)
      end         
   end
end
function  draw_particles(tb,img,img2)
   for i = 1,#tb do
      if tb[i].status > -1 then
         love.graphics.draw(img2,tb[i].x,tb[i].y)
      else
         love.graphics.draw(img,tb[i].x,tb[i].y)
      end
   end
end
function love.load()
   play_address = soundtrecks[math.random(3)]
   playing = love.audio.newSource("snd/mus/"..soundtrecks[math.random(#soundtrecks)])
   love.audio.play(playing)
   world = love.physics.newWorld(0,0)
   background = love.graphics.newImage("img/bkg/sky.png")
   city = love.graphics.newImage("img/bkg/city.png")
   title = love.graphics.newImage("img/bkg/title.png")
   foot = love.graphics.newImage("img/bkg/foot.png")
   rocket = love.graphics.newImage("img/bkg/rocket.png")
   explosion = love.graphics.newImage("img/bkg/explosion.png")
   bomb = love.graphics.newImage("img/bkg/bomb.png")
   far_bomb = love.graphics.newImage("img/bkg/far_bomb.png")
   furthest_bomb = love.graphics.newImage("img/bkg/furthest_bomb.png")
   make_particles(far_bombs,10)
   make_particles(furthest_bombs,20)
   make_particles(bombs,5)
end

--function for updating
function love.update(dt)
   if playing:isStopped()then
      playing = love.audio.newSource("snd/mus/"..soundtrecks[math.random(#soundtrecks)])
      love.audio.play(playing)
   end
   change_particles(far_bombs,50,70,dt)
   change_particles(furthest_bombs,30,70,dt)
   change_particles(bombs,60,70,dt)
end

--Draw result
function love.draw()
   love.graphics.draw(background,0,0)
   draw_particles(furthest_bombs,furthest_bomb,furthest_bomb)
   draw_particles(far_bombs,far_bomb,far_bomb)
   love.graphics.draw(city,0,260)
   draw_particles(bombs,bomb,explosion)
   love.graphics.draw(title,15,14)
   love.graphics.draw(foot,-8,490)
   love.graphics.draw(rocket,500,50)
end