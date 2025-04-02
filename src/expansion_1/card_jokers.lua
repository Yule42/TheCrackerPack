SMODS.Joker{ --Green Card
    name = "Green Card",
    key = "greencard",
    config = {
        extra = {
            money = 2,
        }
    },
    loc_txt = {
        ['name'] = 'Green Card',
        ['text'] = {
            [1] = 'This Joker gains',
            [2] = '{C:money}$#1#{} of {C:attention}sell value{} when',
            [3] = '{C:attention}Booster Pack{} is skipped',
        }
    },
    pos = {
        x = 1,
        y = 2
    },
    cost = 6,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.money}}
    end,
    
    calculate = function(self, card, context)
        if context.skipping_booster and not context.blueprint then
            card.ability.extra_value = card.ability.extra_value + card.ability.extra.money
            card:set_cost()
            G.E_MANAGER:add_event(Event({
                func = function() 
                    card_eval_status_text(card, 'extra', nil, nil, nil, {
                        message = localize('k_val_up'),
                        colour = G.C.MONEY,
                        delay = 0.45, 
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
            chips = 0,
            chips_add = 20,
        }
    },
    loc_txt = {
        ['name'] = 'Blue Card',
        ['text'] = {
            [1] = 'This Joker gains',
            [2] = '{C:chips}+#2#{} Chips when',
            [3] = '{C:attention}Booster Pack{} is skipped',
            [4] = '{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips){}',
        }
    },
    pos = {
        x = 2,
        y = 2
    },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.chips, card.ability.extra.chips_add}}
    end,
    
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main and context.scoring_hand and card.ability.extra.chips > 1 then
            return {
                message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
                chip_mod = card.ability.extra.chips,
                colour = G.C.CHIPS
            }
        elseif context.skipping_booster and not context.blueprint then
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_add
            G.E_MANAGER:add_event(Event({
                func = function() 
                    card_eval_status_text(card, 'extra', nil, nil, nil, {
                        message = localize{type = 'variable', key = 'a_chips', vars = {card.ability.extra.chips_add}},
                        colour = G.C.CHIPS,
                        delay = 0.45, 
                        card = card
                    }) 
                    return true
                end}))
        end
    end
}

SMODS.Joker{ --Violet Card
    name = "Violet Card",
    key = "violetcard",
    config = {
        extra = {
            xmult = 1,
            xmult_add = 0.15,
        }
    },
    loc_txt = {
        ['name'] = 'Violet Card',
        ['text'] = {
            [1] = 'This Joker gains',
            [2] = '{X:mult,C:white}X#2#{} Mult when any',
            [3] = '{C:attention}Booster Pack{} is skipped',
            [4] = '{C:inactive}(Currently {X:mult,C:white} X#1#{C:inactive} Mult){}',
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
        return {vars = {card.ability.extra.xmult, card.ability.extra.xmult_add}}
    end,
    
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main and context.scoring_hand and card.ability.extra.xmult > 1 then
            return {
                message = localize{type='variable',key='a_xmult',vars={card.ability.extra.xmult}},
                Xmult_mod = card.ability.extra.xmult,
                colour = G.C.RED
            }
        elseif context.skipping_booster and not context.blueprint then
            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_add
            G.E_MANAGER:add_event(Event({
                func = function() 
                    card_eval_status_text(card, 'extra', nil, nil, nil, {
                        message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.xmult_add}},
                        colour = G.C.RED,
                        delay = 0.45, 
                        card = card
                    }) 
                    return true
                end}))
        end
    end
}

SMODS.Joker{ --Indigo Card
    name = "Indigo Card",
    key = "indigocard",
    config = {
        extra = {
            odds = 2,
        }
    },
    loc_txt = {
        ['name'] = 'Indigo Card',
        ['text'] = {
            [1] = '{C:green}#1# in #2#{} chance to upgrade level of',
            [2] = '{C:attention}most played poker hand',
            [3] = 'when {C:attention}Booster Pack{} is skipped',
        }
    },
    pos = {
        x = 9,
        y = 2
    },
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {''..(G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.odds}}
    end,
    
    calculate = function(self, card, context)
        if context.skipping_booster and pseudorandom('indigo') < G.GAME.probabilities.normal/card.ability.extra.odds then
            local hand = Cracker.mostplayedhand()
            update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(hand, 'poker_hands'), chips = G.GAME.hands[hand].chips, mult = G.GAME.hands[hand].mult, level=G.GAME.hands[hand].level})
            level_up_hand(card, hand)
            update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
        end
    end
}

