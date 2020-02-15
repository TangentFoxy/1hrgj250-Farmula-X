w, h = love.graphics.getDimensions!
tileSize = 20

tiles = {
  grass: love.graphics.newImage! -- TODO
}

world = {}
for x = 0, w / tileSize
  world[x] = {}
  for y = 0, h / tileSize
    world[x][y] = tiles.grass

love.draw = ->
  for x = 0, w / tileSize
    for y = 0, h / tileSize
  -- for x = 0, w / tileSize
  --   love.graphics.line x * tileSize, 0, x * tileSize, h
  -- for y = 0, h / tileSize
  --   love.graphics.line 0, y * tileSize, w, y * tileSize

love.keypressed = (key) ->
  switch key
    when "escape"
      love.event.quit!
