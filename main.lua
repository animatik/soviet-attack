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

--Функция для создание летящих бомб tb - таблица куда их записывают, count - их количество.
function make_particles(tb,count)
   for i = 1,count do
      --x,y - позиция бомб, status - если больше -1, то бомба взрывается.
      table.insert(tb,{x,y,status,maxy})
      --задаём случайный x
      tb[i].x = math.random(-300,450)
      --если x отрицательный, то  задаём
      --случайный положительный y.
      --если x положительный, то задаём
      --случайный отрицательный y.
      --этот код обеспечивает равномерное
      --распределение бомб по экрану
      if tb[i].x < 0 then
         tb[i].y = math.random(200)
      else
         tb[i].y = math.random(200)*-1
      end
      --определяем что бомба не взрывается.
      tb[i].status = -1
      --задаём случайную высоту взрыва.
      --таким образом бомбы будут взрываться
      --на разной высоте.
      tb[i].maxy = math.random(360,500)
   end
end

--Функция для перемещения бомб по экрану.
--tb - таблица с параметрами бомб.
--speed - скорость падения бомб.
--shift - скорость смещения бомб вбок.
--delta - дельта времени.
function change_particles(tb,speed,shift,delta)
   -- проверяем каждый элемент таблицы
   for i = 1,#tb do
      --если бомба привысила высоту своего взрыва 
      if tb[i].y > tb[i].maxy then
         --если бомба взрывается, то  отнимаем от status - 1
         if tb[i].status > 0 then
            tb[i].status = tb[i].status - 1
         --если status равен 0 значит бомба перестала взрываться.
         --и ей нужно сгенерировать новое случайное положение.
         --положение генерировается также как в функции
         --make_particles
         elseif tb[i].status == 0 then
            tb[i].status = -1
            tb[i].x = math.random(-300,450)
            if tb[i].x < 0 then
               tb[i].y = math.random(200)
            else
               tb[i].y = math.random(200)*-1
            end
            tb[i].maxy = math.random(360,500)
         --а если бомба не по status не взрывается то
         --заставляем её взрываться.
         else
            tb[i].status = 5 --статус также означает как долго бомба будет взрываться
            --загружаем слуайный звук взрыва из таблицы soundexplosions.
            playing_explosion = love.audio.newSource("snd/exp/"..soundexplosions[math.random(#soundexplosions)])
            --играем случайно выбранный звук взрыва.
            love.audio.play(playing_explosion)
         end
      else
         --а если бомба не взрывается и не должна взрываться,
         --то просто перемещяем её.
         tb[i].y = tb[i].y + (speed*delta) --опускаем вниз.
         tb[i].x = tb[i].x + (shift*delta) --смещаем вбок.
      end         
   end
end

--Функция для отрисовки бомб.
--tb - таблица с бомбаи и их параметрами.
--img - нормальный вид бомбы.
--img2 - бомба взрывается.
function  draw_particles(tb,img,img2)
   --обходим каждый элемент
   for i = 1,#tb do
      --если бомба взрывается, то рисуем img2
      if tb[i].status > -1 then
         --рисуем взрыв случайным образом поворачивая его вокруг себя.
         love.graphics.draw(img2.i,tb[i].x,tb[i].y,math.random(-1.0,1.0),1,1,img2.w/2,img2.h/2)
      else
         --рисуем нормальный вид бомбы.
         love.graphics.draw(img,tb[i].x,tb[i].y)
      end
   end
end

--Функция для перемещения прожекторов.
--lamp - таблица с параметрами лампы
--minr - минимальный поворот
--maxr - максимальный поворот
--speed - скорость поворота
--delta - дельта времени
function projector_move(lamp,minr,maxr,speed,delta)
   --если поворот больше maxr или меньше minr, то v - направление
   --поворота меняем на обратное
   if lamp.r > maxr then
      lamp.v = false
   elseif lamp.r < minr then
      lamp.v = true
   end
   --если v = false, то отнимаем радианы
   --если v = true, то прибавляем радианы
   if lamp.v == true then
      lamp.r = lamp.r + speed*delta
   elseif lamp.v == false then
      lamp.r = lamp.r - speed*delta
   end
end

--Функция для проверки нахождения мыши над кнопкой
--bx - положение кнопки по x
--bx - положение кнопки по y
--bw - ширина кнопки
--bh - высота кнопки
function button_over(bx,by,bw,bh)
   --если нет открытых окон, то начинаем проверку
   if window_opened == false then
      --получаем позицию мыши
      mx,my = love.mouse.getPosition()
      local over
      --если мышь находится в области размещения кнопки, то мышь
      --находится над кнопкой.
      if mx<(bx+bw) and mx>bx and my<(by+bh) and my>by then
         over = true
      else
         over = false
      end
   return over
   end
end

--Функция для проверки нажатия кнопки
--bx - положение кнопки по x
--bx - положение кнопки по y
--bw - ширина кнопки
--bh - высота кнопки
function button_pressed(bx,by,bw,bh)
   --если нет открытых окон, то начинаем проверку
   if window_opened == false then
      --проверяем нахождение мыши над кнопкой
      mx,my = love.mouse.getPosition()
      md = love.mouse.isDown('l') --нажата ли левая кнопка мыши
      local over
      if mx<(bx+bw) and mx>bx and my<(by+bh) and my>by then
         over = true
      else
         over = false
      end
      return md and over --если md и over = true, то возращает true
   end
end

--Таже функция button_pressed, только без проверки открытия окон.
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

--функции для перетаскивания окон. Работают с открытым на данный момент окном.
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
   window_opened = false --нету открытых окон
   drag_now = '' --никакие окна не перетаскиваются
   --загружаем список файлов в папке snd/mus для музыки в меню
   soundtrecks = love.filesystem.enumerate("snd/mus")
   --загружаем список файлов в папке snd/war для звуков войны
   soundwar = love.filesystem.enumerate("snd/war")
   --загружаем список файлов в папке snd/exp для звуков взрывов бомб
   soundexplosions = love.filesystem.enumerate("snd/exp")
   --выбираем случайную музыку для меню
   playing = love.audio.newSource("snd/mus/"..soundtrecks[math.random(#soundtrecks)])
   --выбираем случайные звуки войны
   playing_war = love.audio.newSource("snd/war/"..soundwar[math.random(#soundwar)])
   --запускаем случайно выбранную музыку и звуки
   love.audio.play(playing)
   love.audio.play(playing_war)
   --списки для объектов меню
   --загружаем изображение для прожекторов
   lamp = love.graphics.newImage("img/bkg/lamp.png")
   --списки параметров прожекторов
   projector1 = {} --список параметров для прожектора справа
   table.insert(projector1,{x,y,r,v})
   projector1.x = 550
   projector1.y = 550
   projector1.r = 0
   projector1.v = true
   projector2 = {} --список параметров для прожектора за домами
   table.insert(projector2,{x,y,r,v})
   projector2.x = 300
   projector2.y = 570
   projector2.r = 0
   projector2.v = false
   projector3 = {} --список параметров для прожектора слева
   table.insert(projector3,{x,y,r,v})
   projector3.x = 150
   projector3.y = 600
   projector3.r = 0.5
   projector3.v = true
   --прячем мышь
   love.mouse.setVisible(false)
   --загружаем изображение курсора
   cursor = love.graphics.newImage("img/bkg/cursor.png")
   --загружаем фон для меню
   background = love.graphics.newImage("img/bkg/sky.png")
   --загружаем город
   city = love.graphics.newImage("img/bkg/city.png")
   --загружаем заголовок
   title = love.graphics.newImage("img/bkg/title.png")
   --загружаем нижнию панель(не знаю как правильно назвать этот красный четырёхугольник:))
   foot = love.graphics.newImage("img/bkg/foot.png")
   --создаём список юнито в их описаний справа от меню
   units = {} --список юнитов
   --загружаем список папок с изображениями юнитов
   units_image = love.filesystem.enumerate("img/bkg/units/img/")
   --обходим список папок с изображениями
   for i = 1,#units_image do
      --image - изображение
      --description - описание
      --width - ширина, height - высота
      --x,y - положение юнита
      table.insert(units,{image,description,width,height,x,y})
      --читаем файл с изображением
      units[i].image = love.graphics.newImage('img/bkg/units/img/'..units_image[i]..'/img1.png')
      --читаем файл с описанием
      units[i].description = love.filesystem.read('img/bkg/units/txt/'..units_image[i]..'/description')
      --читаем файл со свединиями о широте
      units[i].width = love.filesystem.read('img/bkg/units/txt/'..units_image[i]..'/width')
      --читаем файл со свединиями о широте
      units[i].height = love.filesystem.read('img/bkg/units/txt/'..units_image[i]..'/height')
      --вычисляем положения юнита по высоте и широте изображени.
      units[i].x = 768-units[i].width
      units[i].y = 600-units[i].height+10
   end
   --выбираем случайного юнита
   unit_random = math.random(#units)
   --загружаем изображение взрыва
   img_explosion = love.graphics.newImage("img/bkg/explosion.png")
   --загружаем изображения для бомб
   bomb = love.graphics.newImage("img/bkg/bomb.png") --бомба
   far_bomb = love.graphics.newImage("img/bkg/far_bomb.png") --далёкая бомба
   furthest_bomb = love.graphics.newImage("img/bkg/furthest_bomb.png") --самая далёкая бомба
   --списки параметров для бомб
   far_bombs = {} --список для дальних бомб
   furthest_bombs = {} --список для самых дальних бомб
   bombs = {} --список для бомб
   --список параметров для взрыва
   explosion = {}
   table.insert(explosion,{i,w,h})
   explosion.i = img_explosion
   explosion.w = 108
   explosion.h = 108
   --загружаем изображение далёкого взрыва
   img_far_explosion = love.graphics.newImage("img/bkg/far_explosion.png")
   --список параметров для далёкого взрыва
   far_explosion = {}
   table.insert(explosion,{i,w,h})
   far_explosion.i = img_far_explosion
   far_explosion.w = 58
   far_explosion.h = 58
   --загружаем изображение самого далёкого взрыва
   img_furthest_explosion = love.graphics.newImage("img/bkg/furthest_explosion.png")
   --список параметров для самого далёкого взрыва
   furthest_explosion = {}
   table.insert(explosion,{i,w,h})
   furthest_explosion.i = img_furthest_explosion
   furthest_explosion.w = 23
   furthest_explosion.h = 23
   --создаём бомбы
   make_particles(far_bombs,3)
   make_particles(furthest_bombs,3)
   make_particles(bombs,3)
   --кнопки меню
   button_tut = {} --список параметров для кнопки 'Обучение'
   table.insert(button_tut,{normal,over,pressed})
   button_tut.normal = love.graphics.newImage("img/bkg/button_tut_normal.png")
   button_tut.over = love.graphics.newImage("img/bkg/button_tut_over.png")
   button_tut.pressed = love.graphics.newImage("img/bkg/button_tut_pressed.png")
   cursor = love.graphics.newImage("img/bkg/cursor.png")
   button_versus = {} --список параметров для кнопки 'Сражение'
   table.insert(button_versus,{normal,over,pressed})
   button_versus.normal = love.graphics.newImage("img/bkg/button_versus_normal.png")
   button_versus.over = love.graphics.newImage("img/bkg/button_versus_over.png")
   button_versus.pressed = love.graphics.newImage("img/bkg/button_versus_pressed.png")
   cursor = love.graphics.newImage("img/bkg/cursor.png")
   button_campaign = {} --список параметров для кнопки 'Кампания'
   table.insert(button_campaign,{normal,over,pressed})
   button_campaign.normal = love.graphics.newImage("img/bkg/button_campaign_normal.png")
   button_campaign.over = love.graphics.newImage("img/bkg/button_campaign_over.png")
   button_campaign.pressed = love.graphics.newImage("img/bkg/button_campaign_pressed.png")
   cursor = love.graphics.newImage("img/bkg/cursor.png")
   button_options = {} --список параметров для кнопки 'Опции'
   table.insert(button_options,{normal,over,pressed})
   button_options.normal = love.graphics.newImage("img/bkg/button_options_normal.png")
   button_options.over = love.graphics.newImage("img/bkg/button_options_over.png")
   button_options.pressed = love.graphics.newImage("img/bkg/button_options_pressed.png")
   cursor = love.graphics.newImage("img/bkg/cursor.png")
   button_exit = {} --список параметров для кнопки 'Выход'
   table.insert(button_exit,{normal,over,pressed})
   button_exit.normal = love.graphics.newImage("img/bkg/button_exit_normal.png")
   button_exit.over = love.graphics.newImage("img/bkg/button_exit_over.png")
   button_exit.pressed = love.graphics.newImage("img/bkg/button_exit_pressed.png")
   button_about = {} --список параметров для кнопки 'Об игре'
   table.insert(button_about,{normal,over,pressed})
   button_about.normal = love.graphics.newImage("img/bkg/button_about_normal.png")
   button_about.over = love.graphics.newImage("img/bkg/button_about_over.png")
   button_about.pressed = love.graphics.newImage("img/bkg/button_about_pressed.png")
   --параметры окна 'Об игре'
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
   --Задаём главный шрифт
   mainFont = love.graphics.newFont("fnt/furore.otf", 12)
end

--function for updating
function love.update(dt)
   --Если музыка остановилась, то играть случайно выбранную музыку снова
   if playing:isStopped()then
      playing = love.audio.newSource("snd/mus/"..soundtrecks[math.random(#soundtrecks)])
      love.audio.play(playing)
   end
   --Если звуки остановились, то играть случайно выбранные звуки снова
   if playing_war:isStopped()then
      playing_war = love.audio.newSource("snd/war/"..soundwar[math.random(#soundwar)])
      love.audio.play(playing_war)
   end
   --перемещаем бомбы
   change_particles(far_bombs,90,120,dt)
   change_particles(furthest_bombs,70,120,dt)
   change_particles(bombs,100,120,dt)
   --перемещаем проекторы
   projector_move(projector1,-0.3,0.3,0.1,dt)
   projector_move(projector2,-0.4,0.1,0.1,dt)
   projector_move(projector3,-0.6,0.6,0.2,dt)
   --перемещаем окна
   if window_about.active then
      window_about.x = love.mouse.getX() - window_about.diffx
      window_about.y = love.mouse.getY() - window_about.diffy
   end
end

--Draw result
function love.draw()
   --рисуем фон
   love.graphics.draw(background,0,0)
   --рисуем бомбы заднего плана
   draw_particles(furthest_bombs,furthest_bomb,furthest_explosion)
   draw_particles(far_bombs,far_bomb,far_explosion)
   --рисуем прожектор за городом
   love.graphics.draw(lamp,projector2.x,projector2.y,projector2.r,1,1,75,586)
   --рисуем город
   love.graphics.draw(city,0,260)
   --рисуем бомбы переднего плана
   draw_particles(bombs,bomb,explosion)
   --рисуем прожекторы переднего плана
   love.graphics.draw(lamp,projector1.x,projector1.y,projector1.r,1,1,75,586)
   love.graphics.draw(lamp,projector3.x,projector3.y,projector3.r,1,1,75,586)
   --рисуем заголовок
   love.graphics.draw(title,15,14)
   --рисуем нижнюю панель
   love.graphics.draw(foot,-8,490)
   --рисуем юнита
   love.graphics.draw(units[unit_random].image,units[unit_random].x,units[unit_random].y)
   --рисуем кнопки и определяем что каждая должна делать
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
   --рисуем окно 'Об игре' если оно открыто
   if window_about.show then
      love.graphics.draw(window_about.normal,window_about.x,window_about.y)
   end
   --если нажата кнопка закрыто то окно закрываем
   if pressed(window_about.x,window_about.y,30,30) then
      window_about.show = false
      window_opened = false
   end
   --если курсор наведён на юнита, то выводим его описание
   if button_over(units[unit_random].x,units[unit_random].y,units[unit_random].width,units[unit_random].height) then
      love.graphics.setFont(mainFont)
      love.graphics.print(units[unit_random].description,300,565)
   end
   --рисуем курсор
   love.graphics.draw(cursor,love.mouse.getX(),love.mouse.getY())
end