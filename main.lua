--Variable que inicializa el estado del juego desde el menu
gamestate= "menu"
--Variable que registra el combo y puntuacion actual separado en centenas, decenas y unidades para interactuar
--de manera mas facil con una interfaz grafica
combo={valor=0,digitos={0,0,0}}
score={valor=0,digitos={0,0,0,0,0}}
--Variable para almacenar el sonido de la muerte de los topos
sound=love.audio.newSource("sounds/Kill.mp3","static")
--Coleccion de las imagenes de fondo
background={menu= love.graphics.newImage("sprites/bgmenu.png"),
            game = love.graphics.newImage("sprites/bg.png"),
            gameover = love.graphics.newImage("sprites/bggameover.png")}
--Tabla para la musica de fondo de las 3 interfaces
music={}
--Almaceno los valores originales del rgb para que no se cambien del original cuando los cambie al generar un boton
local r,g,b = love.graphics.getColor()
--Matriz para las coordenadas de la cuadricula
coordinates={}
--La cuadricula con los objetivos
grid={}
--Renglon grafico de las puntuaciones y combo
scorerow={}
comborow={}
--Lo utilizo para determinar que celdas estan sin topos
empty={}
--Variables de conteo para tiempo para generar mas topos y determinar un fin de juego
timer=0
count=0
--Almacenamiento de la tabla de canciones para las 3 interfaces
music.menu = love.audio.newSource( 'music/menu.mp3', 'stream' )
music.game = love.audio.newSource( 'music/game.mp3', 'stream' )
music.gameover = love.audio.newSource( 'music/gameover.mp3', 'stream' )
bgmusic= music.menu
--Relleno de las coordenadas 1x1 a 5x5
for i = 1, 5 do
  coordinates[i] = {}
  for j = 1, 5 do
    coordinates[i][j] = i .. "x" .. j
  end
end

--Tomo el valor entero de la puntuacion y lo separo en 5 digitos
function scoreSeparar(n)
    score.digitos[1] = math.floor(n / 10000) % 10
    score.digitos[2] = math.floor(n / 1000) % 10
    score.digitos[3] = math.floor(n / 100) % 10
    score.digitos[4] = math.floor(n / 10) % 10
    score.digitos[5] = n % 10
end
--Tomo el valor entero de el combo y lo separo en 3 digitos
function comboSeparar(n)
  combo.digitos[1] = math.floor(n / 100) % 10
  combo.digitos[2] = math.floor(n / 10) % 10
  combo.digitos[3] = n % 10
end
--Devuelve todos los valores a 0 para iniciar un nuevo juego
function reset()
  --Inicio la semilla para que no siempre sea el mismo juego
  math.randomseed(os.time())
  combo={valor=0,digitos={0,0,0}}
  score={valor=0,digitos={0,0,0,0,0}}
  scorerow={}
  comborow={}
  grid={}
  empty={}
  timer=0
  count=0
end
--Relleno ambos renglones con sus posiciones y una animacion la cual no se puede percibir en el juego por lo rapido que se actualiza
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
--Se acaba el juego y manda a la interfaz de gameover
function gameover()
  gamestate="gameover"
  bgmusic:stop()
  bgmusic=music.gameover
end
--Relleno la cuadricula de todos los elementos y dejo las animaciones registradas para todas ellas
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
--Grafico los renglones de puntuacion y de combo
function drawrows()
  for i = 1, 5 do
        scorerow[i].animation:draw(numbers,scorerow[i].xpos,scorerow[i].ypos)
  end
  for i = 1, 3 do
        comborow[i].animation:draw(numbers,comborow[i].xpos,comborow[i].ypos)
  end
end
--Grafico todos los agujeros
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
--Esta funcion solo se lleva a cabo la primera vez que inicia el programa los valores se quedan como globales para su uso durante todo el programa
function love.load()
  --Inicio la semilla para que no siempre sea el mismo juego
  math.randomseed(os.time())
  anim8= require 'libraries/anim8'
  love.window.setFullscreen(true, "desktop")
  screen_width = love.graphics.getWidth()
  screen_height = love.graphics.getHeight()
  numbers=love.graphics.newImage('sprites/Numbers.png')
  tempmole=love.graphics.newImage('sprites/Hole-Sheet.png')
  tempmolegrid=anim8.newGrid(130,130,1170,130)
  numbersgrid=anim8.newGrid(40,75,400,75)
end
--Se dibujan las cosas segun lo requiera la interfaz
function love.draw()
  for i = 0, love.graphics.getWidth() / background[gamestate]:getWidth() do
        for j = 0, love.graphics.getHeight() / background[gamestate]:getHeight() do
            love.graphics.draw(background[gamestate], i * background[gamestate]:getWidth(), j * background[gamestate]:getHeight())
        end
  end
  if(gamestate=="game")then
    drawhole()
    drawrows()
  elseif(gamestate=="menu")then
    love.graphics.draw(love.graphics.newImage('sprites/Play.png'), 533, 384)
  elseif(gamestate=="gameover")then
    drawrows()
    love.graphics.draw(love.graphics.newImage('sprites/Menu.png'), 533, 384)
    love.graphics.setColor(100,0,0)
    love.graphics.rectangle("fill", 533, 584, 300, 200)
    love.graphics.setColor(r,g,b)
  end
end
--Esta seccion de codigo se actualiza cada 1/60 de segundo la cual actualiza animaciones y hace conteos para eventos
function love.update(dt)
  bgmusic:setLooping( true )
  bgmusic:play()
  if(gamestate=="game")then
    for i = 1, 5 do
      scorerow[i].animation:gotoFrame(score.digitos[i]+1)
    end
    for i = 1, 3 do
      comborow[i].animation:gotoFrame(combo.digitos[i]+1)
    end
    timer=timer+1
    if(timer>=100-combo.valor and #empty>0)then
      timer=0
      randomI = math.random(1, #empty)
      moleout = empty[randomI]
      table.remove(empty,randomI)
      grid[moleout].mole=true
      grid[moleout].animation:resume()
    end
    for i = 1, 5 do
      for j = 1, 5 do
        grid[coordinates[i][j]].animation:update(dt)
      end
    end
    if(#empty<25)then
      count=count+1
      if(count==180)then
        gameover()
      end
    else
      count=0
    end
  end
end
--En base a la posicion del mouse, el click que se tenga presionado y el menu en el que se encuentre provoca distintos eventos
function love.mousepressed(x,y,button,istouch)
  if(gamestate=="game")then
    --Si es que el usuario hace click dentro de los limites de la cuadricula y encima hace click sobre un espacio donde se encuentre un topo activo, este lo elimina y libera el espacio
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
      if(grid[coord].mole) then
        sound:stop()
        sound:play()
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
  elseif(gamestate=="menu")then
    if button == 1 and x > 533 and x < 833 and y > 384 and y < 584 then
      --reinicio los renglones y la cuadricula de juego
      gamestate="game"
      bgmusic:stop()
      bgmusic=music.game
      fillrows()
      fillgrid()
    end
  elseif(gamestate=="gameover")then
    if button == 1 and x > 533 and x < 833 and y > 384 and y < 584 then
      --Reinicio el juego y vuelvo al menu
      reset()
      gamestate="menu"
      bgmusic:stop()
      bgmusic=music.menu
    elseif button == 1 and x > 533 and x < 833 and y > 584 and y < 768 then
      --Cierro el juego
      love.event.quit() 
    end
  end
end