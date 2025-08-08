SMODS.Voucher {
    key = 'pw_red',
    pos = {
        x = 0,
        y = 0
    },
    unlocked = true,
    discovered = true,
    cost = 10,
    atlas = 'pw_vouchers',
    config = {
        extra = {
            discards = 1,
        }
    },
    patchwork = true,
    loc_vars = function(self, info_queue, card)
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
        x = 1,
        y = 0
    },
    unlocked = true,
    discovered = true,
    cost = 10,
    atlas = 'pw_vouchers',
    config = {
        extra = {
            hands = 1,
        }
    },
    patchwork = true,
    loc_vars = function(self, info_queue, card)
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
        x = 2,
        y = 0
    },
    unlocked = true,
    discovered = true,
    cost = 10,
    atlas = 'pw_vouchers',
    config = {
        extra = {
            money = 20,
        }
    },
    patchwork = true,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.money}}
    end,
    
    redeem = function(self)
        ease_dollars(self.config.extra.money)
    end
}

SMODS.Voucher {
    key = 'pw_green',
    pos = {
        x = 3,
        y = 0
    },
    unlocked = true,
    discovered = true,
    cost = 15,
    atlas = 'pw_vouchers',
    config = {
        extra = {
            hand_money = 1,
            discard_money = 1,
        }
    },
    patchwork = true,
    loc_vars = function(self, info_queue, card)
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
        x = 4,
        y = 0
    },
    unlocked = true,
    discovered = true,
    cost = 15,
    atlas = 'pw_vouchers',
    config = {
        extra = {
        }
    },
    patchwork = true,
    loc_vars = function(self, info_queue, card)
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
        x = 5,
        y = 0
    },
    unlocked = true,
    discovered = true,
    cost = 15,
    atlas = 'pw_vouchers',
    config = {
        extra = {
            fools = 2,
            voucher = "v_crystal_ball",
            upgrade_voucher = "v_omen_globe"
        }
    },
    patchwork = true,
    loc_vars = function(self, info_queue, card)
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
            if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
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
        x = 6,
        y = 0
    },
    unlocked = true,
    discovered = true,
    cost = 10,
    atlas = 'pw_vouchers',
    config = {
        extra = {
            voucher = "v_telescope",
            upgrade_voucher = "v_observatory"
        }
    },
    patchwork = true,
    loc_vars = function(self, info_queue, card)
        return {vars = {localize{type = 'name_text', key = 'v_telescope', set = 'Voucher'}}}
    end,
    redeem = function(self) -- Voucher multi-redeem code based off Cryptid and Betmma's Vouchers
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
        x = 7,
        y = 0
    },
    unlocked = true,
    discovered = true,
    cost = 15,
    atlas = 'pw_vouchers',
    config = {
        extra = {
            spectral_boost = 2,
        }
    },
    patchwork = true,
    loc_vars = function(self, info_queue, card)
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
        x = 8,
        y = 0
    },
    unlocked = true,
    discovered = true,
    cost = 15,
    atlas = 'pw_vouchers',
    config = {
        extra = {
        }
    },
    patchwork = true,
    loc_vars = function(self, info_queue, card)
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
        x = 9,
        y = 0
    },
    unlocked = true,
    discovered = true,
    cost = 15,
    atlas = 'pw_vouchers',
    config = {
        extra = {
        }
    },
    patchwork = true,
    loc_vars = function(self, info_queue, card)
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
        x = 0,
        y = 1
    },
    unlocked = true,
    discovered = true,
    cost = 15,
    atlas = 'pw_vouchers',
    config = {
        extra = {
            voucher = { "v_tarot_merchant", "v_planet_merchant", "v_overstock_norm" },
            upgrade_voucher = { "v_tarot_tycoon", "v_planet_tycoon", "v_overstock_plus" },
        }
    },
    patchwork = true,
    loc_vars = function(self, info_queue, card)
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
        x = 1,
        y = 1
    },
    unlocked = true,
    discovered = true,
    cost = 15,
    atlas = 'pw_vouchers',
    config = {
        extra = {
            hand_size = 2,
        }
    },
    patchwork = true,
    loc_vars = function(self, info_queue, card)
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
        y = 1
    },
    unlocked = true,
    discovered = true,
    cost = 15,
    atlas = 'pw_vouchers',
    config = {
        extra = {
        }
    },
    patchwork = true,
    loc_vars = function(self, info_queue, card)
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
        x = 3,
        y = 1
    },
    unlocked = true,
    discovered = true,
    cost = 20,
    atlas = 'pw_vouchers',
    config = {
        extra = {
        }
    },
    patchwork = true,
    loc_vars = function(self, info_queue, card)
        return {vars = {}}
    end,
    
    redeem = function(self)
        --G.GAME.starting_params.ante_scaling = G.GAME.starting_params.ante_scaling + 1
    end,
}

