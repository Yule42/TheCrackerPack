Cracker.card_pack_supported = {
    b_plasma = true,
}
Cracker.card_pack_apply = {
    b_plasma = function(self, back)
        
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
    apply = function(self, back)
        Cracker.card_pack_apply(self, back)
    end,
}
