SMODS.Back{ -- Golden Deck
    name = "Golden Deck",
    key = "golden",
    
    pos = {
        x = 0,
        y = 0,
    },
    atlas = 'Backs',
    
    loc_vars = function(self, info_queue, center)
        return {vars = {
            localize{type = 'name_text', key = 'v_seed_money', set = 'Voucher'},
            localize{type = 'name_text', key = 'v_cracker_silver_spoon', set = 'Voucher'},
            localize{type = 'name_text', key = 'v_hone', set = 'Voucher'},
        }}
    end,
    config = {
        vouchers = {
            "v_seed_money",
            "v_cracker_silver_spoon",
            "v_hone",
        }
    },
}

SMODS.Back{ -- Window Shopper Deck
    name = "Window Shopper Deck",
    key = "window_shopper",
    
    pos = {
        x = 1,
        y = 0,
    },
    atlas = 'Backs',
    
    loc_vars = function(self, info_queue, center)
        return {vars = {localize{type = 'name_text', key = 'v_directors_cut', set = 'Voucher'}, localize{type = 'name_text', key = 'v_reroll_surplus', set = 'Voucher'}, localize{type = 'name_text', key = 'v_cracker_clowncar', set = 'Voucher'}}}
    end,
    config = {
        vouchers = {
            "v_directors_cut",
            "v_reroll_surplus",
            "v_cracker_clowncar",
        }
    },
}

SMODS.Back{ -- Blitz Deck
    name = "Blitz Deck",
    key = "blitz",
    
    pos = {
        x = 2,
        y = 0,
    },
    atlas = 'Backs',
    
    loc_vars = function(self, info_queue, center)
        return {vars = {}}
    end,
    config = {
    },
    apply = function(self, back)
        G.GAME.modifiers.scaling = (G.GAME.modifiers.scaling or 1) + 1
        G.GAME.win_ante = 6
    end,
}