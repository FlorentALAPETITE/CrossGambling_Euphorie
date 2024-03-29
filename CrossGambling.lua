local _, CrossGambling2 = ...
local L = CrossGambling2.L
local SpecialMessages = CrossGambling2.SpecialMessages
local AcceptOnes = false
local AcceptRolls = "false"
local AcceptLoserAmount = false
local HousePercent = 10
local totalrolls = 0
local tierolls = 0
local theMax
local lowname = ""
local highname = ""
local low = 0
local high = 0
local tie = 0
local highbreak = 0
local lowbreak = 0
local tiehigh = 0
local tielow = 0
local chatmethod = "RAID"
local whispermethod = false
local totalentries = 0
local highplayername = ""
local lowplayername = ""
local rollCmd = SLASH_RANDOM1:upper()
local debugLevel = 0
local virag_debug = false
local chatmethods = {
    "RAID",
    "GUILD",
    "CHANNEL",
    "PARTY"
}
local chatmethod = chatmethods[1]
local defaultWin = "defaultWin"
local defaultLoose = "defaultLoose"

BACKDROP_DIALOG_CG = {
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
    tile = true,
    tileEdge = true,
    tileSize = 32,
    edgeSize = 32,
    insets = {left = 11, right = 12, top = 12, bottom = 11}
}

-- LOAD FUNCTION --
function CrossGambling_OnLoad(self)
    DEFAULT_CHAT_FRAME:AddMessage("|cffffff00<CrossFire Gambling Euphorie for WoW 9.2.7> loaded /cg to use")

    self:RegisterEvent("CHAT_MSG_RAID")
    self:RegisterEvent("CHAT_MSG_CHANNEL")
    self:RegisterEvent("CHAT_MSG_RAID_LEADER")
    self:RegisterEvent("CHAT_MSG_PARTY")
    self:RegisterEvent("CHAT_MSG_PARTY_LEADER")
    self:RegisterEvent("CHAT_MSG_GUILD")
    self:RegisterEvent("CHAT_MSG_SYSTEM")
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterForDrag("LeftButton")

    CrossGambling_ROLL_Button:Disable()
    CrossGambling_AcceptOnes_Button:Enable()
    CrossGambling_LASTCALL_Button:Disable()
    CrossGambling_CHAT_Button:Enable()
    self:SetBackdrop(BACKDROP_DIALOG_CG)
end

local EventFrame = CreateFrame("Frame")
EventFrame:RegisterEvent("CHAT_MSG_WHISPER") -- Need to register an event to receive it
EventFrame:SetScript(
    "OnEvent",
    function(self, event, msg, sender)
        if msg:lower():find("!stats") then --    We're making sure the command is case insensitive by casting it to lowercase before running a pattern check
            ChatMsg("Work in Progress", "WHISPER", nil, sender)
        end
    end
)

local function Print(pre, red, text)
    if red == "" then
        red = "/CG"
    end
    DEFAULT_CHAT_FRAME:AddMessage(pre .. GREEN_FONT_COLOR_CODE .. red .. FONT_COLOR_CODE_CLOSE .. ": " .. text)
end

local function DebugMsg(level, text)
    if debugLevel < level then
        return
    end

    if level == 1 then
        level = " INFO: "
    elseif level == 2 then
        level = " DEBUG: "
    elseif level == 3 then
        level = " ERROR: "
    end
    Print(
        "",
        "",
        GRAY_FONT_COLOR_CODE .. date("%H:%M:%S") .. RED_FONT_COLOR_CODE .. level .. FONT_COLOR_CODE_CLOSE .. text
    )
end

----- EUPHORIE -------

function GetSpecialMessage(looser, winner)
    winnerDict = SpecialMessages[winner]
    looserDict = SpecialMessages[looser]

    if winnerDict == nil then
        winnerDict = {}
    end
    if looserDict == nil then
        looserDict = {}
    end

    -- Get Winner to Looser specialMessage
    specialMessage = winnerDict[looser]

    -- Get Winner defaultWin specialMessage
    if not specialMessage then
        specialMessage = winnerDict[defaultWin]
    end

    -- Get Looser defaultLoose specialMessage
    if not specialMessage then
        specialMessage = looserDict[defaultLoose]
    end

    return specialMessage
end

