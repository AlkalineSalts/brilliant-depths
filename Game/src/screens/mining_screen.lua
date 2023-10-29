require("src.screen")
require("src.components")
require("src.util")
local Color = require("src.color")
MiningGameScreen = {}
local MINING_SCREEN_WIDTH = 400
local MINING_SCREEN_HEIGHT = 400
local NumSquareWidth = 10
setmetatable(MiningGameScreen, {__index = Screen})

--Assumes pixels 40 x 40 images and 6 imaxes (40 x 240)
local TILE_IMAGE = love.graphics.newImage("Images/Mining/mining_tiles.png")
local PICKAXE_IMAGE = love.graphics.newImage("Images/Mining/pickaxe-80.png")
local HAMMER_IMAGE = love.graphics.newImage("Images/Mining/hammer-80.png")
local CURSOR_HAMMER = love.mouse.newCursor("Images/Mining/hammer.png", 9, 9)
local CURSOR_PICKAXE = love.mouse.newCursor("Images/Mining/pickaxe.png", 9, 9)
local IMAGE_CONSTANT = 40

local tileValToQuad = {}
for x = 0, 5
do
	tileValToQuad[x] = love.graphics.newQuad(x * IMAGE_CONSTANT, 0, IMAGE_CONSTANT, IMAGE_CONSTANT, TILE_IMAGE)
end

--Inner class for handling the tiles
local MiningTile = {}
local tile_metatable = {__index = MiningTile}
function MiningTile.new()
	local self = {}
	setmetatable(self, tile_metatable)
	self._tile_level = 1
	self._adjacent_tiles = {}
	return self
end

function MiningTile.addAdjacent(self, adj)
	self._adjacent_tiles[#self._adjacent_tiles + 1] = adj
end

function MiningTile.getAdjacent(self)
	return table.shallowCopy(self._adjacent_tiles)
end

function MiningTile.incrementTile(self)
	if self._tile_level < 5
	then
		self._tile_level = self._tile_level + 1
	end
end

function MiningTile.getTileValue(self)
	return self._tile_level
end

function MiningTile.decrementTile(self)
	if self._tile_level > 0
	then
		self._tile_level = self._tile_level - 1
	end
end

function MiningTile.isCleared(self)
	return self._tile_level == 0
end


function MiningGameScreen.draw(self)
	--Ready the spritebatch, then draw
	self._spritebatch:clear()
	for x = 0, NumSquareWidth - 1
	do
		for y = 0, NumSquareWidth - 1 
		do
			self._spritebatch:add(tileValToQuad[self._grid[x][y]:getTileValue()], x * IMAGE_CONSTANT, y * IMAGE_CONSTANT)
		end
	end
	love.graphics.draw(self._spritebatch, Screen.width / 2 - MINING_SCREEN_WIDTH / 2, Screen.height / 2 - MINING_SCREEN_HEIGHT / 2)
	
	
	Screen.draw(self)
end

local function growFrom(tile, num_grow)
	tile.___mark = true
	local markedTiles = {tile}
	for i = 1, num_grow
	do
		local numTiles = #markedTiles
		for tileNum = 1, numTiles
		do
			for _, potential_tile in ipairs(markedTiles[tileNum]:getAdjacent())
			do
				if not potential_tile.___mark
				then
					potential_tile.___mark = true
					markedTiles[#markedTiles + 1]  = potential_tile
				end
			end
		end
	end
	
	--Unmark and return tiles
	for _, marked in ipairs(markedTiles)
	do
		marked.___mark = nil
	end
	return markedTiles
end


function MiningGameScreen._putBackPickaxe(self)
	self._pick_up_pick_image:setImage(PICKAXE_IMAGE)
end

function MiningGameScreen._pickUpPickaxe(self)
	self._pick_up_pick_image:setImage(nil)
	love.mouse.setCursor(CURSOR_PICKAXE)
end

function MiningGameScreen._putBackHammer(self)
	self._pick_up_hammer_image:setImage(HAMMER_IMAGE)
end

function MiningGameScreen._pickUpHammer(self)
	self._pick_up_hammer_image:setImage(nil)
	love.mouse.setCursor(CURSOR_HAMMER)
end

function MiningGameScreen.new()
	local self = Screen.new()
	setmetatable(self, {__index = MiningGameScreen})
	self._grid = {}
	self._spritebatch = love.graphics.newSpriteBatch(TILE_IMAGE, NumSquareWidth * NumSquareWidth, "stream")
	--Setup the grid
	for x = 0, NumSquareWidth - 1
	do
		self._grid[x] = {}
		for y = 0, NumSquareWidth - 1
		do
			self._grid[x][y] = MiningTile.new()
		end
	end
	
	--Setting up the adjacency
	for x = 0, NumSquareWidth - 1
	do
		for y = 0, NumSquareWidth - 1
		do
			local thisTile = self._grid[x][y]
			if x ~= NumSquareWidth - 1
			then
				thisTile:addAdjacent(self._grid[x + 1][y])
			end
			if x ~= 0  
			then	
				thisTile:addAdjacent(self._grid[x - 1][y])
			end
			--Not needed for these, as null will not be added. Above prevents indexing a nil table
			thisTile:addAdjacent(self._grid[x][y + 1])
			thisTile:addAdjacent(self._grid[x][y - 1])
		end
	end
	
	
	local randomTile = self._grid[math.random(0, NumSquareWidth - 1)][math.random(0, NumSquareWidth - 1)]
	--Do the cycle four times, can be arbitrarily specified
	for i = 1, 4
	do
		local spotList = growFrom(randomTile, NumSquareWidth / 2)
		for _, tile in ipairs(spotList)
		do
			tile:incrementTile()
		end
		randomTile = spotList[math.random(#spotList)]
	end
	
	self._selected_tool = nil
	self._pick_up_pick_image = DrawableImage.new(PICKAXE_IMAGE, 80, 80)
	self._pick_up_pick_image.click = function() 
		if self._selected_tool ~= "pickaxe"
		then
			self:_putBackHammer()
			self:_pickUpPickaxe()
		end
	end
	self._pick_up_hammer_image = DrawableImage.new(HAMMER_IMAGE, 80, 80)
	self._pick_up_hammer_image.click = function()
		if self._selected_tool ~= "hammer"
		then
			self:_putBackPickaxe()
			self:_pickUpHammer()
		end
	end
	local toolCollection = VerticleCollection.new(self._pick_up_pick_image, self._pick_up_hammer_image)
	toolCollection:setX(Screen.width - toolCollection:getWidth())
	toolCollection:setY(Screen.height / 2 - toolCollection:getHeight() / 2)
	
	self:add(toolCollection)
	
	return self
end