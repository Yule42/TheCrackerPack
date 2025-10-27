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

SMODS.Back{ -- Consumer Deck
    name = "Consumer Deck",
    key = "consumer",
    
    pos = {
        x = 1,
        y = 0,
    },
    config = {
        requirement = 100,
        current_amount = 100,
        money = 25,
    },
    atlas = 'Backs',
    
    loc_vars = function(self, info_queue, center)
        return {vars = {G.GAME.selected_back.effect.config.money or self.config.money, G.GAME.selected_back.effect.config.requirement or self.config.requirement, G.GAME.selected_back.effect.config.current_amount or self.config.current_amount}}
    end,
    calculate = function(self, back, context)
        if context.money_altered and context.from_shop and context.amount < 0 then
            back.effect.config.current_amount = back.effect.config.current_amount + context.amount
            if back.effect.config.current_amount <= 0 then
                repeat
                    ease_dollars(self.config.money)
                    back.effect.config.current_amount = back.effect.config.current_amount + back.effect.config.requirement
                until back.effect.config.current_amount > 0
            else
                return {
                    message = ''..back.effect.config.current_amount,
                    colour = G.C.FILTER
                }
            end
        end
    end,
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

SMODS.Back{ -- Catalog Deck
    name = "Catalog Deck",
    key = "catalog",
    
    pos = {
        x = 4,
        y = 0,
    },
    atlas = 'Backs',
    
    loc_vars = function(self, info_queue, center)
        return {vars = {}}
    end,
    
    apply = function(self, back)
        G.GAME.modifiers.extra_boosters = (G.GAME.modifiers.extra_boosters or 0) + 1
        G.GAME.modifiers.extra_vouchers = (G.GAME.modifiers.extra_vouchers or 0) + 1
        change_shop_size(-1)
    end
}

SMODS.Back{ -- Patchwork Deck
    name = "Patchwork Deck", 
    key = "patchwork",
    
    pos = {
        x = 3,
        y = 0,
    },
    atlas = 'Backs',
    
    loc_vars = function(self, info_queue, center)
        return {vars = {}}
    end,
    
    apply = function(self, back)
        G.GAME.modifiers.voucher_override = 'patchwork_enabled'
        G.GAME.modifiers.voucher_restock_antes = 2
    end
}