SMODS.Joker{ --Pink Card
    name = "Pink Card",
    key = "pinkcard",
    config = {
        extra = {
            add_hand_size = 1,
            current_add = 0,
        }
    },
    loc_txt = {
        ['name'] = 'Pink Card',
        ['text'] = {
            [1] = 'This Joker gains {C:attention}+#1#{} hand size',
            [2] = 'when {C:attention}Booster Pack{} is skipped',
            [3] = '{C:inactive}(Currently {C:attention}+#2#{C:inactive} hand size)',
            [4] = '{s:0.8}Resets at end of round',
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
}

SMODS.Joker{ --Orange Card
    name = "Orange Card",
    key = "orangecard",
    config = {
        extra = {
            booster = nil
        }
    },
    loc_txt = {
        ['name'] = 'Orange Card',
        ['text'] = {
            [1] = 'When {C:attention}Booster Pack{} is skipped,',
            [2] = 'creates a random card',
            [3] = 'from {C:attention}type of pack skipped{}',
            [4] = '{C:inactive}(Must have room)',
        }
    },
    pos = {
        x = 6,
        y = 2
    },
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',

    loc_vars = function(self, info_queue, card)
        return {}
    end,
    
    calculate = function(self, card, context)
        if context.open_booster then
            card.ability.extra.booster = context.card
        elseif context.skipping_booster then
            if card.ability.extra.booster.ability.name:find("Buffoon") and #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
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
            elseif card.ability.extra.booster.ability.name:find("Standard") then
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.45,
                    func = (function()
                            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {
                                message = '+1 Card',
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
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                local consum_names = { "Arcana", "Celestial", "Spectral" }
                local short_names = { "tarot", "planet", "spectral" }
                local short_names_why_is_there_a_seperate_shorthand = { "Tarot", "Planet", "Spectral" }
                for i = 1, #consum_names do
                    if card.ability.extra.booster.ability.name:find(consum_names[i]) then
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

SMODS.Joker{ --Yellow Card
    name = "Yellow Card",
    key = "yellowcard",
    config = {
        extra = {
            dollars_gain = 1,
            dollars = 0,
        }
    },
    loc_txt = {
        ['name'] = 'Yellow Card',
        ['text'] = {
            [1] = 'Earn {C:money}$#2#{} at end of round',
            [2] = 'Payout increased by {C:money}$#1#{}',
            [3] = 'when {C:attention}Booster Pack{} is skipped',
        }
    },
    pos = {
        x = 7,
        y = 2
    },
    cost = 8,
    rarity = 3,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.dollars_gain, card.ability.extra.dollars}}
    end,
    
    calc_dollar_bonus = function(self, card)
        local bonus = card.ability.extra.dollars
        if bonus > 0 then return bonus end
    end,
    
    calculate = function(self, card, context)
        if context.skipping_booster and not context.blueprint then
            card.ability.extra.dollars = card.ability.extra.dollars + card.ability.extra.dollars_gain
            G.E_MANAGER:add_event(Event({
                    func = function()
                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            message = localize('k_upgrade_ex'),
                            colour = G.C.FILTER,
                            delay = 0.45, 
                            card = card
                        })
                        return true
                    end}))
        end
    end
}

SMODS.Joker{ --Black Card
    name = "Black Card",
    key = "blackcard",
    config = {
        extra = {
            skips = 0,
            skips_needed = 3,
        }
    },
    loc_txt = {
        ['name'] = 'Black Card',
        ['text'] = {
            [1] = 'Create a {C:spectral}Negative Tag{}',
            [2] = 'every {C:attention}#2#{} Booster Packs skipped',
            [3] = '{C:inactive}(Currently {C:attention}#1#{C:inactive}/3){}',
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
        return {vars = {card.ability.extra.skips, card.ability.extra.skips_needed}}
    end,
    
    calculate = function(self, card, context)
        if context.skipping_booster and not context.blueprint then
            card.ability.extra.skips = card.ability.extra.skips + 1
            if card.ability.extra.skips >= card.ability.extra.skips_needed then
                card.ability.extra.skips = 0
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
        }
    },
    loc_txt = {
        ['name'] = 'White Card',
        ['text'] = {
            [1] = 'Creates {C:tarot}The Fool{}',
            [2] = 'when {C:attention}Booster Pack{} is skipped',
            [3] = '{C:inactive}(Must have room)',
        }
    },
    pos = {
        x = 4,
        y = 2
    },
    cost = 8,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {}}
    end,
    
    calculate = function(self, card, context)
        if context.skipping_booster and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = (function()
                        local card = create_card('Tarot',G.consumeables, nil, nil, nil, nil, 'c_fool')
                        card:add_to_deck()
                        G.consumeables:emplace(card)
                        G.GAME.consumeable_buffer = 0
                    return true
                end)}))
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})
        end
    end
}

SMODS.Joker{ --Rainbow Card
    name = "Rainbow Card",
    key = "rainbowcard",
    config = {
        extra = {
            retriggers = 0,
            retriggers_increase = 1,
        }
    },
    loc_txt = {
        ['name'] = 'Rainbow Card',
        ['text'] = {
            [1] = 'Retrigger all played cards {C:attention}#1#{} times',
            [2] = 'Increases by {C:attention}#2#{} when {C:attention}Booster Pack{} is skipped',
            [3] = '{s:0.8}Resets at end of round',
        }
    },
    pos = {
        x = 0,
        y = 3
    },
    cost = 8,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.retriggers, card.ability.extra.retriggers_increase}}
    end,
    
    calculate = function(self, card, context)
        if context.skipping_booster and not context.blueprint then
            card.ability.extra.retriggers = card.ability.extra.retriggers + card.ability.extra.retriggers_increase
            G.E_MANAGER:add_event(Event({
                    func = function()
                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            message = localize('k_upgrade_ex'),
                            colour = G.C.FILTER,
                            delay = 0.45, 
                            card = card
                        })
                        return true
                    end}))
        elseif context.cardarea == G.play and context.repetition and not context.repetition_only then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retriggers,
            }
        elseif context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.retriggers = 0
            return {
                message = localize('k_reset'),
                colour = G.C.FILTER,
                card = card,
            }
        end
    end
}