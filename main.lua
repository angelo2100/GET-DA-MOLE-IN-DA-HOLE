--Variable que inicializa el estado del juego desde el menu
gamestate= "menu"
--Variable que registra el combo actual separado en centenas, decenas y unidades para interactuar
--de manera mas facil con una interfaz grafica
combo={valor=0,digitos={0,0,0}}
score={valor=0,digitos={0,0,0,0,0}}
coordinates={}
grid={}
scorerow={}
comborow={}
empty={}
timer=0
count=0

for i = 1, 5 do
      coordinates[i] = {}
      for j = 1, 5 do
          coordinates[i][j] = i .. "x" .. j
      end
  end

function scoreSeparar(n)
    score.digitos[1] = math.floor(n / 10000) % 10
    score.digitos[2] = math.floor(n / 1000) % 10
    score.digitos[3] = math.floor(n / 100) % 10
    score.digitos[4] = math.floor(n / 10) % 10
    score.digitos[5] = n % 10
end

function comboSeparar(n)
  combo.digitos[1] = math.floor(n / 100) % 10
  combo.digitos[2] = math.floor(n / 10) % 10
  combo.digitos[3] = n % 10
end

function reset()
  combo={valor=0,digitos={0,0,0}}
  score={valor=0,digitos={0,0,0,0,0}}
  scorerow={}
  comborow={}
  coordinates={}
  grid={}
  empty={}
  timer=0
  count=0
end

function fillrows()
  for i = 1, 5 do
          scorerow[i] =
          {
          animation=anim8.newAnimation(numbersgrid('1-10',1),0.01),
          xpos=80+(i-1)*40,
          ypos=346
        }
  end
  for i = 1, 3 do
          comborow[i] =
          {
          animation=anim8.newAnimation(numbersgrid('1-10',1),0.01),
          xpos=1130+(i-1)*40,
          ypos=346
        }
  end
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
          animation=anim8.newAnimation(tempmolegrid('1-9',1),0.05,'pauseAtEnd'),
          xpos=358+(j-1)*130,
          ypos=59+(i-1)*130
        }
      end
  end
  
end

function drawrows()
  for i = 1, 5 do
        scorerow[i].animation:draw(numbers,scorerow[i].xpos,scorerow[i].ypos)
  end
  for i = 1, 3 do
        comborow[i].animation:draw(numbers,comborow[i].xpos,comborow[i].ypos)
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
  numbers=love.graphics.newImage('sprites/Numbers.png')
  tempmole=love.graphics.newImage('sprites/Hole-Sheet.png')
  tempmolegrid=anim8.newGrid(130,130,1170,130)
  numbersgrid=anim8.newGrid(40,75,400,75)
  fillrows()
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
  drawrows()
end

function love.update(dt)
  for i = 1, 5 do
    scorerow[i].animation:gotoFrame(score.digitos[i]+1)
  end
  for i = 1, 3 do
    comborow[i].animation:gotoFrame(combo.digitos[i]+1)
  end
  count=count+1
  timer=timer+1
  if(timer==180-combo.valor and #empty>0)then
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

function love.mousepressed(x,y,button,istouch)
  if button == 1 and x > 358 and x < 1008 and y > 59 and y < 709 then
    c=0
    r=0
    for i = 1, 5 do
      if(x>358+(i-1)*130 and x<358+(i-1)*130+130)then
        c=i
      end
      if(y>59+(i-1)*130 and y<59+(i-1)*130+130)then
        r=i
      end
    end
    coord= r.."x"..c
    print(coord)
    if(grid[coord].mole) then
      table.insert(empty,coord)
      grid[coord].mole=false
      grid[coord].animation:pauseAtStart()
      combo.valor=combo.valor+1
      comboSeparar(combo.valor)
      for i = 1, 3 do
        comborow[i].animation:resume()
      end
      score.valor=score.valor+combo.valor
      scoreSeparar(score.valor)
      for i = 1, 5 do
        scorerow[i].animation:resume()
      end
    end
  end
end