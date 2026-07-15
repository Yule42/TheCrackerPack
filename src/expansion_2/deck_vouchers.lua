SMODS.Voucher {
    key = 'pw_red',
    pos = {
        x = 0,
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
    prefix_config = {
        key = { 
            mod = false
        },
        atlas = false,
    },
    atlas = 'centers',
    config = {
        extra = {
            discards = 2,
        }
    },
    pools = { DeckVoucher = true },
    no_collection = true,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Deck Voucher', G.C.FILTER, G.C.WHITE)
    end,
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', key = 'patchwork_only'} end
        return {vars = {card.ability.extra.discards}}
    end,
    
    redeem = function(self)
        G.GAME.round_resets.discards = G.GAME.round_resets.discards + self.config.extra.discards
        ease_discard(self.config.extra.discards)
    end
}

SMODS.Voucher {
    key = 'pw_blue',
    pos = {
        x = 0,
        y = 2
    },
    unlocked = true,
    discovered = true,
    cost = 15,
    in_pool = function(self, args)
        if G.GAME.selected_back.effect.center.key == 'b_cracker_patchwork' then
            return true
        end
    end,
    prefix_config = {
        key = { 
            mod = false
        },
        atlas = false,
    },
    atlas = 'centers',
    config = {
        extra = {
            hands = 2,
        }
    },
    pools = { DeckVoucher = true },
    no_collection = true,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Deck Voucher', G.C.FILTER, G.C.WHITE)
    end,
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', key = 'patchwork_only'} end
        return {vars = {card.ability.extra.hands}}
    end,
    
    redeem = function(self)
        G.GAME.round_resets.hands = G.GAME.round_resets.hands + self.config.extra.hands
        ease_hands_played(self.config.extra.hands)
    end
}

SMODS.Voucher {
    key = 'pw_yellow',
    pos = {
        x = 1,
        y = 2
    },
    unlocked = true,
    discovered = true,
    cost = 20,
    in_pool = function(self, args)
        if G.GAME.selected_back.effect.center.key == 'b_cracker_patchwork' then
            return true
        end
    end,
    prefix_config = {
        key = { 
            mod = false
        },
        atlas = false,
    },
    atlas = 'centers',
    config = {
        extra = {
            currently_active = true,
        }
    },
    pools = { DeckVoucher = true },
    no_collection = true,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Deck Voucher', G.C.FILTER, G.C.WHITE)
    end,
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', key = 'patchwork_only'} end
        return {vars = {card.ability.extra.money}}
    end,
    
    redeem = function(self)
        self.config.extra.currently_active = true
        if G.shop_jokers and G.shop_booster then
            for _, card in pairs(G.shop_jokers.cards) do
                card.ability.couponed = true
                card:set_cost()
            end
            for _, booster in pairs(G.shop_booster.cards) do
                booster.ability.couponed = true
                booster:set_cost()
            end
        end
        if G.shop_vouchers then
            for _, voucher in pairs(G.shop_vouchers.cards) do
                voucher.cost = 0
            end
        end
    end,
    
    calculate = function(self, card, context)
        if context.end_of_round and context.beat_boss then
            self.config.extra.currently_active = false
        elseif self.config.extra.currently_active and (context.starting_shop or context.reroll_shop) then
            if G.shop_jokers and G.shop_booster then
                for _, card in pairs(G.shop_jokers.cards) do
                    card.ability.couponed = true
                    card:set_cost()
                end
                for _, booster in pairs(G.shop_booster.cards) do
                    booster.ability.couponed = true
                    booster:set_cost()
                end
            end
            if G.shop_vouchers then
                for _, voucher in pairs(G.shop_vouchers.cards) do
                    voucher.cost = 0
                end
            end
            return true
        end
    end,
}

SMODS.Voucher {
    key = 'pw_green',
    pos = {
        x = 2,
        y = 2
    },
    unlocked = true,
    discovered = true,
    cost = 15,
    in_pool = function(self, args)
        if G.GAME.selected_back.effect.center.key == 'b_cracker_patchwork' then
            return true
        end
    end,
    prefix_config = {
        key = { 
            mod = false
        },
        atlas = false,
    },
    atlas = 'centers',
    config = {
        extra = {
            hand_money = 1,
            discard_money = 1,
        }
    },
    pools = { DeckVoucher = true },
    no_collection = true,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Deck Voucher', G.C.FILTER, G.C.WHITE)
    end,
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', key = 'patchwork_only'} end
        return {vars = {card.ability.extra.hand_money, card.ability.extra.discard_money}}
    end,
    
    redeem = function(self)
        G.GAME.modifiers.money_per_hand = (G.GAME.modifiers.money_per_hand or 1) + self.config.extra.hand_money
        G.GAME.modifiers.money_per_discard = (G.GAME.money_per_discard or 0) + self.config.extra.discard_money
    end
}

SMODS.Voucher {
    key = 'pw_black',
    pos = {
        x = 3,
        y = 2
    },
    unlocked = true,
    discovered = true,
    cost = 15,
    in_pool = function(self, args)
        if G.GAME.selected_back.effect.center.key == 'b_cracker_patchwork' then
            return true
        end
    end,
    prefix_config = {
        key = { 
            mod = false
        },
        atlas = false,
    },
    atlas = 'centers',
    config = {
        extra = {
        }
    },
    pools = { DeckVoucher = true },
    no_collection = true,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Deck Voucher', G.C.FILTER, G.C.WHITE)
    end,
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', key = 'patchwork_only'} end
        return {vars = {}}
    end,
    
    redeem = function(self)
        G.E_MANAGER:add_event(Event({func = function()
            if G.jokers then 
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        return true end }))
    end
}

SMODS.Voucher {
    key = 'pw_magic',
    pos = {
        x = 0,
        y = 3
    },
    unlocked = true,
    discovered = true,
    cost = 10,
    in_pool = function(self, args)
        if G.GAME.selected_back.effect.center.key == 'b_cracker_patchwork' then
            return true
        end
    end,
    prefix_config = {
        key = { 
            mod = false
        },
        atlas = false,
    },
    atlas = 'centers',
    config = {
        extra = {
            fools = 2,
            voucher = "v_crystal_ball",
            upgrade_voucher = "v_omen_globe"
        }
    },
    pools = { DeckVoucher = true },
    no_collection = true,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Deck Voucher', G.C.FILTER, G.C.WHITE)
    end,
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', key = 'patchwork_only'} end
        return {vars = {localize{type = 'name_text', key = 'v_crystal_ball', set = 'Voucher'}, card.ability.extra.fools, localize{type = 'name_text', key = 'c_fool', set = 'Tarot'}}}
    end,
    redeem = function(self) -- Voucher multi-redeem code based off Cryptid and Betmma's Vouchers
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
        for i=1, math.min(G.consumeables.config.card_limit, 2) do
            if (#G.consumeables.cards-1) + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = (function()
                            local card = create_card('Tarot',G.consumeables, nil, nil, nil, nil, 'c_fool')
                            card:add_to_deck()
                            G.consumeables:emplace(card)
                            G.GAME.consumeable_buffer = 0
                            card:juice_up(0.5, 0.5)
                        return true
                    end)}))
            end
        end
    end
}

