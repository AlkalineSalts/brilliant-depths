local all_died = Event.new("all_died")
all_died.get_text = function (self, game_data) return string.format("Everyone in the party is dead. You will body now serves as food and home for the next generation of the great pit.\nFinal Depth: %d", game_data.depth) end
all_died.can_be_chosen = function(self, game_data) return #game_data.party == 0 end
return all_died
