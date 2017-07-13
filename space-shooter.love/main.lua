love.graphics.setDefaultFilter('nearest', 'nearest')
enemy = {}
enemies_controller = {}
enemies_controller.enemies = {}
enemies_controller.image = love.graphics.newImage('enemy.png')


function love.load()
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
    enemies_controller:spawnEnemy(0, 0)
    enemies_controller:spawnEnemy(65, 0)
    enemies_controller:spawnEnemy(130, 0)
    enemies_controller:spawnEnemy(195, 0)
end

function enemies_controller:spawnEnemy(x, y)
  enemy = {}
  enemy.x = x
  enemy.y = y
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

  for _,e in pairs(enemies_controller.enemies) do
    e.y = e.y + 1
  end

  for i,b in ipairs(player.bullets) do
    if b.y < -1 then
      table.remove(player.bullets, i)
    end
    b.y = b.y - 10

  end
end

function love.draw()
  --player
  love.graphics.setColor(255,255,255)
  love.graphics.draw(player.image, player.x, player.y, 0, 1)

  for _,e in pairs(enemies_controller.enemies) do
    love.graphics.draw(enemies_controller.image, e.x, e.y, 0, 2)
  end
  --bullets
  love.graphics.setColor(0,0,255)
  for _,b in pairs(player.bullets) do
    love.graphics.rectangle("fill", b.x, b.y, 10, 10)
  end
end
