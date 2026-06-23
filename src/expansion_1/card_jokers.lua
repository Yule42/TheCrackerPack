SMODS.Joker{ --Membership Card
    name = "Membership Card",
    key = "membershipcard",
    config = {
        extra = {
            money = 1,
        }
    },
    pos = {
        x = 1,
        y = 2
    },
    attributes = { 'scaling', 'economy', 'sell_value' },
    cost = 4,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = {set='Other',key='d_purchased'}
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'mrkyspices', 'sugariimarii'}, key = 'artist_credits_cracker'} end
        return {vars = {card.ability.extra.money}}
    end,
    
    calculate = function(self, card, context)
        if (context.buying_card or (context.open_booster and G.shop)) and not context.blueprint and not context.buying_self then
            card.ability.extra_value = card.ability.extra_value + card.ability.extra.money
            card:set_cost()
            G.E_MANAGER:add_event(Event({
                func = function() 
                    card_eval_status_text(card, 'extra', nil, nil, nil, {
                        message = localize('k_val_up'),
                        colour = G.C.MONEY,
                        card = card
                    }) 
                    return true
                end}))
        end
    end
}

SMODS.Joker{ --Card Binder
    key = "card_binder",
    config = {
        extra = {
            chips_add = 8,
        }
    },
    pos = {
        x = 2,
        y = 2
    },
    attributes = { 'chips', 'enhancements' },
    cost = 5,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',

    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'GeorgeTheRat', 'sugariimarii'}, key = 'artist_credits_cracker'} end
        local count = 0
        if G.playing_cards then
            for k, v in pairs(G.playing_cards) do
                if next(SMODS.get_enhancements(v)) then
                    count = count + 1
                end
            end
        end
        local chips = count * card.ability.extra.chips_add
        return {vars = {chips, card.ability.extra.chips_add}}
    end,
    
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main and context.scoring_hand then
            local count = 0
            if G.playing_cards then
                for k, v in pairs(G.playing_cards) do
                    if next(SMODS.get_enhancements(v)) then
                        count = count + 1
                    end
                end
            end
            if count > 0 then
                local chips = count * card.ability.extra.chips_add
                return {
                    chips = chips,
                }
            end
        end
    end
}

SMODS.Joker{ --Baserunner
    name = "Baserunner",
    key = "baserunner",
    config = {
        extra = {
            x_mult = 1,
            x_mult_add = 0.5,
            skips_reset = 4,
            skips_done = 0,
        }
    },
    pos = {
        x = 0,
        y = 1
    },
    attributes = { 'xmult', 'scaling', 'reset' },
    cost = 7,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',

    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'sophiedeergirl', 'sophiedeergirl, sugariimarii'}, key = 'artist_credits_cracker'} end
        return {vars = {card.ability.extra.x_mult, card.ability.extra.x_mult_add, card.ability.extra.skips_reset, card.ability.extra.skips_done}}
    end,
    
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.extra.x_mult,
            }
        elseif context.skipping_booster and not context.blueprint then
            card.ability.extra.skips_done = card.ability.extra.skips_done + 1
            if card.ability.extra.skips_done >= card.ability.extra.skips_reset then
                card.ability.extra.x_mult = 1
                card.ability.extra.skips_done = 0
                return {
                    message = localize('k_reset')
                }
            else
                card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_add
                return {
                    message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult } },
                    colour = G.C.RED,
                    delay = 0.45
                }
            end
        end
    end
}

--[[SMODS.Joker{ --Pink Card
    name = "Pink Card",
    key = "pinkcard",
    config = {
        extra = {
            add_hand_size = 1,
            current_add = 0,
        }
    },
    pos = {
        x = 5,
        y = 2
    },
    cost = 6,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',

    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'sugariimarii'}, key = 'concept_credits_cracker'} end
        return {vars = {card.ability.extra.add_hand_size, card.ability.extra.current_add}}
    end,
    add_to_deck = function(self, card, from_debuff)
        G.hand:change_size(card.ability.extra.current_add)
    end,
    
    remove_from_deck = function(self, card, from_debuff)
        G.hand:change_size(-card.ability.extra.current_add)
    end,
    
    calculate = function(self, card, context)
        if context.skipping_booster and not context.blueprint then
            card.ability.extra.current_add = card.ability.extra.current_add + card.ability.extra.add_hand_size
            G.hand:change_size(card.ability.extra.add_hand_size)
            G.E_MANAGER:add_event(Event({
                    func = function()
                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            message = localize{type = 'variable', key = 'a_handsize', vars = {card.ability.extra.add_hand_size}},
                            colour = G.C.FILTER,
                            delay = 0.45, 
                            card = card
                        })
                        return true
                    end}))
        elseif context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            G.hand:change_size(-card.ability.extra.current_add)
            card.ability.extra.current_add = 0
            return {
                message = localize('k_reset'),
                colour = G.C.FILTER,
                card = card,
            }
        end
    end
}]]

