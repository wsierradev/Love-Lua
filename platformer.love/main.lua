platform = {}
player = {}



function love.load()
  player.speed = 200
  player.jump_qty = 3
        -- This is the height and the width of the platform.
	platform.width = love.graphics.getWidth()    -- This makes the platform as wide as the whole game window.
	platform.height = love.graphics.getHeight()  -- This makes the platform as tall as the whole game window.

        -- This is the coordinates where the platform will be rendered.
	platform.x = 0                               -- This starts drawing the platform at the left edge of the game window.
	platform.y = platform.height / 2
        -- This is the coordinates where the player character will be rendered.
  player.x = love.graphics.getWidth() / 2   -- This sets the player at the middle of the screen based on the width of the game window.
  player.y = love.graphics.getHeight() / 2  -- This sets the player at the middle of the screen based on the height of the game window.

        -- This calls the file named "purple.png" and puts it in the variable called player.img.
  player.img = love.graphics.newImage('player.png')
        -- This starts drawing the platform at the very middle of the game window
  player.ground = player.y     -- This makes the character land on the plaform.
	player.y_velocity = 0        -- Whenever the character hasn't jumped yet, the Y-Axis velocity is always at 0.
	player.jump_height = -300    -- Whenever the character jumps, he can reach this height.
	player.gravity = -750        -- Whenever the character falls, he will descend at this rate.


end

function love.update(dt)
	if love.keyboard.isDown('d') then
		if player.x < (love.graphics.getWidth() - player.img:getWidth()) then
			player.x = player.x + (player.speed * dt)
		end
	elseif love.keyboard.isDown('a') then
		if player.x > 0 then
			player.x = player.x - (player.speed * dt)
		end
	end

	function love.keypressed(space)
    if space == "space" then
    player.jump_qty = player.jump_qty - 1
		if player.y_velocity == 0 and player.jump_qty > 0 then
			player.y_velocity = player.jump_height
    elseif player.jump_qty > 0 then
      player.y_velocity = player.jump_height
		end
  end
	end

	if player.y_velocity ~= 0 then
		player.y = player.y + player.y_velocity * dt
		player.y_velocity = player.y_velocity - player.gravity * dt
	end

	if player.y > player.ground then
		player.y_velocity = 0
    	player.y = player.ground
      player.jump_qty = 3
	end
end

function love.draw()
	love.graphics.setColor(255, 255, 255)        -- This sets the platform color to white. (The parameters are in RGB Color format).

        -- The platform will now be drawn as a white rectangle while taking in the variables we declared above.
	love.graphics.rectangle('fill', platform.x, platform.y, platform.width, platform.height)
  love.graphics.draw(player.img, player.x, player.y, 0, 1, 1, 0, 32)

end
