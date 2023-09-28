package.path = package.path..";../?.lua"
Option = require("option")
Event = require("event")
GameEngine = require("game_engine")
EventManager = require("event_manager")
local event_manager = EventManager.new("GameRoot")
local game_engine = GameEngine.new("Example_Event", event_manager)
