SMODS.Joker{ --Green Card
    name = "Green Card",
    key = "greencard",
    config = {
        extra = {
            money = 2
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
    perishable_compat = false,
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
            chips_add = 10,
        }
    },
    loc_txt = {
        ['name'] = 'Blue Card',
        ['text'] = {
            [1] = 'This Joker gains',
            [2] = '{C:chips}+#2#{} Chips when',
            [3] = '{C:attention}Booster Pack{} is skipped',
            [4] = '{C:inactive}(Currently {C:chips}+#1#{C:inactive} Mult){}',
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