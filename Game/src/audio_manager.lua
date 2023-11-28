AudioManager = {_maximum_volume = 1}
local MUSIC_PATH = "Music/"

function AudioManager.stopMusic(self)
	if self._source 
	then
		self._source:stop()
		self._source = nil
		self._source_name = nil
	end
end

function AudioManager.pauseMusic(self)
	if self._source
	then
		self._source:pause()
	end
end

function AudioManager.resumeMusic(self)
	if self._source
	then
		self._source:resume()
	end
end


function AudioManager.setMusic(self, name_str, will_loop)
	self:stopMusic()
	print(name_str)
	if name_str == nil
	then
		self._source = nil
		self._source_name = nil
		return
	end
	
	self._source_name = name_str
	will_loop = will_loop or false
	self._source = love.audio.newSource(MUSIC_PATH..name_str, "stream")
	self._source:setLooping(will_loop)
end

function AudioManager.getMusicName(self)
	return self._source_name
end

function AudioManager.setVolumeMaximum(number)
	if not number or number > 1 or number < 0
	then
		error("Must choose a number between 0 and 1 "..number)
		return
	end
	self._maximum_volume = number
end

function AudioManager.setVolume(self, volume)
	if not volume or volume > 1 or volume < 0
	then
		error("Must choose a number between 0 and 1 "..volume)
		return
	end
	if self._source
	then
		self._source:setVolume(self._maximum_volume * volume)
	end
end

function AudioManager.playMusic(self)
	if self._source
	then
		print("playing...")
		self._source:play()
	end
end

function AudioManager.serialize(self, settings_table)
	local table = {
		playing_music = self._source_name,
	}
	if self._source
	then
		table.loop = self._source:isLooping()
		table.volume = self._source:getVolume()
	else
		table.loop = false
		table.volume = 1
	end
	return table
end

function AudioManager.deserialize(self, table)
	self._source_name = table.playing_music
	if self._source_name
	then
		self:setMusic(self._source_name, table.loop)
		self:setVolume(table.volume)
		self:playMusic()
	end
end
	
	
	