SMODS.Voucher {
    key = 'pw_nebula',
    pos = {
        x = 3,
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
    prefix_config = {
        key = { 
            mod = false
        },
        atlas = false,
    },
    atlas = 'centers',
    config = {
        extra = {
            voucher = "v_telescope",
            upgrade_voucher = "v_observatory",
            consumable_slots = 1
        }
    },
    pools = { DeckVoucher = true },
    no_collection = true,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Deck Voucher', G.C.FILTER, G.C.WHITE)
    end,
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', key = 'patchwork_only'} end
        return {vars = {localize{type = 'name_text', key = 'v_telescope', set = 'Voucher'}, self.config.extra.consumable_slots}}
    end,
    redeem = function(self) -- Voucher multi-redeem code based off Cryptid and Betmma's Vouchers
        G.consumeables.config.card_limit = G.consumeables.config.card_limit + self.config.extra.consumable_slots
        if not G.GAME.used_vouchers[self.config.extra.upgrade_voucher] or not G.GAME.used_vouchers[self.config.extra.voucher] then
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
    end
}

SMODS.Voucher {
    key = 'pw_ghost',
    pos = {
        x = 6,
        y = 2
    },
    unlocked = true,
    discovered = true,
    cost = 15,
    in_pool = function(self, args)
        if G.GAME.selected_back.effect.center.key == 'b_cracker_patchwork' then
            return true
        end
    end,
    prefix_config = {
        key = { 
            mod = false
        },
        atlas = false,
    },
    atlas = 'centers',
    config = {
        extra = {
            spectral_boost = 2,
        }
    },
    pools = { DeckVoucher = true },
    no_collection = true,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Deck Voucher', G.C.FILTER, G.C.WHITE)
    end,
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', key = 'patchwork_only'} end
        return {vars = {localize{type = 'name_text', key = 'c_hex', set = 'Spectral'}}}
    end,
    redeem = function(self)
        if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = (function()
                        local card = create_card('Spectral',G.consumeables, nil, nil, nil, nil, 'c_hex')
                        card:add_to_deck()
                        G.consumeables:emplace(card)
                        G.GAME.consumeable_buffer = 0
                        card:juice_up(0.5, 0.5)
                    return true
                end)}))
        end
        G.GAME.spectral_rate = G.GAME.spectral_rate + self.config.extra.spectral_boost
    end
}

