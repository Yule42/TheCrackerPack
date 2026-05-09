Cracker.card_pack_supported = {
    b_red = true,
    b_blue = true,
    b_yellow = true,
    b_green = true,
    b_black = true,
    b_plasma = true,
}
Cracker.card_pack_redeem = {
    b_red = function(self, card)
        SMODS.change_discard_limit(1)
    end,
    b_blue = function(self, card)
        SMODS.change_play_limit(1)
    end,
    b_green = function(self, card)
        G.GAME.modifiers.money_per_discard = G.GAME.modifiers.money_per_discard and G.GAME.modifiers.money_per_discard + 2 or 0
    end,
}
Cracker.card_pack_calculate = {
    b_black = function(self, card, context)
        if context.round_eval and G.GAME.last_blind and G.GAME.last_blind.boss then
            G.E_MANAGER:add_event(Event({
                func = function()
                    add_tag({ key = 'tag_negative' })
                    play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
                    play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                    return true
                end
            }))
        end
    end,
    b_yellow = function(self, card, context)
        if context.round_eval and G.GAME.last_blind and G.GAME.last_blind.boss then
            G.E_MANAGER:add_event(Event({
                func = function()
                    add_tag({ key = 'tag_coupon' })
                    play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
                    play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                    return true
                end
            }))
        end
    end,
}
Cracker.card_pack_localize = {
    b_black = function(self, info_queue, card, vars)
        info_queue[#info_queue + 1] = { key = 'tag_negative', set = 'Tag' }
        return { localize { type = 'name_text', key = 'tag_negative', set = 'Tag' } }
    end,
     b_yellow = function(self, info_queue, card, vars)
        info_queue[#info_queue + 1] = { key = 'tag_coupon', set = 'Tag' }
        return { localize { type = 'name_text', key = 'tag_coupon', set = 'Tag' } }
    end,
}

SMODS.Voucher {
    key = 'card_pack',
    pos = {
        x = 7,
        y = 0
    },
    unlocked = true,
    discovered = true,
    atlas = 'Vouchers',
    loc_vars = function(self, info_queue, card)
        local vars = {}
        if G.GAME.selected_back_key and Cracker.card_pack_localize[G.GAME.selected_back_key.key] then
            vars = Cracker.card_pack_localize[G.GAME.selected_back_key.key](self, info_queue, card, vars)
        end
        return {vars = vars, key = G.GAME.selected_back_key and Cracker.card_pack_supported[G.GAME.selected_back_key.key] and 'v_cracker_card_pack_'..G.GAME.selected_back_key.key or 'v_cracker_card_pack'}
    end,
    in_pool = function(self, args)
        return G.GAME.selected_back_key and Cracker.card_pack_supported[G.GAME.selected_back_key.key]
    end,
    redeem = function(self, card)
        if G.GAME.selected_back_key and Cracker.card_pack_redeem[G.GAME.selected_back_key.key] then
            Cracker.card_pack_redeem[G.GAME.selected_back_key.key](self, card)
        end
    end,
    calculate = function(self, card, context)
        if G.GAME.selected_back_key and Cracker.card_pack_calculate[G.GAME.selected_back_key.key] then
            Cracker.card_pack_calculate[G.GAME.selected_back_key.key](self, card, context)
        end
    end,
}
