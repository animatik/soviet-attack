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
soundwar = love.filesystem.enumerate("snd/war")
soundexplosions = love.filesystem.enumerate("snd/exp")
far_bombs = {}
furthest_bombs = {}
bombs = {}
projector1 = {}
window_opened = false
drag_now = ''
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
            playing_explosion = love.audio.newSource("snd/exp/"..soundexplosions[math.random(#soundexplosions)])
            love.audio.play(playing_explosion)
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
         love.graphics.draw(img2.i,tb[i].x,tb[i].y,math.random(-1.0,1.0),1,1,img2.w/2,img2.h/2)
      else
         love.graphics.draw(img,tb[i].x,tb[i].y)
      end
   end
end

function button_over(bx,by,bw,bh)
   if window_opened == false then
      mx,my = love.mouse.getPosition()
      local over
      if mx<(bx+bw) and mx>bx and my<(by+bh) and my>by then
         over = true
      else
         over = false
      end
   return over
   end
end

function button_pressed(bx,by,bw,bh)
   if window_opened == false then
      mx,my = love.mouse.getPosition()
      md = love.mouse.isDown('l')
      local over
      if mx<(bx+bw) and mx>bx and my<(by+bh) and my>by then
         over = true
      else
         over = false
      end
      return md and over
   end
end

function pressed(bx,by,bw,bh)
   mx,my = love.mouse.getPosition()
   md = love.mouse.isDown('l')
   local over
    if mx<(bx+bw) and mx>bx and my<(by+bh) and my>by then
      over = true
   else
      over = false
   end
   return md and over
end

function love.mousepressed(x,y,button)
   if not (drag_now == '') then
      if button == "l"    
      and x > drag_now.x and x < drag_now.x + drag_now.width
      and y > drag_now.y and y < drag_now.y + (drag_now.height - 490)
      then
         drag_now.active = true
         drag_now.diffx = x - drag_now.x
         drag_now.diffy = y - drag_now.y
      end
   end
end

function love.mousereleased(x,y,button)
if not (drag_now == '') then
   if button == "l" then drag_now.active = false end
end
end

function love.load()
   love.mouse.setVisible(false)
   play_address = soundtrecks[math.random(3)]
   playing = love.audio.newSource("snd/mus/"..soundtrecks[math.random(#soundtrecks)])
   playing_war = love.audio.newSource("snd/war/"..soundwar[math.random(#soundwar)])
   love.audio.play(playing)
   love.audio.play(playing_war)
   background = love.graphics.newImage("img/bkg/sky.png")
   city = love.graphics.newImage("img/bkg/city.png")
   title = love.graphics.newImage("img/bkg/title.png")
   foot = love.graphics.newImage("img/bkg/foot.png")
   rocket = love.graphics.newImage("img/bkg/rocket.png")
   img_explosion = love.graphics.newImage("img/bkg/explosion.png")
   explosion = {}
   table.insert(explosion,{i,w,h})
   explosion.i = img_explosion
   explosion.w = 108
   explosion.h = 108
   img_far_explosion = love.graphics.newImage("img/bkg/far_explosion.png")
   far_explosion = {}
   table.insert(explosion,{i,w,h})
   far_explosion.i = img_far_explosion
   far_explosion.w = 58
   far_explosion.h = 58
   img_furthest_explosion = love.graphics.newImage("img/bkg/furthest_explosion.png")
   furthest_explosion = {}
   table.insert(explosion,{i,w,h})
   furthest_explosion.i = img_furthest_explosion
   furthest_explosion.w = 23
   furthest_explosion.h = 23
   bomb = love.graphics.newImage("img/bkg/bomb.png")
   far_bomb = love.graphics.newImage("img/bkg/far_bomb.png")
   furthest_bomb = love.graphics.newImage("img/bkg/furthest_bomb.png")
   lamp = love.graphics.newImage("img/bkg/lamp.png")
   button_tut = {}
   table.insert(button_tut,{normal,over,pressed})
   button_tut.normal = love.graphics.newImage("img/bkg/button_tut_normal.png")
   button_tut.over = love.graphics.newImage("img/bkg/button_tut_over.png")
   button_tut.pressed = love.graphics.newImage("img/bkg/button_tut_pressed.png")
   cursor = love.graphics.newImage("img/bkg/cursor.png")
   button_versus = {}
   table.insert(button_versus,{normal,over,pressed})
   button_versus.normal = love.graphics.newImage("img/bkg/button_versus_normal.png")
   button_versus.over = love.graphics.newImage("img/bkg/button_versus_over.png")
   button_versus.pressed = love.graphics.newImage("img/bkg/button_versus_pressed.png")
   cursor = love.graphics.newImage("img/bkg/cursor.png")
   button_campaign = {}
   table.insert(button_campaign,{normal,over,pressed})
   button_campaign.normal = love.graphics.newImage("img/bkg/button_campaign_normal.png")
   button_campaign.over = love.graphics.newImage("img/bkg/button_campaign_over.png")
   button_campaign.pressed = love.graphics.newImage("img/bkg/button_campaign_pressed.png")
   cursor = love.graphics.newImage("img/bkg/cursor.png")
   button_options = {}
   table.insert(button_options,{normal,over,pressed})
   button_options.normal = love.graphics.newImage("img/bkg/button_options_normal.png")
   button_options.over = love.graphics.newImage("img/bkg/button_options_over.png")
   button_options.pressed = love.graphics.newImage("img/bkg/button_options_pressed.png")
   cursor = love.graphics.newImage("img/bkg/cursor.png")
   button_exit = {}
   table.insert(button_exit,{normal,over,pressed})
   button_exit.normal = love.graphics.newImage("img/bkg/button_exit_normal.png")
   button_exit.over = love.graphics.newImage("img/bkg/button_exit_over.png")
   button_exit.pressed = love.graphics.newImage("img/bkg/button_exit_pressed.png")
   button_about = {}
   table.insert(button_about,{normal,over,pressed})
   button_about.normal = love.graphics.newImage("img/bkg/button_about_normal.png")
   button_about.over = love.graphics.newImage("img/bkg/button_about_over.png")
   button_about.pressed = love.graphics.newImage("img/bkg/button_about_pressed.png")
   cursor = love.graphics.newImage("img/bkg/cursor.png")
   window_about = {
   normal = love.graphics.newImage("img/bkg/window_about/window_normal.png"),
   x = 50,
   y = 110,
   width = 508,
   height = 508,
   diffx = 0,
   diffy = 0,
   active = false,
   show = false
   }
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
   if playing_war:isStopped()then
      playing_war = love.audio.newSource("snd/war/"..soundwar[math.random(#soundwar)])
      love.audio.play(playing_war)
   end
   change_particles(far_bombs,90,120,dt)
   change_particles(furthest_bombs,70,120,dt)
   change_particles(bombs,100,120,dt)
   projector_move(projector1,-0.3,0.3,0.1,dt)
   projector_move(projector2,-0.4,0.1,0.1,dt)
   projector_move(projector3,-0.6,0.6,0.2,dt)
   if window_about.active then
      window_about.x = love.mouse.getX() - window_about.diffx
      window_about.y = love.mouse.getY() - window_about.diffy
   end
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
   if button_over(20,60,288,70) then
      love.graphics.draw(button_tut.over,20,60)
      if button_pressed(20,60,288,70) then
         love.graphics.draw(button_tut.pressed,20,60)
      end
   else
      love.graphics.draw(button_tut.normal,20,60)
   end

   if button_over(20,130,288,70) then
      love.graphics.draw(button_versus.over,20,130)
      if button_pressed(20,130,288,70) then
         love.graphics.draw(button_versus.pressed,20,130)
      end
   else
      love.graphics.draw(button_versus.normal,20,130)
   end

   if button_over(20,200,288,70) then
      love.graphics.draw(button_campaign.over,20,200)
      if button_pressed(20,200,288,70) then
         love.graphics.draw(button_campaign.pressed,20,200)
      end
   else
      love.graphics.draw(button_campaign.normal,20,200)
   end

   if button_over(20,270,288,70) then
      love.graphics.draw(button_options.over,20,270)
      if button_pressed(20,270,288,70) then
         love.graphics.draw(button_options.pressed,20,270)
      end
   else
      love.graphics.draw(button_options.normal,20,270)
   end

   if button_over(20,340,288,70) then
      love.graphics.draw(button_about.over,20,340)
      if button_pressed(20,340,288,70) then
         love.graphics.draw(button_about.pressed,20,340)
         drag_now = window_about
         window_about.show = true
         window_opened = true
      end
   else
      love.graphics.draw(button_about.normal,20,340)
   end

   if button_over(20,410,288,70) then
      love.graphics.draw(button_exit.over,20,410)
      if button_pressed(20,410,288,70) then
         love.graphics.draw(button_exit.pressed,20,410)
         love.event.quit()
      end
   else
      love.graphics.draw(button_exit.normal,20,410)
   end
   if pressed(window_about.x,window_about.y,30,30) then
      window_about.show = false
      window_opened = false
   end
   
   if window_about.show then
      love.graphics.draw(window_about.normal,window_about.x,window_about.y)
   end
   love.graphics.draw(cursor,love.mouse.getX(),love.mouse.getY())
end