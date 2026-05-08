Cracker.card_pack_supported = {
    b_red = true,
    b_blue = true,
    b_plasma = true,
}
Cracker.card_pack_redeem = {
    b_red = function(self, card)
        SMODS.change_discard_limit(1)
    end,
    b_blue = function(self, card)
        SMODS.change_play_limit(1)
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
        return {vars = {}, key = G.GAME.selected_back_key and Cracker.card_pack_supported[G.GAME.selected_back_key.key] and 'v_cracker_card_pack_'..G.GAME.selected_back_key.key or 'v_cracker_card_pack'}
    end,
    in_pool = function(self, args)
        return Cracker.card_pack_supported[G.GAME.selected_back_key.key]
    end,
    redeem = function(self, card)
        if Cracker.card_pack_redeem[G.GAME.selected_back_key.key] then
            Cracker.card_pack_redeem[G.GAME.selected_back_key.key](self, card)
        end
    end,
}
