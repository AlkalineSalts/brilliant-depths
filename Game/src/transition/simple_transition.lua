require("src.transition.fade_out")
require("src.transition.fade_in")
SimpleTransition = {}

function SimpleTransition.fadeTransition(nextScreen)
	GameManager.setTransition(FadeOut.new():setEndhook(function(self) GameManager.changeScreen(nextScreen) GameManager.setTransition(FadeIn.new()) end))
end

return SimpleTransition