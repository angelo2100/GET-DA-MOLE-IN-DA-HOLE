--Variable que inicializa el estado del juego desde el menu
gamestate= "menu"
combo=0
coordinates={}
grid={}
empty={}
for i = 1, 5 do
      coordinates[i] = {}
      for j = 1, 5 do
          coordinates[i][j] = i .. "x" .. j
      end
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
            
          mole=false,
          spriteSheet=tempmole,
          animation=tempmoleanimation,
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
        grid[coordinates[i][j]].animation:pause()
      end
  end
end

function love.load()
  background = love.graphics.newImage("sprites/bg.png")
  anim8= require 'libraries/anim8'
  love.window.setFullscreen(true, "desktop")
  screen_width = love.graphics.getWidth()
  screen_height = love.graphics.getHeight()
  tempmole=love.graphics.newImage('sprites/Hole-Sheet.png')
  tempmolegrid=anim8.newGrid(130,130,1170,130)
  tempmoleanimation=anim8.newAnimation(tempmolegrid('1-9',1),0.5)
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
  for i = 1, 5 do
      for j = 1, 5 do
        
        grid[coordinates[i][j]].animation:update(dt)
        
      end
  end
end