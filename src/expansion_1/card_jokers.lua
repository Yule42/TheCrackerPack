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
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'mrkyspices', 'sugariimari'}, key = 'artist_credits_cracker'} end
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

SMODS.Joker{ --Blue Card
    name = "Blue Card",
    key = "bluecard",
    config = {
        extra = {
            chips_add = 8,
        }
    },
    pos = {
        x = 2,
        y = 2
    },
    cost = 5,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',

    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'sugariimari'}, key = 'concept_credits_cracker'} end
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

SMODS.Joker{ --Violet Card
    name = "Violet Card",
    key = "violetcard",
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
    cost = 7,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',

    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'sugariimari'}, key = 'concept_credits_cracker'} end
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
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'sugariimari'}, key = 'concept_credits_cracker'} end
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

SMODS.Joker{ --Orange Card
    name = "Orange Card",
    key = "orangecard",
    config = {
        extra = {
        }
    },
    pos = {
        x = 6,
        y = 2
    },
    cost = 6,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',

    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'sophiedeergirl'}, key = 'concept_credits_cracker'} end
        return {}
    end,
    
    calculate = function(self, card, context)
        if context.skipping_booster then
			local booster = context.booster.kind
            if booster:find("Buffoon") and #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
                G.GAME.joker_buffer = G.GAME.joker_buffer + 1
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.45,
                    func = (function()
                            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {
                                message = localize('k_plus_joker'),
                                colour = G.C.BLUE
                            })
                            local card = create_card('Joker', G.jokers, nil, nil, nil, nil, nil, 'orangecard')
                            card:add_to_deck()
                            G.jokers:emplace(card)
                            G.GAME.joker_buffer = 0
                        return true
                    end)}))
            elseif booster:find("Standard") then
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.45,
                    func = (function()
                            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {
                                message = localize{type = 'variable', key = 'a_cracker_card', vars = {1}},
                                colour = G.FILTER
                            })
                            G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                            local cardd = create_card((pseudorandom(pseudoseed('orangecard'..G.GAME.round_resets.ante)) > 0.6) and "Enhanced" or "Base", G.pack_cards, nil, nil, nil, true, nil, 'orangecard')
                            local edition_rate = 2
                            local edition = poll_edition('orangecard'..G.GAME.round_resets.ante, edition_rate, true)
                            cardd:set_edition(edition)
                            local seal_rate = 10
                            local seal_poll = pseudorandom(pseudoseed('orangecard'..G.GAME.round_resets.ante))
                            if seal_poll > 1 - 0.02*seal_rate then
                                local seal_type = pseudorandom(pseudoseed('orangecard'..G.GAME.round_resets.ante))
                                if seal_type > 0.75 then cardd:set_seal('Red')
                                elseif seal_type > 0.5 then cardd:set_seal('Blue')
                                elseif seal_type > 0.25 then cardd:set_seal('Gold')
                                else cardd:set_seal('Purple')
                                end
                            end
                            G.deck.config.card_limit = G.deck.config.card_limit + 1
                            G.play:emplace(cardd)
                            playing_card_joker_effects({true})
                            cardd:add_to_deck()
                            table.insert(G.playing_cards, cardd)
                            draw_card(G.play,G.deck, 90,'up', nil)
                        return true
                    end)}))
            elseif #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                local consum_names = { "Arcana", "Celestial", "Spectral" }
                local short_names = { "tarot", "planet", "spectral" }
                local short_names_why_is_there_a_seperate_shorthand = { "Tarot", "Planet", "Spectral" }
                for i = 1, #consum_names do
                    if booster:find(consum_names[i]) then
                        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                        G.E_MANAGER:add_event(Event({
                            trigger = 'before',
                            delay = 0.45,
                            func = (function()
                                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {
                                        message = localize('k_plus_'..short_names[i]),
                                        colour = G.C.SECONDARY_SET[short_names_why_is_there_a_seperate_shorthand[i]]
                                    })
                                    local card = create_card(short_names_why_is_there_a_seperate_shorthand[i], G.consumeables, nil, nil, nil, nil, nil, 'orangecard')
                                    card:add_to_deck()
                                    G.consumeables:emplace(card)
                                    G.GAME.consumeable_buffer = 0
                                return true
                            end)}))
                    end
                end
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
    cost = 6,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',

    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'mrkyspices', 'sugariimari'}, key = 'artist_credits_cracker'} end
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
    cost = 8,
    rarity = 3,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',

    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'mrkyspices', 'sugariimari'}, key = 'artist_credits_cracker'} end
        info_queue[#info_queue + 1] = G.P_TAGS.tag_negative
        local negative_count = 0
        if G.jokers then
            for k, v in ipairs(G.jokers.cards) do
                if v and v.edition and v.edition.negative then
                    negative_count = negative_count + 1
                end
            end
        end
        return {vars = {card.ability.extra.skips, card.ability.extra.skips_needed_base + negative_count}}
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
            if card.ability.extra.skips >= card.ability.extra.skips_needed then
                local negative_count = 0
                if G.jokers then
                    for k, v in ipairs(G.jokers.cards) do
                        if v and v.edition and v.edition.negative then
                            negative_count = negative_count + 1
                        end
                    end
                end
                card.ability.extra.skips = 0
                card.ability.extra.skips_needed = card.ability.extra.skips_needed_base + negative_count
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            message = card.ability.extra.skips_needed..'/'..card.ability.extra.skips_needed,
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

SMODS.Joker{ --White Card
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
}

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
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'palestjade','sugariimari'}, key = 'artist_credits_cracker'} end
        return {vars = {card.ability.extra.retriggers}, main_end = info}
    end,
    
    calculate = function(self, card, context)
        if context.end_of_round and not context.repetition and not context.individual and not context.blueprint then
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
