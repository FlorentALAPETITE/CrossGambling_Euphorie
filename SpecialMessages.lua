local _, CrossGambling = ...

CrossGambling.SpecialMessages = {
	--[[ SpecialMessage Format :

	["PlayerName"] = {
		["LooserName"] = "special message for the winner to the looser."
		defaultLoose = "default special message for a loose."
		defaultWin = "default special message for a win."
	},

	SpecialMessage priority order :
		1. WinningPlayer --> LoosingPlayer --> SpecialMessage
		2. WinningPlayer --> defaultWin --> SpecialMessage
		3. LoosingPlayer --> defaultLoose --> SpecialMessage

	]]--
}