SMODS.Voucher {
    key = 'pw_erratic',
    pos = {
        x = 4,
        y = 1
    },
    unlocked = true,
    discovered = true,
    cost = 15,
    atlas = 'pw_vouchers',
    config = {
        extra = {
            vouchers = 2
        }
    },
    patchwork = true,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.vouchers}}
    end,
    
    redeem = function(self) -- Voucher multi-redeem code based off Cryptid and Betmma's Vouchers
        G.GAME.modifiers.voucher_override = false
        local usable_vouchers = {}
        for k, v in ipairs(G.vouchers.cards) do
            local can_use = true
            for kk, vv in ipairs(G.vouchers.cards) do
                local center = G.P_CENTERS[vv.config.center.key]
                if center.requires and not center.requires == 'patchwork_enabled' then
                    for _, vvv in pairs(center.requires) do
                        if vvv == v.config.center.key then
                            can_use = false
                            break
                        end
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
        for i=1, 2 do
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
        x = 5,
        y = 1
    },
    unlocked = true,
    discovered = true,
    cost = 15,
    atlas = 'pw_vouchers',
    config = {
        extra = {
            voucher = { "v_seed_money", "v_cracker_silver_spoon", "v_hone" },
            upgrade_voucher = { "v_money_tree", "v_cracker_heirloom", "v_glow_up" },
        }
    },
    patchwork = true,
    loc_vars = function(self, info_queue, card)
        return {vars = {localize{type = 'name_text', key = 'v_seed_money', set = 'Voucher'}, localize{type = 'name_text', key = 'v_cracker_silver_spoon', set = 'Voucher'}, localize{type = 'name_text', key = 'v_hone', set = 'Voucher'}}}
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
    key = 'pw_consumer',
    pos = {
        x = 6,
        y = 1
    },
    unlocked = true,
    discovered = true,
    cost = 15,
    atlas = 'pw_vouchers',
    config = {
        extra = {
            voucher = { "v_directors_cut", "v_reroll_surplus", "v_cracker_clowncar" },
            upgrade_voucher = { "v_retcon", "v_reroll_glut", "v_cracker_busfullofclowns" },
        }
    },
    patchwork = true,
    loc_vars = function(self, info_queue, card)
        return {vars = {localize{type = 'name_text', key = 'v_directors_cut', set = 'Voucher'}, localize{type = 'name_text', key = 'v_reroll_surplus', set = 'Voucher'}, localize{type = 'name_text', key = 'v_cracker_clowncar', set = 'Voucher'}}}
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
    key = 'pw_blitz',
    pos = {
        x = 7,
        y = 1
    },
    unlocked = true,
    discovered = true,
    cost = 20,
    atlas = 'pw_vouchers',
    config = {
        extra = {
        }
    },
    patchwork = true,
    loc_vars = function(self, info_queue, card)
        return {vars = {}}
    end,
    redeem = function(self)
        G.GAME.win_ante = G.GAME.win_ante - 1
        ease_ante(-1)
    end
}

SMODS.Voucher {
    key = 'pw_catalog',
    pos = {
        x = 8,
        y = 1
    },
    unlocked = true,
    discovered = true,
    cost = 20,
    atlas = 'pw_vouchers',
    config = {
        extra = {
        }
    },
    patchwork = true,
    loc_vars = function(self, info_queue, card)
        return {vars = {}}
    end,
    redeem = function(self)
        G.GAME.modifiers.extra_boosters = (G.GAME.modifiers.extra_boosters or 0) + 1
        G.GAME.modifiers.extra_vouchers = (G.GAME.modifiers.extra_vouchers or 0) + 1
    end
}