SMODS.Voucher {
    key = 'pw_abandoned',
    pos = {
        x = 3,
        y = 3
    },
    unlocked = true,
    discovered = true,
    cost = 15,
    in_pool = function(self, args)
        if G.GAME.selected_back.effect.center.key == 'b_cracker_patchwork' then
            return true
        end
    end,
    prefix_config = {
        key = { 
            mod = false
        },
        atlas = false,
    },
    atlas = 'centers',
    config = {
        extra = {
        }
    },
    pools = { DeckVoucher = true },
    no_collection = true,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Deck Voucher', G.C.FILTER, G.C.WHITE)
    end,
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', key = 'patchwork_only'} end
        return {vars = {}}
    end,
    redeem = function(self)
        local destroyed_cards = {}
        for i = 1, #G.playing_cards do
            if G.playing_cards[i]:is_face() then
                G.jokers:remove_card(G.playing_cards[i])
                table.insert(destroyed_cards, G.playing_cards[i])
            end
        end
        if #destroyed_cards > 0 then
            for k, v in pairs(destroyed_cards) do
                v:start_dissolve()
            end
            for i = 1, #G.jokers.cards do
                G.jokers.cards[i]:calculate_joker({remove_playing_cards = true, removed = destroyed_cards})
            end
        end
    end
}

SMODS.Voucher {
    key = 'pw_checkered',
    pos = {
        x = 1,
        y = 3
    },
    unlocked = true,
    discovered = true,
    cost = 15,
    in_pool = function(self, args)
        if G.GAME.selected_back.effect.center.key == 'b_cracker_patchwork' then
            return true
        end
    end,
    prefix_config = {
        key = { 
            mod = false
        },
        atlas = false,
    },
    atlas = 'centers',
    config = {
        extra = {
        }
    },
    pools = { DeckVoucher = true },
    no_collection = true,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Deck Voucher', G.C.FILTER, G.C.WHITE)
    end,
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', key = 'patchwork_only'} end
        return {vars = {}}
    end,
    redeem = function(self)
        local destroyed_cards = {}
        for i = 1, #G.playing_cards do
            if G.playing_cards[i]:is_suit('Clubs') then
                G.playing_cards[i]:change_suit('Spades')
            elseif G.playing_cards[i]:is_suit('Diamonds') then
                G.playing_cards[i]:change_suit('Hearts')
            end
        end
    end
}

