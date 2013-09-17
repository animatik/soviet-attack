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
function love.load()
   play_address = soundtrecks[math.random(3)]
   playing = love.audio.newSource("snd/mus/"..soundtrecks[math.random(#soundtrecks)])
   love.audio.play(playing)
   background = love.graphics.newImage("img/bkg/background_menu.jpg")
end

--function for updating
function love.update()
   if playing:isStopped()then
      playing = love.audio.newSource("snd/mus/"..soundtrecks[math.random(#soundtrecks)])
      love.audio.play(playing)
   end
end

--Draw result
function love.draw()
   love.graphics.draw(background,0,0)
end
