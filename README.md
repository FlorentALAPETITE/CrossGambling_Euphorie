# CrossGambling Euphorie Edition

Forked version of CrossGambling addon (https://github.com/krazyito65/CrossGambling) for World of Warcraft Retail.
This version supports French language and is translated.

Originally made for the guild Euphorie (Hyjal) with the help of natinusala.

**Updated for Shadowlands 9.2.7**

## SpecialMessage system
The addon includes a generic specialMessage system : you can fill the SpecialMessage.lua file with messages that will be displayed when a specific player win or loose to the game.
Priority for the messages is as follows :
1. WinningPlayer --> LoosingPlayer --> SpecialMessage
2. WinningPlayer --> defaultWin --> SpecialMessage
3. LoosingPlayer --> defaultLoose --> SpecialMessage

SpecialMessage.lua needs to be filled according to the inner documentation.

## Recurent looser message
The addon also includes a looser message system to update the game messages with the player that lost the most gold. To update the player name, run a full stats computation.
