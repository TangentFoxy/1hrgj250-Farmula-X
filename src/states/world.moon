math.randomseed os.time!
Gamestate = require "lib.gamestate"

w, h = love.graphics.getDimensions!
tileSize = 10

img = {
  land: love.graphics.newImage "img/land.png"
  seed: love.graphics.newImage "img/seed.png"
  sprout: love.graphics.newImage "img/sprout.png"
  stem: love.graphics.newImage "img/stem.png"
  harvest: love.graphics.newImage "img/harvest.png"
  player: love.graphics.newImage "img/player.png"
}

tiles = {
  grass: { img: 'land', color: {0, 2/3, 0, 1} }
  dry: { img: 'land', color: {1, 1, 0, 1} }
  wet: { img: 'land', color: {2/3, 2/3, 0, 1} }
}

objects = {
  seed: { img: 'seed', color: {0.5, 0.5, 0, 1 } }
  sprout: { img: 'sprout', color: {0.5, 1, 0.5, 1} }
  stem: { img: 'stem', color: {0.25, 0.5, 0.25, 1} }
  strawberry: { img: 'harvest', color: {1, 0, 0, 1} }
  player: { img: 'player', color: {2/3, 0, 0, 1} }
}

world = {}

world.init = =>
  for x = 0, w / tileSize
    world[x] = {}
    for y = 0, h / tileSize
      world[x][y] = { tiles.grass }
  world.x = w / tileSize / 2
  world.y = h / tileSize / 2
  table.insert(world[world.x][world.y], objects.player)

-- world.update = (dt) =>
world.getPosition = =>
  return @[@x][@y]

world.draw = =>
  for x = 0, w / tileSize
    for y = 0, h / tileSize
      for item in *world[x][y]
        love.graphics.setColor item.color
        love.graphics.draw img[item.img], x * tileSize, y * tileSize

  -- love.graphics.setColor 1, 1, 1, 1
  -- for x = 0, w / tileSize
  --   love.graphics.line x * tileSize, 0, x * tileSize, h
  -- for y = 0, h / tileSize
  --   love.graphics.line 0, y * tileSize, w, y * tileSize

  -- x, y = love.mouse.getPosition!
  -- love.graphics.setColor 0, 0, 0, 1
  -- love.graphics.rectangle "fill", math.floor(x / tileSize) * tileSize, math.floor(y / tileSize) * tileSize, tileSize, tileSize

world.keypressed = (key) =>
  switch key
    when "escape"
      love.event.quit!
    when "w"
      pos = world\getPosition!
      table.remove(pos, #pos)
      world.y = math.max 0, world.y - 1
      table.insert(world\getPosition!, objects.player)
    when "a"
      pos = world\getPosition!
      table.remove(pos, #pos)
      world.x = math.max 0, world.x - 1
      table.insert(world\getPosition!, objects.player)
    when "s"
      pos = world\getPosition!
      table.remove(pos, #pos)
      world.y = math.min h / tileSize - 1, world.y + 1
      table.insert(world\getPosition!, objects.player)
    when "d"
      pos = world\getPosition!
      table.remove(pos, #pos)
      world.x = math.min w / tileSize - 1, world.x + 1
      table.insert(world\getPosition!, objects.player)
    when "h"
      pos = world\getPosition!
      if pos[1] == tiles.grass
        pos[1] = tiles.dry
    when "c"
      pos = world\getPosition!
      if pos[1] == tiles.dry
        pos[1] = tiles.wet
    when "p"
      pos = world\getPosition!
      if (pos[1] == tiles.dry or pos[1] == tiles.wet) and #pos < 3 -- only player and ground
        table.insert(pos, 2, objects.seed)
    when "n"
      for x = 0, w / tileSize
        for y = 0, h / tileSize
          pos = world[x][y]
          if pos[1] == tiles.wet
            pos[1] = tiles.dry
            if #pos > 1
              switch pos[2]
                when objects.seed
                  pos[2] = objects.sprout
                when objects.sprout
                  pos[2] = objects.stem
                when objects.stem
                  if (not pos[3]) or (pos[3] and pos[3] != objects.strawberry)
                    table.insert(pos, 3, objects.strawberry)
          elseif pos[1] == tiles.dry
            if math.random! > 2/3
              pos[1] = tiles.grass
              if pos[2] and pos[2] != objects.player
                table.remove(pos, 2)
            if #pos > 1
              switch pos[2]
                when objects.sprout, objects.stem, objects.strawberry
                  table.remove(pos, 2)
    when "m"
      pos = world\getPosition!
      if pos[#pos - 1] == objects.strawberry
        table.remove(pos, #pos - 1)

return world