SMODS.Joker{ --Goodie Bag
    name = "Goodie Bag",
    key = "goodie_bag",
    config = {
        extra = {
        }
    },
    pos = {
        x = 6,
        y = 2
    },
    attributes = { 'generation' },
    cost = 6,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',

    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'gfsg', 'sophiedeergirl'}, key = 'artist_credits_cracker'} end
        return {}
    end,
    
    calculate = function(self, card, context)
        if context.skipping_booster then
			local booster_real = context.booster
            if booster_real.create_card and type(booster_real.create_card) == "function" then
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.45,
                    func = (function() -- consumables vs consumeables makes me hate everything
                        local _card = booster_real:create_card(booster_real, 1)
                        message = 'k_plus_cracker_card'
                        color = G.C.FILTER
                        if _card.set == 'Joker' or (G.P_CENTERS[_card.config and _card.config.center.key] and G.P_CENTERS[_card.config and _card.config.center.key].set) == 'Joker' then
                            _card.area = G.jokers
                            message = 'k_plus_joker'
                            color = G.C.BLUE
                        elseif _card.set == 'Base' or _card.set == 'Playing Card' or _card.set == 'Enhanced' then
                            _card.area = G.hand
                        elseif (G.P_CENTERS[_card.config and _card.config.center_key or _card.key] and G.P_CENTERS[_card.config and _card.config.center_key or _card.key].consumeable)
                            or SMODS.ConsumableTypes[_card.set]
                            or (SMODS.ObjectTypes[_card.set] and SMODS.ObjectTypes[_card.set].select_card == "consumeables")
                            or (G.P_CENTERS[_card.config and _card.config.center_key or _card.key] and G.P_CENTERS[_card.config and _card.config.center_key or _card.key].set == 'Consumeables') then
                            _card.area = G.consumeables
                            local death = _card.set or (G.P_CENTERS[_card.config and _card.config.center_key or _card.key].set) or nil
                            if death then
                                local die = string.lower(_card.set or (G.P_CENTERS[_card.config and _card.config.center_key or _card.key].set or ""))
                                if localize('k_plus_'..die) ~= "ERROR" then
                                    message = 'k_plus_'..die
                                end
                                color = G.C.SECONDARY_SET[_card.set] or G.C.FILTER
                            end
                        else
                            return true
                        end
                        if _card.area.config.card_limit and (_card.set ~= 'Base' and _card.set ~= 'Playing Card' and _card.set ~= 'Enhanced') then
                            if #_card.area.cards < _card.area.config.card_limit then
                                if _card.is and _card:is(Card) then
                                    SMODS.add_to_deck(_card)
                                else
                                    SMODS.add_card(_card)
                                end
                                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {
                                    message = localize(message),
                                    colour = color
                                })
                            end
                        else
                            SMODS.add_card(_card)
                            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {
                                message = localize(message),
                                colour = color
                            })
                        end
                        return true
                    end)}))
            end
        end
    end
}

SMODS.Joker{ --Paycheck
    name = "Paycheck",
    key = "paycheck",
    config = {
        extra = {
            dollars = 20,
        }
    },
    pos = {
        x = 7,
        y = 2
    },
    attributes = { 'economy', 'skip' },
    cost = 6,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',

    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'mrkyspices', 'sugariimarii'}, key = 'artist_credits_cracker'} end
        return {vars = {card.ability.extra.dollars}}
    end,
    
    calculate = function(self, card, context)
        if context.skip_blind and not context.blueprint then
            ease_dollars(card.ability.extra.dollars)
            return {
                message = ''..card.ability.extra.dollars,
                colour = G.C.MONEY,
            }
        end
    end
}

