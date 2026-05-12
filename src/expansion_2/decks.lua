SMODS.Back{ -- Golden Deck
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
    apply = function(self, back)
        G.GAME.modifiers.reduced_reward = 2
        G.GAME.modifiers.money_tags_only = true
        G.GAME.Cracker = G.GAME.Cracker or {}
        G.GAME.Cracker.tags_in_shop = 4
    end,
}

SMODS.Tag:take_ownership('skip', -- make skip tag appear properly in the shop on Golden Deck
    {
        loc_vars = function(self, info_queue, tag)
            return { vars = { tag.config.skip_bonus, tag.config.skip_bonus * ((G.GAME.skips or 0) + (Cracker.tag_is_in_shop(tag) and 0 or 1)) } }
        end,
    },
    true
)

SMODS.Back{ -- Rebate Deck
    key = "rebate",
    
    pos = {
        x = 1,
        y = 0,
    },
    config = {
        requirement = 30,
        current_amount = 30,
    },
    atlas = 'Backs',
    
    loc_vars = function(self, info_queue, center)
        return {vars = {G.GAME.selected_back.effect.config.requirement or self.config.requirement, G.GAME.selected_back.effect.config.current_amount or self.config.current_amount}}
    end,
    calculate = function(self, back, context)
        if context.money_altered and context.from_shop and context.amount < 0 then
            back.effect.config.current_amount = back.effect.config.current_amount + context.amount
            if back.effect.config.current_amount <= 0 then
                repeat
                    local center = get_pack('rebate_deck')
                    local count = 0
                    local found = nil
                    
                    while count <= 1000 and not found do
                        if not center.name:find('Jumbo') or center.name:find('Mega') then
                            center = get_pack('rebate_deck')
                        else
                            found = true
                        end
                        count = count + 1
                    end
                    local i = #G.GAME.current_round.used_packs + 1
                    local booster = Card(G.shop_booster.T.x + G.shop_booster.T.w/2, G.shop_booster.T.y, G.CARD_W*1.27, G.CARD_H*1.27, G.P_CARDS.empty, center, { bypass_discovery_center = true, bypass_discovery_ui = true })
                    create_shop_card_ui(booster, 'Booster', G.shop_booster)
                    G.GAME.current_round.used_packs[i] = center.key
                    booster.ability.booster_pos = i
                    booster:start_materialize()
                    G.shop_booster:emplace(booster)
                    booster.ability.couponed = true
                    booster:set_cost()
                    back.effect.config.current_amount = back.effect.config.current_amount + back.effect.config.requirement
                until back.effect.config.current_amount > 0
                return {
                    message = localize('k_cracker_rebate'),
                    colour = G.C.FILTER
                }
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
