local _, CrossGambling = ...
CrossGambling.L = {}
--[[Translation missing --]]
do
    local locale = GetLocale()
    if locale == "enUS" or locale == "enGB" then
        CrossGambling.L["RollSplitStringIndexesPlayer"] = 1;
        CrossGambling.L["RollSplitStringIndexesJunk"] = 2;
        CrossGambling.L["RollSplitStringIndexesRoll"] = 3;
        CrossGambling.L["RollSplitStringIndexesRange"] = 4;
        CrossGambling.L["RollSplitJunkString"] = "rolls";
        CrossGambling.L["%s owes %s %s gold!"] = "%s owes %s %s gold!";
        CrossGambling.L["%s owes %s %s gold and %s gold the guild bank!"] = "%s owes %s %s gold and %s gold the guild bank!";
        CrossGambling.L["%s can now set the next gambling amount by saying !amount x"] = "%s can now set the next gambling amount by saying !amount x";
        CrossGambling.L["It was a tie! No payouts on this roll!"] = "It was a tie! No payouts on this roll!";
        CrossGambling.L[".:Welcome to CrossGambling:. User's Roll - (%s) - Type 1 to Join (-1 to withdraw)"] = ".:Welcome to CrossGambling:. User's Roll - (%s) - Type 1 to Join (-1 to withdraw)"
        CrossGambling.L["Last Call to join!"] = "Last Call to join!";
        CrossGambling.L["%s still needs to roll."] = "%s still needs to roll.";
        CrossGambling.L["Roll now!"] = "Roll now!";
        CrossGambling.L["Not enough Players!"] = "Not enough Players!";
        CrossGambling.L["High end tiebreaker! Roll 1- %s now!"] = "High end tiebreaker! Roll 1- %s now!";
        CrossGambling.L["Low end tiebreaker! Roll 1- %s now!"] = "Low end tiebreaker! Roll 1- %s now!";
        CrossGambling.L["%d.  %s %s %d total"] = "%d.  %s won %d total";
        CrossGambling.L["%d.  %s %s %d total"] = "%d.  %s lost %d total";
        CrossGambling.L["The house has taken %s total."] = "The house has taken %s total.";
    elseif locale == "deDE" then
        CrossGambling.L = CrossGambling.L or {}
        CrossGambling.L["RollSplitStringIndexesPlayer"] = 1;
        CrossGambling.L["RollSplitStringIndexesJunk"] = 2;
        CrossGambling.L["RollSplitStringIndexesRoll"] = 4;
        CrossGambling.L["RollSplitStringIndexesRange"] = 5;
        CrossGambling.L["RollSplitJunkString"] = "würfelt.";
        CrossGambling.L["%s owes %s %s gold!"] = "%s schuldet %s %s gold!";
        CrossGambling.L["%s owes %s %s gold and %s gold the guild bank!"] = "%s schuldet %s %s gold und %s Gold der Gildenbank!";
        CrossGambling.L["%s can now set the next gambling amount by saying !amount x"] = "%s kann nun den Einsatz der nächsten Spielrunde festlegen. - !amount x";
        CrossGambling.L["It was a tie! No payouts on this roll!"] = "Unentschieden! Keine Auszahlungen auf diese Runde!";
        CrossGambling.L[".:Welcome to CrossGambling:. User's Roll - (%s) - Type 1 to Join (-1 to withdraw)"] = ".:Willkommen bei CrossGambling:. Nutzer würfeln - (%s) - Tippe 1 zum Teilnehmen (-1 um nicht mehr Teilzunehmen.)"
        CrossGambling.L["Last Call to join!"] = "Letzte Chance, um teilzunehmen!";
        CrossGambling.L["%s still needs to roll."] = "%s muss noch würfeln.";
        CrossGambling.L["Roll now!"] = "Jetzt würfeln!";
        CrossGambling.L["Not enough Players!"] = "Nicht genug Teilnehmer!";
        CrossGambling.L["High end tiebreaker! Roll 1- %s now!"] = "High end tiebreaker! Roll 1- %s now!";
        CrossGambling.L["Low end tiebreaker! Roll 1- %s now!"] = "Low end tiebreaker! Roll 1- %s now!";
        CrossGambling.L["%d.  %s %s %d total"] = "%d.  %s hat insgesamt %d Gold gewonnen.";
        CrossGambling.L["%d.  %s %s %d total"] = "%d.  %s hat insgesamt %d Gold verloren.";
        CrossGambling.L["The house has taken %s total."] = "Das Haus hat insgesamt %s Gold bekommen.";
    elseif locale == "frFR" then
        CrossGambling.L["RollSplitStringIndexesPlayer"] = 1;
        CrossGambling.L["RollSplitStringIndexesJunk"] = 2;
        CrossGambling.L["RollSplitStringIndexesRoll"] = 4;
        CrossGambling.L["RollSplitStringIndexesRange"] = 5;
        CrossGambling.L["RollSplitJunkString"] = "obtient";
        CrossGambling.L["%s owes %s %s gold!"] = "%s doit donner à %s %s pièces d'or !";
        CrossGambling.L["%s owes %s %s gold and %s gold the guild bank!"] = "%s doit donner à %s %s pièces d'or et mettre %s pièces d'or dans la banque de guilde !";
        CrossGambling.L["%s can now set the next gambling amount by saying !amount x"] = "%s peut maintenant décider de l'enjeu du prochain pari avec !amount x";
        CrossGambling.L["It was a tie! No payouts on this roll!"] = "C'est une égalité ! Pas de paiement pour ce pari!";
        CrossGambling.L[".:Welcome to CrossGambling:. User's Roll - (%s) - Type 1 to Join (-1 to withdraw)"] = ".:Bienvenue dans le jeu des PO:. Pièces d'or en jeu : (%s) - Tapez 1 pour rejoindre  (-1 pour annuler) et à la fin c'est Spindel qui perd"
        CrossGambling.L["Last Call to join!"] = "== Dernier appel pour jouer ! ==";
        CrossGambling.L["%s still needs to roll."] = "%s doit faire son rand.";
        CrossGambling.L["Roll now!"] = "== C'est parti pour les rands ! ==";
        CrossGambling.L["Not enough Players!"] = "Pas assez de joueurs ! (Bande de faibles)";
        CrossGambling.L["High end tiebreaker! Roll 1- %s now!"] = "High end tiebreaker! Roll 1- %s now!";
        CrossGambling.L["Low end tiebreaker! Roll 1- %s now!"] = "Low end tiebreaker! Roll 1- %s now!";
        CrossGambling.L["%d.  %s %s %d total"] = "%d.  %s %s %d au total";
        CrossGambling.L["The house has taken %s total."] = "La maison a gagné %s au total.";
    else
        error("Unknown locale: "..tostring(locale))
    end

    --local HAS_STRINGS = next(CrossGambling.L) and true or false
    setmetatable(CrossGambling.L, {
        __index = function(t, k)
            --assert(not HAS_STRINGS)
            local v = tostring(k)
            rawset(t, k, v)
            return v
        end,
        __newindex = function(t, k, v)
            error("Cannot write to the locale table")
        end,
    })
end