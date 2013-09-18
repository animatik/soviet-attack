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
projector1 = {}
table.insert(projector1,{x,y,r,v})
projector1.x = 550
projector1.y = 550
projector1.r = 0
projector1.v = true
projector2 = {}
table.insert(projector2,{x,y,r,v})
projector2.x = 300
projector2.y = 570
projector2.r = 0
projector2.v = false
projector3 = {}
table.insert(projector3,{x,y,r,v})
projector3.x = 150
projector3.y = 600
projector3.r = 0.5
projector3.v = true
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

function projector_move(lamp,minr,maxr,speed,delta)
   if lamp.r > maxr then
      lamp.v = false
   elseif lamp.r < minr then
      lamp.v = true
   end
   if lamp.v == true then
      lamp.r = lamp.r + speed*delta
   elseif lamp.v == false then
      lamp.r = lamp.r - speed*delta
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
   background = love.graphics.newImage("img/bkg/sky.png")
   city = love.graphics.newImage("img/bkg/city.png")
   title = love.graphics.newImage("img/bkg/title.png")
   foot = love.graphics.newImage("img/bkg/foot.png")
   rocket = love.graphics.newImage("img/bkg/rocket.png")
   explosion = love.graphics.newImage("img/bkg/explosion.png")
   far_explosion = love.graphics.newImage("img/bkg/far_explosion.png")
   furthest_explosion = love.graphics.newImage("img/bkg/furthest_explosion.png")
   bomb = love.graphics.newImage("img/bkg/bomb.png")
   far_bomb = love.graphics.newImage("img/bkg/far_bomb.png")
   furthest_bomb = love.graphics.newImage("img/bkg/furthest_bomb.png")
   lamp = love.graphics.newImage("img/bkg/lamp.png")
   make_particles(far_bombs,3)
   make_particles(furthest_bombs,3)
   make_particles(bombs,3)
end

--function for updating
function love.update(dt)
   if playing:isStopped()then
      playing = love.audio.newSource("snd/mus/"..soundtrecks[math.random(#soundtrecks)])
      love.audio.play(playing)
   end
   change_particles(far_bombs,90,120,dt)
   change_particles(furthest_bombs,70,120,dt)
   change_particles(bombs,100,120,dt)
   projector_move(projector1,-0.3,0.3,0.1,dt)
   projector_move(projector2,-0.4,0.1,0.1,dt)
   projector_move(projector3,-0.6,0.6,0.2,dt)
end

--Draw result
function love.draw()
   love.graphics.draw(background,0,0)
   draw_particles(furthest_bombs,furthest_bomb,furthest_explosion)
   draw_particles(far_bombs,far_bomb,far_explosion)
   love.graphics.draw(lamp,projector2.x,projector2.y,projector2.r,1,1,75,586)
   love.graphics.draw(city,0,260)
   draw_particles(bombs,bomb,explosion)
   love.graphics.draw(lamp,projector1.x,projector1.y,projector1.r,1,1,75,586)
   love.graphics.draw(lamp,projector3.x,projector3.y,projector3.r,1,1,75,586)
   love.graphics.draw(title,15,14)
   love.graphics.draw(foot,-8,490)
   love.graphics.draw(rocket,500,50)
end