SMODS.Back{ -- Showdown Deck
    key = "showdown",
    
    pos = {
        x = 5,
        y = 0,
    },
    atlas = 'Backs',
    discovered = true,
    config = {
        unbanned_on_even = {}
    },
    loc_vars = function(self, info_queue, center)
        return {vars = {}}
    end,
    
    apply = function(self, back)
        G.GAME.modifiers.extra_reward = 1
        for k, v in pairs(G.P_BLINDS) do
            if not v.boss or not v.boss.dx then
                if not (k == "bl_small" or k == "bl_large") then
                    G.GAME.banned_keys[k] = true
                end
            elseif G.GAME.round_resets.ante%2 == 1 then
                G.GAME.banned_keys[k] = true
            end
        end
        if G.GAME.round_resets.ante%2 == 1 then
            G.GAME.banned_keys["bl_cracker_major"] = nil
        end
    end,
    calculate = function(self, back, context)
        if context.modify_ante then
            if G.GAME.round_resets.ante%2 == 0 then
                for k, v in pairs(G.P_BLINDS) do
                    if v.boss and v.boss.dx then
                        G.GAME.banned_keys[k] = true
                    end
                end
                G.GAME.banned_keys["bl_cracker_major"] = nil
            else
                for k, v in pairs(G.P_BLINDS) do
                    if v.boss and v.boss.dx then
                        G.GAME.banned_keys[k] = nil
                        local pool = v:in_pool()
                        
                        G.GAME.banned_keys[k] = pool and true or nil
                    end
                end
                G.GAME.banned_keys["bl_cracker_major"] = true
            end
        end
    end,
}

SMODS.Back{ -- Solar Deck
    key = "solar",
    pos = {
        x = 6,
        y = 0,
    },
    atlas = 'Backs',
    discovered = true,
    loc_vars = function(self, info_queue, center)
        return {vars = {}}
    end,
    
    apply = function(self, back)
        G.GAME.hands['High Card'].l_chips = 15
        G.GAME.hands['Pair'].l_chips = 20
        G.GAME.hands['Two Pair'].l_chips = 35
        G.GAME.hands['Two Pair'].l_mult = 2
        G.GAME.hands['Three of a Kind'].l_chips = 35
        G.GAME.hands['Three of a Kind'].l_mult = 3
        G.GAME.hands['Straight'].l_chips = 50
        G.GAME.hands['Straight'].l_mult = 5
        G.GAME.hands['Flush'].l_chips = 30
        G.GAME.hands['Flush'].l_mult = 4
        G.GAME.hands['Full House'].l_chips = 50
        G.GAME.hands['Full House'].l_mult = 5
        G.GAME.hands['Four of a Kind'].l_chips = 50
        G.GAME.hands['Four of a Kind'].l_mult = 6
        G.GAME.hands['Straight Flush'].l_chips = 70
        G.GAME.hands['Straight Flush'].l_mult = 8
        G.GAME.hands['Five of a Kind'].l_chips = 65
        G.GAME.hands['Five of a Kind'].l_mult = 6
        G.GAME.hands['Flush House'].l_chips = 80
        G.GAME.hands['Flush House'].l_mult = 8
        G.GAME.hands['Flush Five'].l_chips = 80
        G.GAME.hands['Flush Five'].l_mult = 6
        if next(SMODS.find_mod('Bunco')) and G.GAME.hands['bunc_Spectrum'] then
            G.GAME.hands['bunc_Spectrum'].l_chips = 30
            G.GAME.hands['bunc_Spectrum'].l_mult = 3
            G.GAME.hands['bunc_Straight Spectrum'].l_chips = 80
            G.GAME.hands['bunc_Straight Spectrum'].l_mult = 8
            G.GAME.hands['bunc_Spectrum House'].l_chips = 75
            G.GAME.hands['bunc_Spectrum House'].l_mult = 8
            G.GAME.hands['bunc_Spectrum Five'].l_chips = 100
            G.GAME.hands['bunc_Spectrum Five'].l_mult = 6
        elseif next(SMODS.find_mod('paperback')) and G.GAME.hands['paperback_Spectrum'] then
            G.GAME.hands['paperback_Spectrum'].l_chips = 30
            G.GAME.hands['paperback_Spectrum'].l_mult = 3
            G.GAME.hands['paperback_Straight Spectrum'].l_chips = 80
            G.GAME.hands['paperback_Straight Spectrum'].l_mult = 8
            G.GAME.hands['paperback_Spectrum House'].l_chips = 75
            G.GAME.hands['paperback_Spectrum House'].l_mult = 8
            G.GAME.hands['paperback_Spectrum Five'].l_chips = 100
            G.GAME.hands['paperback_Spectrum Five'].l_mult = 6
        end
        if next(SMODS.find_mod('allinjest')) and G.GAME.hands['aij_Royal Flush'] then
            G.GAME.hands['aij_Royal Flush'].l_chips = 100
            G.GAME.hands['aij_Royal Flush'].l_mult = 12
        end
    end,
}
