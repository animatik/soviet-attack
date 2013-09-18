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
for i = 1,50 do
   table.insert(far_bombs,{x,y})
   far_bombs[i].x = math.random(-300,450)
   if far_bombs[i].x < 0 then
      far_bombs[i].y = math.random(200)
   else
      far_bombs[i].y = math.random(200)*-1
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
   far_bomb_speed = 50
end

--function for updating
function love.update(dt)
   if playing:isStopped()then
      playing = love.audio.newSource("snd/mus/"..soundtrecks[math.random(#soundtrecks)])
      love.audio.play(playing)
   end
   for i = 1,#far_bombs do
      if far_bombs[i].y > 360 then
         far_bombs[i].x = math.random(-300,450)
	 if far_bombs[i].x < 0 then
	    far_bombs[i].y = math.random(200)
	 else
            far_bombs[i].y = math.random(200)*-1
	 end
      end
      far_bombs[i].y = far_bombs[i].y + (far_bomb_speed*dt)
      far_bombs[i].x = far_bombs[i].x + (70*dt)
   end
end

--Draw result
function love.draw()
   love.graphics.draw(background,0,0)
   for i = 1,#far_bombs do
      print(far_bombs[i].y)
      love.graphics.draw(far_bomb,far_bombs[i].x,far_bombs[i].y)
   end
   love.graphics.draw(city,0,260)
   love.graphics.draw(title,15,14)
   love.graphics.draw(foot,-8,490)
   love.graphics.draw(rocket,500,50)
end
