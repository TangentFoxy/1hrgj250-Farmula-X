Gamestate = require "lib.gamestate"
world = require "states.world"

love.load = ->
  Gamestate.registerEvents!
  Gamestate.switch world
