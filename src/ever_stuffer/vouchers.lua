Cracker.card_pack_supported = {
    b_red = true,
    b_blue = true,
    b_yellow = true,
    b_green = true,
    b_black = true,
    b_plasma = true,
}
Cracker.card_pack_erratic_compatible = {
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
    end
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
            return nil, true
        end
    end,
    b_yellow = function(self, card, context)
        if context.modify_final_cashout then
            return {
                modify = math.floor(context.amount/3),
                cashout_row = {name = 'custom', text = localize('k_cracker_card_pack_yellow'), text_colour = G.C.GOLD}
            }
        end
    end,
}
Cracker.card_pack_localize = {
    b_black = function(self, info_queue, card, vars)
        return { 1, 2 }
    end,
    b_yellow = function(self, info_queue, card, vars)
        return { 3, 1 }
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
    config = {
        extra = {
            back = nil
        }
    },
    loc_vars = function(self, info_queue, card)
        local vars = {}
        if not G.GAME.Cracker.current_card_pack then
            G.GAME.Cracker.current_card_pack = G.GAME.selected_back_key and G.GAME.selected_back_key.key
        end
        if G.GAME.Cracker.current_card_pack and Cracker.card_pack_localize[G.GAME.Cracker.current_card_pack] then
            vars = Cracker.card_pack_localize[G.GAME.Cracker.current_card_pack](self, info_queue, card, vars)
        end
        return {vars = vars, key = G.GAME.Cracker.current_card_pack and Cracker.card_pack_supported[G.GAME.Cracker.current_card_pack] and 'v_cracker_card_pack_'..G.GAME.Cracker.current_card_pack or 'v_cracker_card_pack'}
    end,
    in_pool = function(self, args)
        return G.GAME.selected_back_key and Cracker.card_pack_supported[G.GAME.selected_back_key.key]
    end,
    redeem = function(self, card)
        if not G.GAME.Cracker.current_card_pack then
            G.GAME.Cracker.current_card_pack = G.GAME.selected_back_key and G.GAME.selected_back_key.key
        end
        if G.GAME.Cracker.current_card_pack and Cracker.card_pack_redeem[G.GAME.Cracker.current_card_pack] then
            Cracker.card_pack_redeem[G.GAME.Cracker.current_card_pack](self, card)
        end
    end,
    calculate = function(self, card, context)
        if G.GAME.Cracker.current_card_pack and Cracker.card_pack_calculate[G.GAME.Cracker.current_card_pack] then
            return Cracker.card_pack_calculate[G.GAME.Cracker.current_card_pack](self, card, context)
        end
    end,
}