SMODS.Voucher {
    key = 'pw_zodiac',
    pos = {
        x = 3,
        y = 4
    },
    unlocked = true,
    discovered = true,
    cost = 15,
    in_pool = function(self, args)
        if G.GAME.selected_back.effect.center.key == 'b_cracker_patchwork' then
            return true
        end
    end,
    prefix_config = {
        key = { 
            mod = false
        },
        atlas = false,
    },
    atlas = 'centers',
    config = {
        extra = {
            voucher = { "v_tarot_merchant", "v_planet_merchant", "v_overstock_norm" },
            upgrade_voucher = { "v_tarot_tycoon", "v_planet_tycoon", "v_overstock_plus" },
        }
    },
    pools = { DeckVoucher = true },
    no_collection = true,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Deck Voucher', G.C.FILTER, G.C.WHITE)
    end,
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', key = 'patchwork_only'} end
        return {vars = {localize{type = 'name_text', key = 'v_tarot_merchant', set = 'Voucher'}, localize{type = 'name_text', key = 'v_planet_merchant', set = 'Voucher'}, localize{type = 'name_text', key = 'v_overstock_norm', set = 'Voucher'}}}
    end,
    redeem = function(self) -- Voucher multi-redeem code based off Cryptid and Betmma's Vouchers
        for i = 1, #self.config.extra.voucher do
            if not G.GAME.used_vouchers[self.config.extra.upgrade_voucher[i]] or not G.GAME.used_vouchers[self.config.extra.voucher[i]] then
                G.E_MANAGER:add_event(Event({
                    delay = 0.5,
                    func = function()
                        local voucher = G.GAME.used_vouchers[self.config.extra.voucher[i]] and self.config.extra.upgrade_voucher[i] or self.config.extra.voucher[i]
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
        end
    end
}

SMODS.Voucher {
    key = 'pw_painted',
    pos = {
        x = 4,
        y = 3
    },
    unlocked = true,
    discovered = true,
    cost = 15,
    in_pool = function(self, args)
        if G.GAME.selected_back.effect.center.key == 'b_cracker_patchwork' then
            return true
        end
    end,
    prefix_config = {
        key = { 
            mod = false
        },
        atlas = false,
    },
    atlas = 'centers',
    config = {
        extra = {
            hand_size = 2,
        }
    },
    pools = { DeckVoucher = true },
    no_collection = true,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Deck Voucher', G.C.FILTER, G.C.WHITE)
    end,
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', key = 'patchwork_only'} end
        return {vars = {card.ability.extra.hand_size}}
    end,
    
    redeem = function(self)
        G.hand:change_size(self.config.extra.hand_size)
    end
}

SMODS.Voucher {
    key = 'pw_anaglyph',
    pos = {
        x = 2,
        y = 4
    },
    unlocked = true,
    discovered = true,
    cost = 15,
    in_pool = function(self, args)
        if G.GAME.selected_back.effect.center.key == 'b_cracker_patchwork' then
            return true
        end
    end,
    prefix_config = {
        key = { 
            mod = false
        },
        atlas = false,
    },
    atlas = 'centers',
    config = {
        extra = {
        }
    },
    pools = { DeckVoucher = true },
    no_collection = true,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Deck Voucher', G.C.FILTER, G.C.WHITE)
    end,
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', key = 'patchwork_only'} end
        return {vars = {localize{type = 'name_text', key = 'tag_double', set = 'Tag'}}}
    end,
    
    calc_dollar_bonus = function(self, card)
        if G.GAME.last_blind and G.GAME.last_blind.boss then
            G.E_MANAGER:add_event(Event({
                func = (function()
                    add_tag(Tag('tag_double'))
                    play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                    play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                    return true
                end)
            }))
        end
    end
}

SMODS.Voucher {
    key = 'pw_plasma',
    pos = {
        x = 4,
        y = 2
    },
    unlocked = true,
    discovered = true,
    cost = 20,
    in_pool = function(self, args)
        if G.GAME.selected_back.effect.center.key == 'b_cracker_patchwork' then
            return true
        end
    end,
    prefix_config = {
        key = { 
            mod = false
        },
        atlas = false,
    },
    atlas = 'centers',
    config = {
        extra = {
        }
    },
    pools = { DeckVoucher = true },
    no_collection = true,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Deck Voucher', G.C.FILTER, G.C.WHITE)
    end,
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', key = 'patchwork_only'} end
        return {vars = {}}
    end,
    
    redeem = function(self)
        --G.GAME.starting_params.ante_scaling = G.GAME.starting_params.ante_scaling + 1
    end,
}

SMODS.Voucher {
    key = 'pw_erratic',
    pos = {
        x = 2,
        y = 3
    },
    unlocked = true,
    discovered = true,
    cost = 15,
    in_pool = function(self, args)
        if G.GAME.selected_back.effect.center.key == 'b_cracker_patchwork' then
            return true
        end
    end,
    prefix_config = {
        key = { 
            mod = false
        },
        atlas = false,
    },
    atlas = 'centers',
    config = {
        extra = {
            vouchers = 3
        }
    },
    pools = { DeckVoucher = true },
    no_collection = true,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Deck Voucher', G.C.FILTER, G.C.WHITE)
    end,
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', key = 'patchwork_only'} end
        return {vars = {card.ability.extra.vouchers}}
    end,
    
    redeem = function(self) -- Voucher multi-redeem code based off Cryptid and Betmma's Vouchers
        G.GAME.modifiers.voucher_override = false
        local usable_vouchers = {}
        for _, v in ipairs(G.vouchers.cards) do
            local can_use = true
            local center = G.P_CENTERS[v.config.center.key]
            if center.requires and not center.requires == 'patchwork_enabled' then
                for _, vv in pairs(center.requires) do
                    if vv == v.config.center.key then
                        can_use = false
                        break
                    end
                end
            end
            if can_use then
                usable_vouchers[#usable_vouchers + 1] = v
            end
        end
        local unredeemed_vouchers = {}
        unredeemed_vouchers[1] = pseudorandom_element(usable_vouchers, pseudoseed("pw_erratic"))
        for i, v in ipairs(usable_vouchers) do
            if v == unredeemed_vouchers[1] then
                table.remove(usable_vouchers, i)
                break
            end
        end
        unredeemed_vouchers[2] = pseudorandom_element(usable_vouchers, pseudoseed("pw_erratic"))
        for i, v in ipairs(usable_vouchers) do
            if v == unredeemed_vouchers[2] then
                table.remove(usable_vouchers, i)
                break
            end
        end
        unredeemed_vouchers[3] = pseudorandom_element(usable_vouchers, pseudoseed("pw_erratic"))
        for i=1, 3 do
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
                            if i == 2 then
                                G.GAME.modifiers.voucher_override = 'patchwork_enabled'
                            end
                        return true
                    end}))
                return true
            end}))
        end
    end
}

