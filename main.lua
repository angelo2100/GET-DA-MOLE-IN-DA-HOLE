--Variable que inicializa el estado del juego desde el menu
gamestate= "menu"
--Variable que registra el combo actual separado en centenas, decenas y unidades para interactuar
--de manera mas facil con una interfaz grafica
combo={valor=0,centenas=0,decenas=0,unidades=0}
score={diezmil=0, mil=0,centenas=0,decenas=0,unidades=0}
coordinates={}
grid={}
empty={}
filled={}
timer=0
count=0

for i = 1, 5 do
      coordinates[i] = {}
      for j = 1, 5 do
          coordinates[i][j] = i .. "x" .. j
      end
  end

function reset()
  combo={valor=0,centenas=0,decenas=0,unidades=0}
  score={diezmil=0, mil=0,centenas=0,decenas=0,unidades=0}
  coordinates={}
  grid={}
  empty={}
  filled={}
  timer=0
  count=0
end
function llaveEncontrar(tabla, val)
    for k, v in pairs(tbl) do
        if v == val then
            return k
        end
    end
    return nil  -- No se encontro
end
function gameover()
  gamestate="gameover"
end
function fillgrid()
  for i = 1, 5 do
      coordinates[i] = {}
      for j = 1, 5 do
          coordinates[i][j] = i .. "x" .. j
          table.insert(empty,coordinates[i][j])
      end
  end
  
  for i = 1, 5 do
      for j = 1, 5 do
          grid[coordinates[i][j]] =
          {
          time=0,
          mole=false,
          spriteSheet=tempmole,
          animation=anim8.newAnimation(tempmolegrid('1-9',1),0.05,'pauseAtEnd'),
          xpos=358+(j-1)*130,
          ypos=59+(i-1)*130
        }
      end
  end
  
end

function drawhole()
  for i = 1, 5 do
      for j = 1, 5 do
        grid[coordinates[i][j]].animation:draw(tempmole,grid[coordinates[i][j]].xpos,grid[coordinates[i][j]].ypos)
        if(grid[coordinates[i][j]].mole==false)then
          grid[coordinates[i][j]].animation:pause()
        end
      end
  end
end

function love.load()
  math.randomseed(os.time())
  background = love.graphics.newImage("sprites/bg.png")
  anim8= require 'libraries/anim8'
  love.window.setFullscreen(true, "desktop")
  screen_width = love.graphics.getWidth()
  screen_height = love.graphics.getHeight()
  tempmole=love.graphics.newImage('sprites/Hole-Sheet.png')
  tempmolegrid=anim8.newGrid(130,130,1170,130)
  fillgrid()
end

function love.draw()
  for i = 0, love.graphics.getWidth() / background:getWidth() do
        for j = 0, love.graphics.getHeight() / background:getHeight() do
            love.graphics.draw(background, i * background:getWidth(), j * background:getHeight())
        end
  end
  local r,g,b = love.graphics.getColor()
  drawhole()
end

function love.update(dt)
  count=count+1
  timer=timer+1
  print(timer)
  if(timer==180-combo.valor)then
    timer=0
    randomI = math.random(1, #empty)
    moleout = empty[randomI]
    table.remove(empty,randomI)
    grid[moleout].mole=true
    grid[moleout].animation:resume()
  end
  for i = 1, 5 do
    for j = 1, 5 do
      if(count==60 and grid[coordinates[i][j]].mole) then
        count=0
        grid[coordinates[i][j]].time=grid[coordinates[i][j]].time+1
        if(grid[coordinates[i][j]].time==3)then
          gameover()
        end
      end
    end
  end
  for i = 1, 5 do
    for j = 1, 5 do
      grid[coordinates[i][j]].animation:update(dt)
    end
  end
end