function CrossGambling_show_reset_dialog()
    if not reset_dialog then
        local f = CreateFrame("Frame", "UnlockDialog", UIParent, BackdropTemplateMixin and "BackdropTemplate")
        f:SetFrameStrata("DIALOG")
        f:SetToplevel(true)
        f:EnableMouse(true)
        f:SetMovable(true)
        f:SetClampedToScreen(true)
        f:SetWidth(360)
        f:SetHeight(110)
        f:SetBackdrop {
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
            tile = true,
            insets = {left = 11, right = 12, top = 12, bottom = 11},
            tileSize = 32,
            edgeSize = 32
        }
        f:SetPoint("TOP", 0, -50)
        f:Hide()
        f:SetScript(
            "OnShow",
            function()
                PlaySound(SOUNDKIT and SOUNDKIT.IG_MAINMENU_OPTION or "igMainMenuOption")
            end
        )
        f:SetScript(
            "OnHide",
            function()
                PlaySound(SOUNDKIT and SOUNDKIT.GS_TITLE_OPTION_EXIT or "gsTitleOptionExit")
            end
        )

        f:RegisterForDrag("LeftButton")
        f:SetScript(
            "OnDragStart",
            function(f)
                f:StartMoving()
            end
        )
        f:SetScript(
            "OnDragStop",
            function(f)
                f:StopMovingOrSizing()
            end
        )

        local header = f:CreateTexture(nil, "ARTWORK")
        header:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Header")
        header:SetWidth(256)
        header:SetHeight(64)
        header:SetPoint("TOP", 0, 12)

        local title = f:CreateFontString("ARTWORK")
        title:SetFontObject("GameFontNormal")
        title:SetPoint("TOP", header, "TOP", 0, -14)
        title:SetText("CrossGambling")

        local desc = f:CreateFontString("ARTWORK")
        desc:SetFontObject("GameFontHighlight")
        desc:SetJustifyV("TOP")
        desc:SetJustifyH("LEFT")
        desc:SetPoint("TOPLEFT", 18, -42)
        desc:SetPoint("BOTTOMRIGHT", -18, 48)
        desc:SetText("Voulez-vous vraiment reset les stats ?")

        local yes_button = CreateFrame("CheckButton", "Yes", f, "OptionsButtonTemplate")
        getglobal(yes_button:GetName() .. "Text"):SetText("RESET")

        yes_button:SetScript(
            "OnClick",
            function(self)
                print("Les stats ont été reset.")
                CrossGambling_ResetStats()
                reset_dialog:Hide()
            end
        )

        local no_button = CreateFrame("CheckButton", "No", f, "OptionsButtonTemplate")
        getglobal(no_button:GetName() .. "Text"):SetText("Non")

        no_button:SetScript(
            "OnClick",
            function(self)
                reset_dialog:Hide()
            end
        )

        --position buttons
        yes_button:SetPoint("BOTTOMRIGHT", -210, 14)
        no_button:SetPoint("BOTTOMRIGHT", -55, 14)

        reset_dialog = f
    end
    reset_dialog:Show()
end

-----------

local function ChatMsg(msg, chatType, language, channel)
    chatType = chatType or chatmethod
    channelnum = GetChannelName(channel or CrossGambling["channel"] or "gambling")
    SendChatMessage(msg, chatType, language, channelnum)
end

function hide_from_xml()
    CrossGambling_SlashCmd("hide")
    CrossGambling["active"] = 0
end

function CrossGambling_SlashCmd(msg)
    local msg = msg:lower()
    local msgPrint = 0
    if (msg == "" or msg == nil) then
        Print("", "", "~Following commands for CrossGambling~")
        Print("", "", "show - Shows the frame")
        Print("", "", "hide - Hides the frame")
        Print("", "", "channel - Change the custom channel for gambling")
        Print("", "", "reset - Resets the AddOn")
        Print("", "", "fullstats - list full stats")
        Print("", "", "resetstats - Resets the stats")
        Print("", "", "joinstats [main] [alt] - Apply [alt]'s win/losses to [main]")
        Print("", "", "minimap - Toggle minimap show/hide")
        Print("", "", "unjoinstats [alt] - Unjoin [alt]'s win/losses from whomever it was joined to")
        Print("", "", "ban - Ban's the user from being able to roll")
        Print("", "", "unban - Unban's the user")
        Print("", "", "listban - Shows ban list")
        Print("", "", "house - Toggles guild house cut")
        Print("", "", "loser - Toggles ability for loser to set next amount.")
        msgPrint = 1
    end
    if (msg == "hide") then
        CrossGambling_Frame:Hide()
        CrossGambling["active"] = 0
        msgPrint = 1
    end
    if (msg == "show") then
        CrossGambling_Frame:Show()
        CrossGambling["active"] = 1
        msgPrint = 1
    end
    if (msg == "reset") then
        CrossGambling_Reset()
        CrossGambling_ResetCmd()
        msgPrint = 1
    end
    if (msg == "fullstats") then
        CrossGambling_OnClickSTATS(true)
        msgPrint = 1
    end
    if (msg == "resetstats") then
        Print("", "", "|cffffff00GCG stats have now been reset")
        CrossGambling_ResetStats()
        msgPrint = 1
    end
    if (msg == "minimap") then
        Minimap_Toggle()
        msgPrint = 1
    end
    if (string.sub(msg, 1, 7) == "channel") then
        CrossGambling_ChangeChannel(strsub(msg, 9))
        msgPrint = 1
    end
    if (string.sub(msg, 1, 9) == "joinstats") then
        CrossGambling_JoinStats(strsub(msg, 11))
        msgPrint = 1
    end
    if (string.sub(msg, 1, 11) == "unjoinstats") then
        CrossGambling_UnjoinStats(strsub(msg, 13))
        msgPrint = 1
    end

    if (string.sub(msg, 1, 3) == "ban") then
        CrossGambling_AddBan(strsub(msg, 5))
        msgPrint = 1
    end

    if (string.sub(msg, 1, 5) == "unban") then
        CrossGambling_RemoveBan(strsub(msg, 7))
        msgPrint = 1
    end

    if (string.sub(msg, 1, 7) == "listban") then
        CrossGambling_ListBan()
        msgPrint = 1
    end

    if (string.sub(msg, 1, 5) == "house") then
        CrossGambling_ToggleHouse()
        msgPrint = 1
    end

    if (string.sub(msg, 1, 5) == "loser") then
        CrossGambling_ToggleLoser()
        msgPrint = 1
    end

    if (msgPrint == 0) then
        Print("", "", "|cffffff00Invalid argument for command /cg")
    end