SMODS.Voucher {
    key = 'pw_golden',
    pos = {
        x = 0,
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
    atlas = 'Backs',
    config = {
        requirement = 2,
        current_amount = 2,
    },
    pools = { DeckVoucher = true },
    no_collection = true,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Deck Voucher', G.C.FILTER, G.C.WHITE)
    end,
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', key = 'patchwork_only'} end
        return {vars = {self.config.requirement, self.config.current_amount}}
    end,
    calculate = function(self, card, context)
        if context.skip_blind then
            self.config.current_amount = self.config.current_amount - 1
            if self.config.current_amount <= 0 then
                self.config.current_amount = self.config.requirement
                G.GAME.no_saved = true
                return { func = function()
                    G.E_MANAGER:add_event(Event {
                        trigger = "after",
                        blocking = false,
                        func = function()
                            G.E_MANAGER:add_event(Event {
                            trigger = "after",
                            blocking = false,
                            func = function()
                                if G.STATE ~= G.STATES.SMODS_BOOSTER_OPENED then
                                G.GAME.current_round.reroll_cost = G.GAME.round_resets.reroll_cost
                                G.GAME.current_round.reroll_cost_increase = 0
                                G.STATE = G.STATES.SHOP
                                G.STATE_COMPLETE = false
                                G.GAME.no_saved = nil
                                return true
                            end
                        end})
                        if G.blind_select then
                            G.blind_select.alignment.offset.y = G.blind_select.alignment.offset.y + G.blind_select.T.h
                            G.E_MANAGER:add_event(Event{
                            trigger = "after",
                            delay = 0.3,
                            func = function()
                                G.blind_select:remove()
                                G.blind_prompt_box:remove()
                                return true
                            end})
                        end
                        return true
                    end})
                end}
            else
                return {
                    message = ''..self.config.current_amount,
                    colour = G.C.FILTER,
                    delay = 0.5
                }
            end
        end
    end
}

SMODS.Voucher {
    key = 'pw_rebate',
    pos = {
        x = 1,
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
    atlas = 'Backs',
    config = {
        requirement = 25,
        current_amount = 0,
        active = true
    },
    pools = { DeckVoucher = true },
    no_collection = true,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Deck Voucher', G.C.FILTER, G.C.WHITE)
    end,
    
    loc_vars = function(self, info_queue, center)
        return {vars = {self.config.requirement, self.config.current_amount}}
    end,
    redeem = function(self, card)
        self.config.current_amount = self.config.current_amount + math.max(0, self.cost)
    end,
    calculate = function(self, card, context)
        if context.money_altered and context.amount < 0 and self.config.active then
            self.config.current_amount = self.config.current_amount - context.amount
            if self.config.current_amount >= self.config.requirement then
                self.config.current_amount = self.config.requirement
                if context.from_shop then
                    self.config.active = false
                    return Cracker.spawn_mega_pack(self)
                end
            else
                return {
                    message = ''..self.config.current_amount,
                    colour = G.C.FILTER,
                    delay = 0.5
                }
            end
        elseif context.starting_shop and self.config.current_amount >= self.config.requirement and self.config.active then
            self.config.active = false
            return Cracker.spawn_mega_pack()
        elseif context.end_of_round and context.beat_boss and context.game_over == false and context.main_eval then
            self.config.active = true
            self.config.current_amount = 0
            return {
                message = localize('k_reset'),
                colour = G.C.RED
            }
        end
    end,
}

SMODS.Voucher {
    key = 'pw_blitz',
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
    atlas = 'Backs',
    config = {
        extra = {
        }
    },
    pools = { DeckVoucher = true },
    no_collection = true,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Deck Voucher', G.C.FILTER, G.C.WHITE)
    end,
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', key = 'patchwork_only'} end
        return {vars = {}}
    end,
    redeem = function(self)
        G.GAME.win_ante = G.GAME.win_ante - 1
    end
}

SMODS.Voucher {
    key = 'pw_catalog',
    pos = {
        x = 4,
        y = 0
    },
    unlocked = true,
    discovered = true,
    cost = 20,
    in_pool = function(self, args)
        if G.GAME.selected_back.effect.center.key == 'b_cracker_patchwork' then
            return true
        end
    end,
    atlas = 'Backs',
    config = {
        extra = {
            voucher = { "v_overstock_norm" },
            upgrade_voucher = { "v_overstock_plus" },
        }
    },
    pools = { DeckVoucher = true },
    no_collection = true,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Deck Voucher', G.C.FILTER, G.C.WHITE)
    end,
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', key = 'patchwork_only'} end
        return {vars = {localize{type = 'name_text', key = 'v_overstock_norm', set = 'Voucher'}}}
    end,
    redeem = function(self)
        SMODS.change_voucher_limit(1)
        for i = 1, #self.config.extra.voucher do
            if not G.GAME.used_vouchers[self.config.extra.upgrade_voucher[i]] or not G.GAME.used_vouchers[self.config.extra.voucher[i]] then
                G.E_MANAGER:add_event(Event({
                    delay = 0.5,
                    func = function()
                        local voucher = G.GAME.used_vouchers[self.config.extra.voucher[i]] and self.config.extra.upgrade_voucher[i] or self.config.extra.voucher[i]
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
        end
    end
}

-- yes, i know showdown isn't here i have an idea for it but it'd be a lot to implement for now

SMODS.Voucher {
    key = 'pw_catalog',
    pos = {
        x = 6,
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
    atlas = 'Backs',
    config = {},
    pools = { DeckVoucher = true },
    no_collection = true,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Deck Voucher', G.C.FILTER, G.C.WHITE)
    end,
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', key = 'patchwork_only'} end
        return {vars = {}}
    end,
    redeem = function(self)
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
    end
}
