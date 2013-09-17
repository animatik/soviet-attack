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

--require "lib/animation.lua" -- loading library for working with animation

--Load media
function love.load()
   menu_sound = love.audio.newSource('snd/mus/main_theme.mp3','stream')
   love.audio.play(menu_sound)
end

--Update
function love.update()
   if menu_sound:isStopped()then
      love.audio.play(menu_sound)
   end
end

--Draw result
function love.draw()
--some code.
end