end

SLASH_CrossGambling1 = "/CrossGambler"
SLASH_CrossGambling2 = "/cg"
SlashCmdList["CrossGambling"] = CrossGambling_SlashCmd

function CrossGambling_ParseChatMsg(arg1, arg2)
    if (AcceptOnes) then
        if (arg1 == "1") then
            if (CrossGambling_ChkBan(tostring(arg2)) == 0) then
                CrossGambling_Add(tostring(arg2))
                if (not CrossGambling_LASTCALL_Button:IsEnabled() and totalrolls == 1) then
                    CrossGambling_LASTCALL_Button:Enable()
                end
                if totalrolls == 2 then
                    CrossGambling_AcceptOnes_Button:Disable()
                    CrossGambling_AcceptOnes_Button:SetText("Open Entry")
                end
            else
                ChatMsg("Sorry, but you're banned from the game!")
            end
        elseif (arg1 == "-1") then
            CrossGambling_Remove(tostring(arg2))
            if (CrossGambling_LASTCALL_Button:IsEnabled() and totalrolls == 0) then
                CrossGambling_LASTCALL_Button:Disable()
            end
            if totalrolls == 1 then
                CrossGambling_AcceptOnes_Button:Enable()
                CrossGambling_AcceptOnes_Button:SetText("Open Entry")
            end
        end
    elseif (AcceptLoserAmount) then --AcceptLoserAmount is set to player that just lost
        charname, realmname = strsplit("-", tostring(arg2))
        if (charname:gsub("^%l", string.upper) == AcceptLoserAmount) then
            key, amount = strsplit(" ", arg1)
            if (key == "!amount" and tonumber(amount)) then
                CrossGambling_EditBox:SetText(tonumber(amount))
                CrossGambling["lastroll"] = tonumber(amount)
                if tonumber(amount) > 1000000 then
                    NextAmount =
                        strjoin(
                        "",
                        AcceptLoserAmount,
                        " ",
                        "set next gamble amount to 1.000.000!",
                        " ",
                        "(Sorry 1.000.000 are roll cap)"
                    )
                else
                    NextAmount =
                        strjoin(
                        "",
                        AcceptLoserAmount,
                        " ",
                        "a choisi ",
                        BreakUpLargeNumbers(amount),
                        " pièces d'or pour le prochain pari !"
                    )
                end
                ChatMsg(NextAmount)
                AcceptLoserAmount = false
            end
        end
    end
end

local function OptionsFormatter(text, prefix)
    if prefix == "" or prefix == nil then
        prefix = "/CG"
    end
    DEFAULT_CHAT_FRAME:AddMessage(
        string.format("%s%s%s: %s", GREEN_FONT_COLOR_CODE, prefix, FONT_COLOR_CODE_CLOSE, text)
    )
end

function debug(name, data)
    if not virag_debug then
        return false
    elseif not ViragDevTool_AddData and virag_debug then
        OptionsFormatter("VDT not enabled for debugging")
        return false
    elseif not data or not name then
        OptionsFormatter(string.format("Debug failed: data: %s, name: %s", data, name))
        return false
    end
    ViragDevTool_AddData(data, name)
end