SMODS.Joker{ --Darkroom
    name = "Darkroom",
    key = "darkroom",
    config = {
        extra = {
            skips = 0,
            skips_needed = 2,
            skips_needed_base = 2,
        }
    },
    pos = {
        x = 3,
        y = 2
    },
    attributes = { 'generation', 'scaling', 'reset', 'tag' },
    cost = 8,
    rarity = 3,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',

    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'mrkyspices', 'sugariimarii'}, key = 'artist_credits_cracker'} end
        info_queue[#info_queue + 1] = G.P_TAGS.tag_negative
        local negative_count = 0
        if G.jokers then
            for k, v in ipairs(G.jokers.cards) do
                if v and v.edition and v.edition.negative then
                    negative_count = negative_count + 1
                end
            end
        end
        card.ability.extra.skips_needed = card.ability.extra.skips_needed_base + negative_count
        return {vars = {card.ability.extra.skips, card.ability.extra.skips_needed}}
    end,
    
    calculate = function(self, card, context)
        if context.skipping_booster and not context.blueprint then
            card.ability.extra.skips = 0
            G.E_MANAGER:add_event(Event({
                    func = function()
                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            message = localize('k_reset'),
                            colour = G.C.FILTER,
                            delay = 0.45, 
                            card = card
                        })
                        return true
                    end}))
        elseif context.open_booster then
            card.ability.extra.skips = card.ability.extra.skips + 1
            local negative_count = 0
            if G.jokers then
                for k, v in ipairs(G.jokers.cards) do
                    if v and v.edition and v.edition.negative then
                        negative_count = negative_count + 1
                    end
                end
            end
            card.ability.extra.skips_needed = card.ability.extra.skips_needed_base + negative_count
            if card.ability.extra.skips >= card.ability.extra.skips_needed then
                card.ability.extra.skips = 0
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            message = card.ability.extra.skips..'/'..card.ability.extra.skips_needed,
                            colour = G.C.FILTER,
                            delay = 0.45, 
                            card = card
                        })
                        add_tag(Tag('tag_negative'))
                        play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                        play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                        return true
                    end)
                }))
            else 
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            message = card.ability.extra.skips..'/'..card.ability.extra.skips_needed,
                            colour = G.C.FILTER,
                            delay = 0.45, 
                            card = card
                        })
                        return true
                    end}))
            end
        end
    end
}

--[[SMODS.Joker{ --White Card
    name = "White Card",
    key = "whitecard",
    config = {
        extra = {
            solds = 0
        }
    },
    pos = {
        x = 4,
        y = 2
    },
    attributes = { 'generation', 'tarot', 'scaling', 'reset' },
    cost = 8,
    rarity = 3,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',

    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'sophiedeergirl'}, key = 'concept_credits_cracker'} end
        info_queue[#info_queue + 1] = G.P_CENTERS.c_fool
        return {vars = { card.ability.extra.solds }}
    end,
    
    calculate = function(self, card, context)
        if context.ending_shop and not context.blueprint and card.ability.extra.solds then
            for i=1, card.ability.extra.solds do
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
                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})
                end
            end
            card.ability.extra.solds = 0
        elseif context.selling_card and not context.blueprint then
            card.ability.extra.solds = card.ability.extra.solds + 1
            return {
                message = localize('k_upgrade_ex')
            }
        end
    end
}]]

SMODS.Joker{ --Rainbow Card
    name = "Rainbow Card",
    key = "rainbowcard",
    config = {
        extra = {
            retriggers = 1,
            active = true,
        }
    },
    pos = {
        x = 0,
        y = 3
    },
    attributes = { 'retrigger' },
    cost = 9,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',

    loc_vars = function(self, info_queue, card)
        local has_message = (G.GAME and card.area and (card.area == G.jokers))
        info = nil
        if has_message then
            local active = card.ability.extra.active
            info = {
                {n=G.UIT.C, config={align = "bm", minh = 0.4}, nodes={
                    {n=G.UIT.C, config={ref_table = card, align = "m", colour = active and G.C.GREEN or G.C.RED, r = 0.05, padding = 0.06}, nodes={
                        {n=G.UIT.T, config={text = ' '..localize(active and 'k_active' or 'k_cracker_inactive')..' ',colour = G.C.UI.TEXT_LIGHT, scale = 0.32*0.9}},
                    }}
                }}
            }
        end
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'palestjade','sugariimarii'}, key = 'artist_credits_cracker'} end
        return {vars = {card.ability.extra.retriggers}, main_end = info}
    end,
    
    calculate = function(self, card, context)
        if context.round_eval and not card.ability.extra.active and not context.blueprint then
            card.ability.extra.active = true
            return {
                message = localize('k_reset'),
                colour = G.C.FILTER,
                card = card,
            }
        elseif context.open_booster and card.ability.extra.active and G.shop and not context.blueprint then
            card.ability.extra.active = false
            G.E_MANAGER:add_event(Event({
                    func = (function()
                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            message = localize('k_cracker_inactive_ex'),
                            colour = G.C.FILTER,
                            delay = 0.45, 
                            card = card
                        })
                        return true
                    end)
                }))
        elseif context.repetition and (context.cardarea == G.play or (context.cardarea == G.hand and (next(context.card_effects[1]) or #context.card_effects > 1))) and not context.repetition_only and card.ability.extra.active then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retriggers,
            }
        end
    end
}
