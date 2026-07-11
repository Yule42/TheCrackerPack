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
        local hand_values = {
            ["High Card"]      = {chips = 15},
            ["Pair"]           = {chips = 20},
            ["Two Pair"]       = {chips = 35, mult = 2},
            ["Three of a Kind"]= {chips = 35, mult = 3},
            ["Straight"]       = {chips = 50, mult = 5},
            ["Flush"]          = {chips = 25, mult = 4},
            ["Full House"]     = {chips = 50, mult = 5},
            ["Four of a Kind"] = {chips = 50, mult = 6},
            ["Straight Flush"] = {chips = 70, mult = 8},
            ["Five of a Kind"] = {chips = 65, mult = 6},
            ["Flush House"]    = {chips = 80, mult = 8},
            ["Flush Five"]     = {chips = 80, mult = 6},
        }
        local spec_name
        if next(SMODS.find_mod('Bunco')) and G.GAME.hands['bunc_Spectrum'] then
            spec_name = "bunc"
        elseif next(SMODS.find_mod('paperback')) and G.GAME.hands['paperback_Spectrum'] then
            spec_name = "paperback"
        end
        if spec_name then
            hand_values[spec_name .. "_Spectrum"] = {chips = 30, mult = 3}
            hand_values[spec_name .. "_Straight Spectrum"] = {chips = 80, mult = 8}
            hand_values[spec_name .. "_Spectrum House"] = {chips = 75, mult = 8}
            hand_values[spec_name .. "_Spectrum Five"] = {chips = 100, mult = 6}
        end
        if next(SMODS.find_mod('allinjest')) and G.GAME.hands['aij_Royal Flush'] then
            hand_values["aij_Royal Flush"] = {chips = 100, mult = 12}
        end
        if next(SMODS.find_mod('artbox')) and G.GAME.hands['artb_null'] then
            hand_values["artb_null"] = {chips = 45, mult = 6}
        end
        --[[if next(SMODS.find_mod('Maximus')) and G.GAME.hands['mxms_f_three_pair'] then -- i'll finish this later
            hand_values["mxms_three_pair"] = {chips = 40, mult = 1}
            hand_values["mxms_double_triple"] = {chips = 70, mult = 5}
            hand_values["mxms_6oak"] = {chips = 70, mult = 7}
            hand_values["mxms_s_straight"] = {chips = 80, mult = 5}
            hand_values["mxms_s_flush"] = {chips = 35, mult = 5}
            hand_values["mxms_house_party"] = {chips = 75, mult = 6}
            hand_values["mxms_f_three_pair"] = {chips = 35, mult = 5}
            hand_values["mxms_f_double_triple"] = {chips = 100, mult = 9}
        end]]
        for hand, values in pairs(hand_values) do
            if G.GAME.hands[hand] then
                if values.chips then G.GAME.hands[hand].l_chips = values.chips end
                if values.mult then G.GAME.hands[hand].l_mult = values.mult end
            end
        end
    end,
}