function CrossGambling_OnEvent(self, event, ...)
    -- LOADS ALL DATA FOR INITIALIZATION OF ADDON --
    if (event == "PLAYER_ENTERING_WORLD") then
        CrossGambling_EditBox:SetJustifyH("CENTER")

        if (CrossGambling == nil) then
            -- fix older legacy items for new chat channels.  Probably need to iterate through each to see if it should be set.
            print("ofkpqsfkdfsfdfs")

            CrossGambling = {
                ["active"] = 1,
                ["chat"] = 1,
                ["channel"] = "gambling",
                ["whispers"] = false,
                ["strings"] = {},
                ["lowtie"] = {},
                ["hightie"] = {},
                ["bans"] = {}
            }
        elseif tostring(type(CrossGambling["chat"])) ~= "number" then
            CrossGambling["chat"] = 1
        elseif CrossGambling["minimap"] == nil then
            -- If the value is not true/false then set it to true to show initially.
            CrossGambling["minimap"] = true
        end
        if (not CrossGambling["lastroll"]) then
            CrossGambling["lastroll"] = 100
        end
        if (not CrossGambling["stats"]) then
            CrossGambling["stats"] = {}
        end
        if (not CrossGambling["joinstats"]) then
            CrossGambling["joinstats"] = {}
        end
        if (not CrossGambling["chat"]) then
            CrossGambling["chat"] = 1
        end
        if (not CrossGambling["channel"]) then
            CrossGambling["channel"] = "gambling"
        end
        if (not CrossGambling["whispers"]) then
            CrossGambling["whispers"] = false
        end
        if (not CrossGambling["house"]) then
            CrossGambling["house"] = 0
        end
        if (not CrossGambling["isHouseCut"]) then
            CrossGambling["isHouseCut"] = false
        end
        if (not CrossGambling["bans"]) then
            CrossGambling["bans"] = {}
        end
        if (not CrossGambling["loser"]) then
            CrossGambling["loser"] = false
        end

        CrossGambling_EditBox:SetText("" .. CrossGambling["lastroll"])

        chatmethod = chatmethods[CrossGambling["chat"]]
        CrossGambling_CHAT_Button:SetText(chatmethod)

        if CrossGambling["minimap"] then
            -- show minimap
            CG_MinimapButton:Show()
        else
            CG_MinimapButton:Hide()
        end

        if (CrossGambling["whispers"] == false) then
            whispermethod = false
        else
            CrossGambling_WHISPER_Button:SetText("(Whispers)")
            whispermethod = true
        end
        if (CrossGambling["active"] == 1) then
            CrossGambling_Frame:Show()
        else
            CrossGambling_Frame:Hide()
        end
    end

    -- IF IT'S A RAID MESSAGE... --
    if
        ((event == "CHAT_MSG_RAID_LEADER" or event == "CHAT_MSG_RAID") and AcceptOnes or
            AcceptLoserAmount and CrossGambling["chat"] == 1)
     then
        local msg, _, _, _, name = ... -- name no realm
        CrossGambling_ParseChatMsg(msg, name)
    end

    if
        ((event == "CHAT_MSG_PARTY_LEADER" or event == "CHAT_MSG_PARTY") and AcceptOnes or
            AcceptLoserAmount and CrossGambling["chat"] == 4)
     then
        local msg, _, _, _, name = ... -- name no realm
        CrossGambling_ParseChatMsg(msg, name)
    end

    if
        ((event == "CHAT_MSG_GUILD_LEADER" or event == "CHAT_MSG_GUILD") and AcceptOnes or
            AcceptLoserAmount and CrossGambling["chat"] == 2)
     then
        local msg, name = ... -- name no realm
        CrossGambling_ParseChatMsg(msg, name)
    end

    if event == "CHAT_MSG_CHANNEL" and AcceptOnes or AcceptLoserAmount and CrossGambling["chat"] == 3 then
        local msg, _, _, _, name, _, _, _, channelName = ...
        if channelName == CrossGambling["channel"] then
            CrossGambling_ParseChatMsg(msg, name)
        end
    end

    if (event == "CHAT_MSG_SYSTEM" and AcceptRolls or AcceptLoserAmount) then
        local msg = ...
        CrossGambling_ParseRoll(tostring(msg))
    end
end

function CrossGambling_ResetStats()
    CrossGambling["stats"] = {}
    CrossGambling["house"] = 0
    CrossGambling["statLooser"] = nil
end

function Minimap_Toggle()
    if CrossGambling["minimap"] then
        -- minimap is shown, set to false, and hide
        CrossGambling["minimap"] = false
        CG_MinimapButton:Hide()
    else
        -- minimap is now shown, set to true, and show
        CrossGambling["minimap"] = true
        CG_MinimapButton:Show()
    end
end

