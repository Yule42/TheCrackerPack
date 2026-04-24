SMODS.Voucher {
    key = 'paperback_pw_proud',
    pos = {
        x = 1,
        y = 0
    },
    unlocked = true,
    discovered = true,
    cost = 15,
    in_pool = function(self, args)
        if G.GAME.selected_back.effect.center.key == 'b_cracker_patchwork' then
            return true
        end
    end,
    config = {
        extra = {
        }
    },
    dependencies = 'paperback',
    prefix_config = {
        key = { 
            mod = false
        },
        atlas = false,
    },
    atlas = 'paperback_decks_atlas',
    pools = { DeckVoucher = true },
    no_collection = true,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Deck Voucher', G.C.FILTER, G.C.WHITE)
    end,
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', key = 'patchwork_only'} end
        return {vars = {}}
    end,
    redeem = function(self, card)
        local ranks = {'2','3','4','5','6','7','8','9','10','J','Q','K','A'}
        local suits = {'paperback_Stars', 'paperback_Crowns'}
        for _, suit in ipairs(suits) do
            for _, rank in ipairs(ranks) do
                G.E_MANAGER:add_event(Event({
                    trigger = 'after', delay = 0.05,
                    func = function()
                        local card = SMODS.add_card({set = 'Base', area = G.deck, suit = suit, rank = rank})
                        return true
                    end
                }))
            end
        end
        G.GAME.starting_deck_size = G.GAME.starting_deck_size + 26
    end
}

SMODS.Voucher {
    key = 'paperback_pw_silver',
    pos = {
        x = 2,
        y = 0
    },
    unlocked = true,
    discovered = true,
    cost = 10,
    in_pool = function(self, args)
        if G.GAME.selected_back.effect.center.key == 'b_cracker_patchwork' then
            return true
        end
    end,
    config = {
        extra = {
            voucher = "v_paperback_celtic_cross",
            upgrade_voucher = "v_paperback_soothsay"
        }
    },
    dependencies = 'paperback',
    prefix_config = {
        key = { 
            mod = false
        },
        atlas = false,
    },
    atlas = 'paperback_decks_atlas',
    pools = { DeckVoucher = true },
    no_collection = true,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Deck Voucher', G.C.FILTER, G.C.WHITE)
    end,
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', key = 'patchwork_only'} end
        return {vars = {localize{type = 'name_text', key = 'v_paperback_celtic_cross', set = 'Voucher'}, localize{type = 'name_text', key = 'c_paperback_nine_of_cups', set = 'paperback_minor_arcana'}}}
    end,
    redeem = function(self, card)
        if not G.GAME.used_vouchers[self.config.extra.upgrade_voucher] and not G.GAME.used_vouchers[self.config.extra.voucher] then
            G.E_MANAGER:add_event(Event({
                delay = 0.5,
                func = function()
                    local voucher = G.GAME.used_vouchers[self.config.extra.voucher] and self.config.extra.upgrade_voucher or self.config.extra.voucher
                    local area = G.play
                    local card = create_card("Voucher", area, nil, nil, nil, nil, voucher)
                    card:start_materialize()
                    area:emplace(card)
                    card.cost = 0
                    card.shop_voucher = false
                    card:redeem()
                    G.GAME.current_round.voucher = voucher
                    G.E_MANAGER:add_event(Event({
                        delay = 0,
                        func = function() 
                            card:start_dissolve()
                        return true
                    end}))
                return true
            end}))
        end
        if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = (function()
                        local card = create_card('paperback_minor_arcana',G.consumeables, nil, nil, nil, nil, 'c_paperback_nine_of_cups')
                        card:add_to_deck()
                        G.consumeables:emplace(card)
                        G.GAME.consumeable_buffer = 0
                        card:juice_up(0.5, 0.5)
                    return true
                end)}))
        end
    end
}
