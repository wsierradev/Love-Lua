love.graphics.setDefaultFilter('nearest', 'nearest')
enemy = {}
enemies_controller = {}
enemies_controller.enemies = {}
enemies_controller.image = love.graphics.newImage('enemy.png')

function checkCollisions(enemies, bullets)
  for i, e in ipairs(enemies) do
    for _, b in pairs(bullets) do
      if b.y <= e.y + e.height and b.x > e.x and b.x < e.x + e.width then
        table.remove(enemies, i)
        table.remove(bullets, 1)
      end
    end
  end
end

function love.load()
  local music = love.audio.newSource('BGM.mp3')
  music:setLooping(true)
  love.audio.play(music)
  game_over = false
  game_win = false
  background_image = love.graphics.newImage('background.png')

  player = {}
  player.image = love.graphics.newImage('player.png')
  player.fire_sound = love.audio.newSource('shoot.wav')
  player.x = 0
  player.y = 560
  player.bullets = {}
  player.cooldown = 10
  player.fire = function()
    love.audio.play(player.fire_sound)
    if player.cooldown <= 0 then
      player.cooldown = 20
      bullet = {}
      bullet.x = player.x + 10
      bullet.y = player.y
      table.insert(player.bullets, bullet)
    end
  end

  for i = 0, 8  do
    enemies_controller:spawnEnemy(i * 80, 0)
  end
end

function enemies_controller:spawnEnemy(x, y)
  enemy = {}
  enemy.x = x
  enemy.y = y
  enemy.width = 30
  enemy.height = 30
  enemy.bullets = {}
  enemy.cooldown = 10
  table.insert(self.enemies, enemy)
end

function enemy:fire()
  if self.cooldown <= 0 then
    self.cooldown = 10
    bullet = {}
    bullet.x = self.x + 45
    bullet.y = self.y
    table.insert(self.bullets, bullet)
  end
end


function love.update(dt)
  player.cooldown = player.cooldown - 1
  runspeed = 2
  if love.keyboard.isDown("lshift") then
    runspeed = 4
  end
  if love.keyboard.isDown("right") then
    player.x = player.x + runspeed
  elseif love.keyboard.isDown("left") then
    player.x = player.x - runspeed
  end

  if love.keyboard.isDown("space") then
    player.fire()
  end

  if #enemies_controller.enemies == 0 then
    game_win = true
  end

  for _,e in pairs(enemies_controller.enemies) do
    if e.y >= love.graphics.getHeight() then
      game_over = true
    end
    e.y = e.y + 1
  end

  for i,b in ipairs(player.bullets) do
    if b.y < -1 then
      table.remove(player.bullets, i)
    end
    b.y = b.y - 10

  end
  checkCollisions(enemies_controller.enemies, player.bullets)
end

function love.draw()
  love.graphics.setColor(255,255,255)
  local sx = love.graphics.getWidth() / background_image:getWidth()
  local sy = love.graphics.getHeight() / background_image:getHeight()
  love.graphics.draw(background_image, 0, 0, 0, sx, sy) -- x: 0, y: 0, rot: 0, scale x and scale y
  if game_over then
    love.graphics.print("Game Over Yeah!!!")
    return
  elseif game_win then
    love.graphics.print("A winner is you!!!!")
  end
  --player
  love.graphics.setColor(255,255,255)
  love.graphics.draw(player.image, player.x, player.y, 0, 1)

  for _,e in pairs(enemies_controller.enemies) do
    love.graphics.draw(enemies_controller.image, e.x, e.y)
  end
  --bullets
  love.graphics.setColor(255,255,255)
  for _,b in pairs(player.bullets) do
    love.graphics.rectangle("fill", b.x, b.y, 5, 10)
  end
end