function CrossGambling_OnClickCHAT()
    if (CrossGambling["chat"] == nil) then
        CrossGambling["chat"] = 1
    end

    CrossGambling["chat"] = (CrossGambling["chat"] % #chatmethods) + 1

    chatmethod = chatmethods[CrossGambling["chat"]]
    CrossGambling_CHAT_Button:SetText(chatmethod)
end

function CrossGambling_OnClickWHISPERS()
    if (CrossGambling["whispers"] == nil) then
        CrossGambling["whispers"] = false
    end

    CrossGambling["whispers"] = not CrossGambling["whispers"]

    if (CrossGambling["whispers"] == false) then
        CrossGambling_WHISPER_Button:SetText("(No Whispers)")
        whispermethod = false
    else
        CrossGambling_WHISPER_Button:SetText("(Whispers)")
        whispermethod = true
    end
end

function CrossGambling_ChangeChannel(channel)
    CrossGambling["channel"] = channel
end

function CrossGambling_JoinStats(msg)
    local i = string.find(msg, " ")
    if ((not i) or i == -1 or string.find(msg, "[", 1, true) or string.find(msg, "]", 1, true)) then
        ChatFrame1:AddMessage("")
        return
    end
    local mainname = string.sub(msg, 1, i - 1)
    local altname = string.sub(msg, i + 1)
    ChatFrame1:AddMessage(string.format("Joined alt '%s' -> main '%s'", altname, mainname))
    CrossGambling["joinstats"][altname] = mainname
end

function CrossGambling_UnjoinStats(altname)
    if (altname ~= nil and altname ~= "") then
        ChatFrame1:AddMessage(string.format("Unjoined alt '%s' from any other characters", altname))
        CrossGambling["joinstats"][altname] = nil
    else
        local i, e
        for i, e in pairs(CrossGambling["joinstats"]) do
            ChatFrame1:AddMessage(string.format("currently joined: alt '%s' -> main '%s'", i, e))
        end
    end
end

function CrossGambling_OnClickSTATS(full)
    local sortlistname = {}
    local sortlistamount = {}
    local n = 0
    local i, j, k

    full = true

    for i, j in pairs(CrossGambling["stats"]) do
        local name = i
        if (CrossGambling["joinstats"][strlower(i)] ~= nil) then
            name = CrossGambling["joinstats"][strlower(i)]:gsub("^%l", string.upper)
        end
        for k = 0, n do
            if (k == n) then
                sortlistname[n] = name
                sortlistamount[n] = j
                n = n + 1
                break
            elseif (strlower(name) == strlower(sortlistname[k])) then
                sortlistamount[k] = (sortlistamount[k] or 0) + j
                break
            end
        end
    end

    if (n == 0) then
        DEFAULT_CHAT_FRAME:AddMessage("Pas encore de stats !")
        return
    end

    for i = 0, n - 1 do
        for j = i + 1, n - 1 do
            if (sortlistamount[j] > sortlistamount[i]) then
                sortlistamount[i], sortlistamount[j] = sortlistamount[j], sortlistamount[i]
                sortlistname[i], sortlistname[j] = sortlistname[j], sortlistname[i]
            end
        end
    end

    DEFAULT_CHAT_FRAME:AddMessage("--- Stats du jeu des PO ---", chatmethod)

    if full then
        for k = 0, #sortlistamount do
            local sortsign = "a gagné"
            if (sortlistamount[k] < 0) then
                sortsign = "a perdu"
            end
            ChatMsg(
                string.format(L["%d.  %s %s %d total"], k + 1, sortlistname[k], sortsign, math.abs(sortlistamount[k])),
                chatmethod
            )
        end

        if (CrossGambling["house"] > 0) then
            ChatMsg(
                string.format(L["The house has taken %s total."], BreakUpLargeNumbers(CrossGambling["house"])),
                chatmethod
            )
        end
        CrossGambling["statLooser"] = sortlistname[#sortlistname]
        return
    end

    if (CrossGambling["house"] > 0) then
        ChatMsg(
            string.format(L["The house has taken %s total."], BreakUpLargeNumbers(CrossGambling["house"])),
            chatmethod
        )
    end

    local x1 = 3 - 1
    local x2 = n - 3
    if (x1 >= n) then
        x1 = n - 1
    end
    if (x2 <= x1) then
        x2 = x1 + 1
    end

    for i = 0, x1 do
        sortsign = "won"
        if (sortlistamount[i] < 0) then
            sortsign = "a gagné"
        end
        ChatMsg(
            string.format(L["%d.  %s %s %d total"], i + 1, sortlistname[i], sortsign, math.abs(sortlistamount[i])),
            chatmethod
        )
    end

    if (x1 + 1 < x2) then
        ChatMsg("...", chatmethod)
    end

    for i = x2, n - 1 do
        sortsign = "won"
        if (sortlistamount[i] < 0) then
            sortsign = "a perdu"
        end
        ChatMsg(
            string.format(L["%d.  %s %s %d total"], i + 1, sortlistname[i], sortsign, math.abs(sortlistamount[i])),
            chatmethod
        )
    end
end

function CrossGambling_OnClickROLL()
    if (totalrolls > 0 and AcceptRolls == "true") then
        if #CrossGambling.strings ~= 0 then
            CrossGambling_List()
        end
        return
    end
    if (totalrolls > 1) then
        AcceptOnes = false
        AcceptRolls = "true"
        if (tie == 0) then
            ChatMsg(L["Roll now!"])
        end

        if (lowbreak == 1) then
            --ChatMsg(format("%s%d%s", "Low end tiebreaker! Roll 1-", theMax, " now!"));
            ChatMsg(string.format(L["Low end tiebreaker! Roll 1- %s now!"], theMax))
            CrossGambling_List()
        end

        if (highbreak == 1) then
            --ChatMsg(format("%s%d%s", "High end tiebreaker! Roll 1-", theMax, " now!"));
            ChatMsg(string.format(L["High end tiebreaker! Roll 1- %s now!"], theMax))
            CrossGambling_List()
        end

        CrossGambling_EditBox:ClearFocus()
    end

    if (AcceptOnes == "true" and totalrolls < 2) then
        ChatMsg(L["Not enough Players!"])
    end
end

function CrossGambling_OnClickLASTCALL()
    ChatMsg(L["Last Call to join!"])
    CrossGambling_EditBox:ClearFocus()
    CrossGambling_LASTCALL_Button:Disable()
    CrossGambling_ROLL_Button:Enable()
end

function CrossGambling_OnClickACCEPTONES()
    if CrossGambling_EditBox:GetText() ~= "" and CrossGambling_EditBox:GetText() ~= "1" then
        CrossGambling_Reset()
        CrossGambling_ROLL_Button:Disable()
        CrossGambling_LASTCALL_Button:Disable()
        AcceptOnes = true
        AcceptLoserAmount = false
        local fakeroll = ""

        message = L[".:Welcome to CrossGambling:. User's Roll - (%s) - Type 1 to Join (-1 to withdraw)"]
        statLooser = CrossGambling["statLooser"]
        if statLooser ~= nil then
            looserMessage = " et à la fin c'est " .. statLooser .. " qui perd !"
            message = message .. looserMessage
        end
        ChatMsg(string.format(message, BreakUpLargeNumbers(CrossGambling_EditBox:GetText(), fakeroll)))
        CrossGambling["lastroll"] = CrossGambling_EditBox:GetText()
        theMax = tonumber(CrossGambling_EditBox:GetText())
        low = theMax + 1
        tielow = theMax + 1
        CrossGambling_EditBox:ClearFocus()
        CrossGambling_AcceptOnes_Button:SetText("New Game")
        CrossGambling_LASTCALL_Button:Disable()
        CrossGambling_EditBox:ClearFocus()
    else
        message("Please enter a number to roll from.", chatmethod)
    end
end

function CrossGambling_OnClickRoll()
    hash_SlashCmdList[rollCmd](CrossGambling_EditBox:GetText())
end

function CrossGambling_OnClickRoll1()
    ChatMsg("1")
end

CG_Settings = {
    MinimapPos = 75
}

-- ** do not call from the mod's OnLoad, VARIABLES_LOADED or later is fine. **
function CG_MinimapButton_Reposition()
    CG_MinimapButton:SetPoint(
        "TOPLEFT",
        "Minimap",
        "TOPLEFT",
        52 - (80 * cos(CG_Settings.MinimapPos)),
        (80 * sin(CG_Settings.MinimapPos)) - 52
    )
end

function CG_MinimapButton_DraggingFrame_OnUpdate()
    local xpos, ypos = GetCursorPosition()
    local xmin, ymin = Minimap:GetLeft(), Minimap:GetBottom()

    xpos = xmin - xpos / UIParent:GetScale() + 70
    ypos = ypos / UIParent:GetScale() - ymin - 70

    CG_Settings.MinimapPos = math.deg(math.atan2(ypos, xpos))
    CG_MinimapButton_Reposition()
end

function CG_MinimapButton_OnClick()
    DEFAULT_CHAT_FRAME:AddMessage(tostring(arg1) .. " was clicked.")
end

function CrossGambling_Report()
    local goldowed = high - low
    local houseCut = 0

    if (CrossGambling["isHouseCut"]) then
        houseCut = floor(goldowed * (HousePercent / 100))
        goldowed = goldowed - houseCut
        CrossGambling["house"] = (CrossGambling["house"] or 0) + houseCut
    end
    if (goldowed ~= 0) then
        lowname = lowname:gsub("^%l", string.upper)
        highname = highname:gsub("^%l", string.upper)
        specialMessage = GetSpecialMessage(lowname, highname)

        local string3 = string.format(L["%s owes %s %s gold!"], lowname, highname, BreakUpLargeNumbers(goldowed))

        if (CrossGambling["isHouseCut"] and houseCut > 1) then
            string3 =
                string.format(
                L["%s owes %s %s gold and %s gold the guild bank!"],
                lowname,
                highname,
                BreakUpLargeNumbers(goldowed),
                BreakUpLargeNumbers(houseCut)
            )
        end

        if specialMessage ~= nil then
            string3 = string3 .. specialMessage
        end

        CrossGambling["stats"][highname] = (CrossGambling["stats"][highname] or 0) + goldowed
        CrossGambling["stats"][lowname] = (CrossGambling["stats"][lowname] or 0) - goldowed

        ChatMsg(string3)

        if (CrossGambling["loser"]) then
            ChatMsg(string.format(L["%s can now set the next gambling amount by saying !amount x"], lowname))
            AcceptLoserAmount = lowname
        end
    else
        ChatMsg(L["It was a tie! No payouts on this roll!"])
    end
    CrossGambling_Reset()
    CrossGambling_AcceptOnes_Button:SetText("Open Entry")
    CrossGambling_CHAT_Button:Enable()
end

function CrossGambling_Tiebreaker()
    tierolls = 0
    totalrolls = 0
    tie = 1
    if #CrossGambling.lowtie == 1 then
        CrossGambling.lowtie = {}
    end
    if #CrossGambling.hightie == 1 then
        CrossGambling.hightie = {}
    end
    totalrolls = #CrossGambling.lowtie + #CrossGambling.hightie
    tierolls = totalrolls
    if (#CrossGambling.hightie == 0 and #CrossGambling.lowtie == 0) then
        CrossGambling_Report()
    else
        AcceptRolls = "false"
        if #CrossGambling.lowtie > 0 then
            lowbreak = 1
            highbreak = 0
            tielow = theMax + 1
            tiehigh = 0
            CrossGambling.strings = CrossGambling.lowtie
            CrossGambling.lowtie = {}
            CrossGambling_OnClickROLL()
        end
        if #CrossGambling.hightie > 0 and #CrossGambling.strings == 0 then
            lowbreak = 0
            highbreak = 1
            tielow = theMax + 1
            tiehigh = 0
            CrossGambling.strings = CrossGambling.hightie
            CrossGambling.hightie = {}
            CrossGambling_OnClickROLL()
        end
    end
end

function CrossGambling_ParseRoll(temp2)
    local temp1 = strlower(temp2)

    local rollSplitTbl = {strsplit(" ", temp1)}
    local player = rollSplitTbl[L["RollSplitStringIndexesPlayer"]]
    local junk = rollSplitTbl[L["RollSplitStringIndexesJunk"]]
    local roll = rollSplitTbl[L["RollSplitStringIndexesRoll"]]
    local range = rollSplitTbl[L["RollSplitStringIndexesRange"]]

    if junk == L["RollSplitJunkString"] and CrossGambling_Check(player) == 1 then
        minRoll, maxRoll = strsplit("-", range)
        minRoll = tonumber(strsub(minRoll, 2))
        maxRoll = tonumber(strsub(maxRoll, 1, -3))
        roll = tonumber(roll)
        if (maxRoll == theMax and minRoll == 1) then
            if (tie == 0) then
                if (roll == high) then
                    if #CrossGambling.hightie == 0 then
                        CrossGambling_AddTie(highname, CrossGambling.hightie)
                    end
                    CrossGambling_AddTie(player, CrossGambling.hightie)
                end
                if (roll > high) then
                    highname = player
                    highplayername = player
                    if (high == 0) then
                        high = roll
                        if (whispermethod) then
                            ChatMsg(
                                string.format(
                                    "You have the HIGHEST roll so far: %s and you might win a max of %sg",
                                    roll,
                                    (high - 1)
                                ),
                                "WHISPER",
                                GetDefaultLanguage("player"),
                                player
                            )
                        end
                    else
                        high = roll
                        if (whispermethod) then
                            ChatMsg(
                                string.format(
                                    "You have the HIGHEST roll so far: %s and you might win %sg from %s",
                                    roll,
                                    (high - low),
                                    lowplayername
                                ),
                                "WHISPER",
                                GetDefaultLanguage("player"),
                                player
                            )
                            ChatMsg(
                                string.format(
                                    "%s now has the HIGHEST roller so far: %s and you might owe him/her %sg",
                                    player,
                                    roll,
                                    (high - low)
                                ),
                                "WHISPER",
                                GetDefaultLanguage("player"),
                                lowplayername
                            )
                        end
                    end
                    CrossGambling.hightie = {}
                end
                if (roll == low) then
                    if #CrossGambling.lowtie == 0 then
                        CrossGambling_AddTie(lowname, CrossGambling.lowtie)
                    end
                    CrossGambling_AddTie(player, CrossGambling.lowtie)
                end
                if (roll < low) then
                    lowname = player
                    lowplayername = player
                    low = roll
                    if (high ~= low) then
                        if (whispermethod) then
                            ChatMsg(
                                string.format(
                                    "You have the LOWEST roll so far: %s and you might owe %s %sg ",
                                    roll,
                                    highplayername,
                                    (high - low)
                                ),
                                "WHISPER",
                                GetDefaultLanguage("player"),
                                player
                            )
                        end
                    end
                    CrossGambling.lowtie = {}
                end
            else
                if (lowbreak == 1) then
                    if (roll == tielow) then
                        if #CrossGambling.lowtie == 0 then
                            CrossGambling_AddTie(lowname, CrossGambling.lowtie)
                        end
                        CrossGambling_AddTie(player, CrossGambling.lowtie)
                    end
                    if (roll < tielow) then
                        lowname = player
                        tielow = roll
                        CrossGambling.lowtie = {}
                    end
                end
                if (highbreak == 1) then
                    if (roll == tiehigh) then
                        if #CrossGambling.hightie == 0 then
                            CrossGambling_AddTie(highname, CrossGambling.hightie)
                        end
                        CrossGambling_AddTie(player, CrossGambling.hightie)
                    end
                    if (roll > tiehigh) then
                        highname = player
                        tiehigh = roll
                        CrossGambling.hightie = {}
                    end
                end
            end
            CrossGambling_Remove(tostring(player))
            totalentries = totalentries + 1

            if #CrossGambling.strings == 0 then
                if tierolls == 0 then
                    CrossGambling_Report()
                else
                    if totalentries == 2 then
                        CrossGambling_Report()
                    else
                        CrossGambling_Tiebreaker()
                    end
                end
            end
        end
    end
end

function CrossGambling_Check(player)
    for i = 1, #CrossGambling.strings do
        if strlower(CrossGambling.strings[i]) == tostring(player) then
            return 1
        end
    end
    return 0
end

function CrossGambling_List()
    for i = 1, #CrossGambling.strings do
        ChatMsg(
            string.format(L["%s still needs to roll."], tostring(CrossGambling.strings[i]):gsub("^%l", string.upper))
        )
    end
end

function CrossGambling_ListBan()
    local bancnt = 0
    Print("", "", "|cffffff00To ban do /cg ban (Name) or to unban /cg unban (Name) - The Current Bans:")
    for i = 1, #CrossGambling.bans do
        bancnt = 1
        DEFAULT_CHAT_FRAME:AddMessage(strjoin("|cffffff00", "...", tostring(CrossGambling.bans[i])))
    end
    if (bancnt == 0) then
        DEFAULT_CHAT_FRAME:AddMessage("|cffffff00To ban do /cg ban (Name) or to unban /cg unban (Name).")
    end
end

function CrossGambling_ToggleHouse()
    if (CrossGambling["isHouseCut"]) then
        CrossGambling["isHouseCut"] = false
        Print("", "", "|cffffff00Guildbank house cut has been turned off.")
    else
        CrossGambling["isHouseCut"] = true
        Print("", "", "|cffffff00Guildbank house cut has been turned on.")
    end
end

function CrossGambling_ToggleLoser()
    if (CrossGambling["loser"]) then
        CrossGambling["loser"] = false
        Print("", "", "|cffffff00Loser is no longer able to set next gamble amount.")
    else
        CrossGambling["loser"] = true
        Print("", "", "|cffffff00Loser can now set next gamble amount.")
    end
end

function CrossGambling_Add(name)
    local charname, realmname = strsplit("-", name)
    local insname = strlower(charname)
    if (insname ~= nil or insname ~= "") then
        local found = 0
        for i = 1, #CrossGambling.strings do
            if CrossGambling.strings[i] == insname then
                found = 1
            end
        end
        if found == 0 then
            table.insert(CrossGambling.strings, insname)
            totalrolls = totalrolls + 1
        end
    end
end

function CrossGambling_ChkBan(name)
    local charname, realmname = strsplit("-", name)
    local insname = strlower(charname)
    if (insname ~= nil or insname ~= "") then
        for i = 1, #CrossGambling.bans do
            if strlower(CrossGambling.bans[i]) == strlower(insname) then
                return 1
            end
        end
    end
    return 0
end

function CrossGambling_AddBan(name)
    local charname, realmname = strsplit("-", name)
    local insname = strlower(charname)
    if (insname ~= nil or insname ~= "") then
        local banexist = 0
        for i = 1, #CrossGambling.bans do
            if CrossGambling.bans[i] == insname then
                Print("", "", "|cffffff00Unable to add to ban list - user already banned.")
                banexist = 1
            end
        end
        if (banexist == 0) then
            table.insert(CrossGambling.bans, insname)
            Print("", "", "|cffffff00User is now banned!")
            local string3 = strjoin(" ", "", "User Banned from rolling! -> ", insname, "!")
            DEFAULT_CHAT_FRAME:AddMessage(strjoin("|cffffff00", string3))
        end
    else
        Print("", "", "|cffffff00Error: No name provided.")
    end
end

function CrossGambling_RemoveBan(name)
    local charname, realmname = strsplit("-", name)
    local insname = strlower(charname)
    if (insname ~= nil or insname ~= "") then
        for i = 1, #CrossGambling.bans do
            if strlower(CrossGambling.bans[i]) == strlower(insname) then
                table.remove(CrossGambling.bans, i)
                Print("", "", "|cffffff00User removed from ban successfully.")
                return
            end
        end
    else
        Print("", "", "|cffffff00Error: No name provided.")
    end
end

function CrossGambling_AddTie(name, tietable)
    local charname, realmname = strsplit("-", name)
    local insname = strlower(charname)
    if (insname ~= nil or insname ~= "") then
        local found = 0
        for i = 1, #tietable do
            if tietable[i] == insname then
                found = 1
            end
        end
        if found == 0 then
            table.insert(tietable, insname)
            tierolls = tierolls + 1
            totalrolls = totalrolls + 1
        end
    end
end

function CrossGambling_Remove(name)
    local charname, realmname = strsplit("-", name)
    local insname = strlower(charname)
    for i = 1, #CrossGambling.strings do
        if CrossGambling.strings[i] ~= nil then
            if strlower(CrossGambling.strings[i]) == strlower(insname) then
                table.remove(CrossGambling.strings, i)
                totalrolls = totalrolls - 1
            end
        end
    end
end

function CrossGambling_RemoveTie(name, tietable)
    local charname, realmname = strsplit("-", name)
    local insname = strlower(charname)
    for i = 1, #tietable do
        if tietable[i] ~= nil then
            if strlower(tietable[i]) == insname then
                table.remove(tietable, i)
            end
        end
    end
end

function CrossGambling_Reset()
    CrossGambling["strings"] = {}
    CrossGambling["lowtie"] = {}
    CrossGambling["hightie"] = {}
    AcceptOnes = false
    AcceptRolls = "false"
    totalrolls = 0
    theMax = 0
    tierolls = 0
    lowname = ""
    highname = ""
    low = theMax
    high = 0
    tie = 0
    highbreak = 0
    lowbreak = 0
    tiehigh = 0
    tielow = 0
    totalentries = 0
    highplayername = ""
    lowplayername = ""
    CrossGambling_ROLL_Button:Disable()
    CrossGambling_AcceptOnes_Button:Enable()
    CrossGambling_LASTCALL_Button:Disable()
    CrossGambling_CHAT_Button:Enable()
    CrossGambling_AcceptOnes_Button:SetText("Open Entry")
    Print("", "", "|cffffff00GCG has now been reset")
end

function CrossGambling_ResetCmd()
    ChatMsg(".:CrossGambling:. Game has been reset", chatmethod)
end

function CrossGambling_EditBox_OnLoad()
    CrossGambling_EditBox:SetNumeric(true)
    CrossGambling_EditBox:SetAutoFocus(false)
end
