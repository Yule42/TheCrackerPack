SMODS.Joker{ --Saltine Cracker
    name = "Saltine Cracker",
    key = "saltinecracker",
    config = {
        extra = {
            chips = 50,
            chip_mod = 10,
            max_chips = 100
        }
    },
    loc_txt = {
        ['name'] = 'Saltine Cracker',
        ['text'] = {
            [1] = '{C:chips}+#1#{} Chips',
            [2] = 'Gains {C:chips}+#2#{} Chips',
            [3] = 'after each round',
            [4] = '{S:1.1,C:red,E:2}Self destructs{} after',
            [5] = 'reaching {C:chips}#3#{} Chips'
        }
    },
    pos = {
        x = 0,
        y = 0
    },
    cost = 5,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.chips, card.ability.extra.chip_mod * G.GAME.food_multiplier, card.ability.extra.max_chips}}
    end,

    calculate = function(self, card, context)
        if context.end_of_round and context.cardarea == G.jokers and not context.blueprint and not context.repetition and not context.individual then
            if card.ability.extra.chips + card.ability.extra.chip_mod >= card.ability.extra.max_chips then 
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                            func = function()
                                    G.jokers:remove_card(card)
                                    card:remove()
                                    card = nil
                                return true; end})) 
                        return true
                    end
                })) 
                return {
                    message = "Crumbled!",
                    colour = G.C.CHIPS
                }
            else
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod * G.GAME.food_multiplier
                return {
                    message = localize{type='variable',key='a_chips',vars={card.ability.extra.chip_mod * G.GAME.food_multiplier}},
                    colour = G.C.CHIPS
                }
            end
        
        elseif context.cardarea == G.jokers and context.joker_main and context.scoring_hand and card.ability.extra.chips > 0 then
            return {
                message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
                chip_mod = card.ability.extra.chips, 
                colour = G.C.CHIPS
            }
        end
    end
}

SMODS.Joker{ --Chocolate Coin
    name = "Chocolate Coin",
    key = "chocolatecoin",
    config = {
        extra = {
            money = 3,
            rounds = 5,
            rounds_mod = 1
        }
    },
    loc_txt = {
        ['name'] = 'Chocolate Coin',
        ['text'] = {
            [1] = 'Earn {C:attention}$#1#{} at',
            [2] = 'end of round',
            [3] = 'for the next',
            [4] = '{C:attention}#2#{} rounds'
        }
    },
    pos = {
        x = 1,
        y = 0
    },
    cost = 3,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.money, card.ability.extra.rounds}}
    end,
    
    calc_dollar_bonus = function(self, card)
        local bonus = card.ability.extra.money
        if card.ability.extra.rounds <= 0 then
            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound('tarot1')
                    card.T.r = -0.2
                    card:juice_up(0.3, 0.4)
                    card.states.drag.is = true
                    card.children.center.pinch.x = true
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                        func = function()
                                G.jokers:remove_card(card)
                                card:remove()
                                card = nil
                            return true; end})) 
                    return true
                end
            }))
        end
        if bonus > 0 then return bonus end
    end,
    
    calculate = function(self, card, context)
        if context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
            card.ability.extra.rounds = card.ability.extra.rounds - (card.ability.extra.rounds_mod * G.GAME.food_multiplier)
            if card.ability.extra.rounds <= 0 then
                return {
                    message = localize('k_eaten_ex'),
                    colour = G.C.FILTER
                }
            else
                return {
                    message = tostring(card.ability.extra.rounds),
                    colour = G.C.FILTER
                }
            end
        end
    end
}

SMODS.Joker{ --Graham Cracker
    name = "Graham Cracker",
    key = "grahamcracker",
    config = {
        extra = {
            xmult_add = 1,
            cards_require = 20,
            cards_left = 20,
            xmult_current = 1,
            xmult_max = 6
        }
    },
    loc_txt = {
        ['name'] = 'Graham Cracker',
        ['text'] = {
            [1] = 'This Joker gains {X:mult,C:white} X#1# {} Mult',
            [2] = 'every {C:attention}#2#{C:inactive} [#3#]{} cards played',
            [3] = '{S:1.1,C:red,E:2}Self destructs{} after',
            [4] = 'reaching {X:mult,C:white} X#5# {} Mult',
            [5] = '{C:inactive}(Currently {X:mult,C:white} X#4#{C:inactive} Mult)'
        }
    },
    pos = {
        x = 2,
        y = 0
    },
    cost = 7,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xmult_add * G.GAME.food_multiplier, card.ability.extra.cards_require, card.ability.extra.cards_left, card.ability.extra.xmult_current, card.ability.extra.xmult_max}}
    end,
    
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main and context.scoring_hand and card.ability.extra.xmult_current > 1 then
            return {
                message = localize{type='variable',key='a_xmult',vars={card.ability.extra.xmult_current}},
                Xmult_mod = card.ability.extra.xmult_current,
                colour = G.C.RED
            }
        elseif context.before and context.cardarea == G.jokers and not context.blueprint then
            card.ability.extra.cards_left = card.ability.extra.cards_left - (table_length(context.scoring_hand))
            if card.ability.extra.cards_left <= 0 then
                card.ability.extra.cards_left = card.ability.extra.cards_require
                if card.ability.extra.xmult_current + (card.ability.extra.xmult_add * G.GAME.food_multiplier) >= card.ability.extra.xmult_max then 
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            play_sound('tarot1')
                            card.T.r = -0.2
                            card:juice_up(0.3, 0.4)
                            card.states.drag.is = true
                            card.children.center.pinch.x = true
                            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                                func = function()
                                        G.jokers:remove_card(card)
                                        card:remove()
                                        card = nil
                                    return true; end})) 
                            return true
                        end
                    })) 
                    return {
                        message = "Crumbled!",
                        colour = G.C.RED
                    }
                else
                    card.ability.extra.xmult_current = card.ability.extra.xmult_current + card.ability.extra.xmult_add * G.GAME.food_multiplier
                    return {
                        card = card,
                        focus = card,
                        message = localize{type='variable',key='a_xmult',vars={card.ability.extra.xmult_current * G.GAME.food_multiplier}},
                        colour = G.C.RED
                    }
                end
            end
        end
    end
}

SMODS.Joker{ --Hoarder
    name = "Hoarder",
    key = "hoarder",
    config = {
        extra = {
            vouchers_multiply = 6,
        }
    },
    loc_txt = {
        ['name'] = 'Hoarder',
        ['text'] = {
            [1] = '{C:red}+#1#{} Mult per {C:voucher}Voucher{}',
            [2] = 'purchased this run',
            [3] = '{C:inactive}(Currently {C:red}+#2#{C:inactive} Mult)',
        }
    },
    pos = {
        x = 4,
        y = 0
    },
    cost = 5,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.vouchers_multiply, (table_length(G.GAME.used_vouchers) * card.ability.extra.vouchers_multiply)}}
    end,
    
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main and context.scoring_hand and table_length(G.GAME.used_vouchers) > 0 then
            return {
                message = localize{type='variable',key='a_mult',vars={((table_length(G.GAME.used_vouchers)) * card.ability.extra.vouchers_multiply)}},
                mult_mod = ((table_length(G.GAME.used_vouchers)) * card.ability.extra.vouchers_multiply),
                colour = G.C.MULT
            }
        end
    end
}

SMODS.Joker{ --Cheese
    name = "Cheese",
    key = "cheese",
    config = {
        extra = {
            xmult = 3,
            xmult_remove = 1,
            xmult_base = 3,
        }
    },
    loc_txt = {
        ['name'] = 'Cheese',
        ['text'] = {
            [1] = '{X:mult,C:white}X#1#{} Mult, decreases by',
            [2] = '{X:mult,C:white}X#2#{} every hand played',
            [3] = '{s:0.8}resets at end of round',
        }
    },
    pos = {
        x = 1,
        y = 1
    },
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xmult, card.ability.extra.xmult_remove * G.GAME.food_multiplier, card.ability.extra.xmult_base}}
    end,
    
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main and context.scoring_hand and card.ability.extra.xmult > 1 then
            return {
                message = localize{type='variable',key='a_xmult',vars={card.ability.extra.xmult}},
                Xmult_mod = card.ability.extra.xmult,
                colour = G.C.RED
            }
        elseif context.after and not context.blueprint and not context.repetition and hand_chips * mult < G.GAME.blind.chips then
            card.ability.extra.xmult = card.ability.extra.xmult - card.ability.extra.xmult_remove * G.GAME.food_multiplier
            if card.ability.extra.xmult <= 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                            func = function()
                                    G.jokers:remove_card(card)
                                    card:remove()
                                    card = nil
                                return true; end})) 
                        return true
                    end
                })) 
                return {
                    message = localize('k_eaten_ex'),
                    colour = G.C.RED
                }
            else
                return {
                    message = localize{type='variable',key='a_xmult_minus',vars={card.ability.extra.xmult_remove * G.GAME.food_multiplier}},
                    colour = G.C.RED
                }
            end
        elseif context.end_of_round and context.cardarea == G.jokers and not context.blueprint and not context.repetition and not context.individual then
            card.ability.extra.xmult = card.ability.extra.xmult_base
			
			return {
				message = localize('k_reset'),
				colour = G.C.FILTER
			}
			
        end
    end
}

SMODS.Joker{ --Cracker Barrel
    name = "Cracker Barrel",
    key = "crackerbarrel",
    config = {
        extra = {
            creation = 1,
            jokersleft = 5,
        }
    },
    loc_txt = {
        ['name'] = 'Cracker Barrel',
        ['text'] = {
            [1] = 'When {C:attention}Blind{} is selected,',
            [2] = 'create {C:attention}#1# Food Joker',
            [3] = '{C:inactive}({}{C:attention}#2#{}{C:inactive} Food Jokers left)',
            [4] = '{C:inactive}(Must have room)',
        }
    },
    pos = {
        x = 2,
        y = 1
    },
    cost = 8,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.creation, card.ability.extra.jokersleft}}
    end,
    
    calculate = function(self, card, context)
        if context.setting_blind and not self.getting_sliced and not (context.blueprint_card or card).getting_sliced and #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
            local jokers_to_create = math.min(1, G.jokers.config.card_limit - (#G.jokers.cards + G.GAME.joker_buffer))
            if jokers_to_create > 0 then
                card.ability.extra.jokersleft = card.ability.extra.jokersleft - 1
            end
            G.GAME.joker_buffer = G.GAME.joker_buffer + jokers_to_create
            G.E_MANAGER:add_event(Event({
                func = function() 
                    for i = 1, jokers_to_create do
                        local card = create_card('Joker', G.jokers, nil, nil, nil, nil, Cracker.get_food('cracker_food'))
                        card:add_to_deck()
                        G.jokers:emplace(card)
                        card:start_materialize()
                        G.GAME.joker_buffer = 0
                    end
                    return true
                end}))   
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_joker'), colour = G.C.BLUE}) 
            if card.ability.extra.jokersleft < 1 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                            func = function()
                                    G.jokers:remove_card(card)
                                    card:remove()
                                    card = nil
                                return true; end})) 
                        return true
                    end
                })) 
                return {
                    message = 'Emptied!',
                    colour = G.C.FILTER
                }
            end
        end
    end
}

SMODS.Joker{ --Sacramental Katana
    name = "Sacramental Katana",
    key = "sacramentalkatana",
    config = {
        extra = {
            xmult = 1,
        }
    },
    loc_txt = {
        ['name'] = 'Sacramental Katana',
        ['text'] = {
            [1] = 'When {C:attention}Boss Blind{} is defeated,',
            [2] = '{S:1.1,C:red,E:2}sacrifice{} and destroy Joker',
            [3] = 'to the right and permanently',
            [4] = 'add 1/4 its sell value as {X:mult,C:white} XMult',
            [5] = '{C:inactive}(Currently {X:mult,C:white} X#1#{C:inactive} Mult)',
        }
    },
    pos = {
        x = 3,
        y = 1
    },
    cost = 8,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = {set='Other',key='d_sacrifice'}
        return {vars = {card.ability.extra.xmult}}
    end,
    
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main and context.scoring_hand and card.ability.extra.xmult > 1 then
            return {
                message = localize{type='variable',key='a_xmult',vars={card.ability.extra.xmult}},
                Xmult_mod = card.ability.extra.xmult,
                colour = G.C.RED
            }
        elseif context.end_of_round and not context.blueprint and G.GAME.blind.boss then
            local my_pos = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then my_pos = i; break end
            end
            if my_pos and G.jokers.cards[my_pos+1] and not card.getting_sliced and not G.jokers.cards[my_pos+1].ability.eternal and not G.jokers.cards[my_pos+1].getting_sliced then 
                local sliced_card = G.jokers.cards[my_pos+1]
                G.GAME.banned_keys[G.jokers.cards[my_pos+1].config.center_key] = true
                sliced_card.getting_sliced = true
                G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                G.E_MANAGER:add_event(Event({func = function()
                    G.GAME.joker_buffer = 0
                    card.ability.extra.xmult = card.ability.extra.xmult + sliced_card.sell_cost*1/4
                    card:juice_up(0.8, 0.8)
                    sliced_card:start_dissolve({HEX("57ecab")}, nil, 1.6)
                    play_sound('slice1', 0.96+math.random()*0.08)
                return true end }))
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.xmult+(1/4)*sliced_card.sell_cost}}, colour = G.C.RED, no_juice = true})
            end
        end
    end
}

SMODS.Joker{ --Freezer
    name = "Freezer",
    key = "freezer",
    config = {
        extra = {
            multiply = 0,
        }
    },
    loc_txt = {
        ['name'] = 'Freezer',
        ['text'] = {
            [1] = '{C:attention}Food Jokers{}',
            [2] = 'and other {C:attention}perishables{}',
            [3] = 'are {C:spectral}frozen{}',
        }
    },
    pos = {
        x = 4,
        y = 1
    },
    cost = 7,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = {set='Other',key='d_frozen'}
        return {vars = {card.ability.extra.multiply}}
    end,
    
    add_to_deck = function(self, card, from_debuff)
        G.GAME.food_multiplier = card.ability.extra.multiply
    end,
    
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.food_multiplier = 1
    end
}

SMODS.Joker{ --Life Support
    name = "Life Support",
    key = "lifesupport",
    config = {
        extra = {
            rounds = 3,
        }
    },
    loc_txt = {
        ['name'] = 'Life Support',
        ['text'] = {
            [1] = 'Cannot lose for {C:attention}#1#{} rounds,',
            [2] = 'all cards are {C:attention}debuffed{}',
            [3] = '{C:inactive}(Skipping reduces rounds)',
        }
    },
    pos = {
        x = 5,
        y = 1
    },
    cost = 7,
    rarity = 3,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.rounds}}
    end,
    update = function(self, card, dt)
        if G.deck and card.added_to_deck then
            for i, v in pairs (G.deck.cards) do
                v:set_debuff(true)
            end
        end
        if G.hand and card.added_to_deck then
            for i, v in pairs (G.hand.cards) do
                v:set_debuff(true)
            end
        end
    end,
    
    calculate = function(self, card, context)
        if context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
            if context.game_over then
                G.GAME.current_round.usesavedtext = true
                G.GAME.current_round.savedtext = "Saved by Life Support"
                card.ability.extra.rounds = card.ability.extra.rounds - 1
                if card.ability.extra.rounds < 1 then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            play_sound('tarot1')
                            card.T.r = -0.2
                            card:juice_up(0.3, 0.4)
                            card.states.drag.is = true
                            card.children.center.pinch.x = true
                            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                                func = function()
                                        G.jokers:remove_card(card)
                                        card:remove()
                                        card = nil
                                    return true; end})) 
                            return true
                        end
                    })) 
                end
                return {
                    message = localize('k_saved_ex'),
                    saved = true,
                    colour = G.C.RED
                }
            else
                card.ability.extra.rounds = card.ability.extra.rounds - 1
                if card.ability.extra.rounds < 1 then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            play_sound('tarot1')
                            card.T.r = -0.2
                            card:juice_up(0.3, 0.4)
                            card.states.drag.is = true
                            card.children.center.pinch.x = true
                            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                                func = function()
                                        G.jokers:remove_card(card)
                                        card:remove()
                                        card = nil
                                    return true; end})) 
                            return true
                        end
                    })) 
                    return {
                        message = 'Beep!',
                        colour = G.C.FILTER
                    }
                else
                    return {
                        message = card.ability.extra.rounds..'',
                        colour = G.C.FILTER
                    }
                end
            end
        end
        if context.skip_blind and not context.blueprint then
            card.ability.extra.rounds = card.ability.extra.rounds - 1
            if card.ability.extra.rounds < 1 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                            func = function()
                                    G.jokers:remove_card(card)
                                    card:remove()
                                    card = nil
                                return true; end})) 
                        return true
                    end
                })) 
                return {
                    message = 'Beep!',
                    colour = G.C.FILTER
                }
            else
                return {
                    message = card.ability.extra.rounds..'',
                    colour = G.C.FILTER
                }
            end
        elseif context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
            card.ability.extra.rounds = card.ability.extra.rounds - 1
            if card.ability.extra.rounds < 1 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                            func = function()
                                    G.jokers:remove_card(card)
                                    card:remove()
                                    card = nil
                                return true; end})) 
                        return true
                    end
                })) 
                return {
                    message = 'Beep!',
                    colour = G.C.FILTER
                }
            else
                return {
                    message = card.ability.extra.rounds..'',
                    colour = G.C.FILTER
                }
            end
        end
    end
}

SMODS.Joker{ --Curry
    name = "Curry",
    key = "curry",
    config = {
        extra = {
            mult = 15,
            mult_remove = 3,
        }
    },
    loc_txt = {
        ['name'] = 'Curry',
        ['text'] = {
            [1] = '{C:red}+#1#{} Mult',
            [2] = 'before cards are scored',
            [3] = '{C:red}-#2#{} mult per round played',
        }
    },
    pos = {
        x = 6,
        y = 1
    },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult, card.ability.extra.mult_remove * G.GAME.food_multiplier}}
    end,
    
    calculate = function(self, card, context)
        if context.before_main_scoring then -- don't really feel like making this context handle it itself so
            card_eval_status_text(card, 'jokers', nil, percent, nil, {message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}}, mult_mod = card.ability.extra.mult})
            mult = mod_mult(mult + card.ability.extra.mult)
            update_hand_text({delay = 0}, {mult = mult})
        elseif context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
            card.ability.extra.mult = card.ability.extra.mult - card.ability.extra.mult_remove * G.GAME.food_multiplier
            if card.ability.extra.mult <= 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                            func = function()
                                    G.jokers:remove_card(card)
                                    card:remove()
                                    card = nil
                                return true; end})) 
                        return true
                    end
                })) 
                return {
                    message = localize('k_eaten_ex'),
                    colour = G.C.RED
                }
            else
                return {
                    message = localize{type='variable',key='a_mult_minus',vars={card.ability.extra.mult_remove * G.GAME.food_multiplier}},
                    colour = G.C.MULT
                }
            end
        end
    end
}

SMODS.Joker{ --Knife Thrower
    name = "Knife Thrower",
    key = "knifethrower",
    config = {
        extra = {
            hands = 1,
        }
    },
    loc_txt = {
        ['name'] = 'Knife Thrower',
        ['text'] = {
            [1] = '{C:blue}+#1#{} hand each round',
        }
    },
    pos = {
        x = 7,
        y = 1
    },
    cost = 4,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.hands}}
    end,
    
    add_to_deck = function(self, card, from_debuff)
        G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hands
        ease_hands_played(card.ability.extra.hands)
    end,
    
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.hands
        ease_hands_played(-card.ability.extra.hands)
    end
}

SMODS.Joker{ --Northern Star
    name = "Northern Star",
    key = "northstar",
    config = {
        extra = {
            chips_add = 8,
            chips = 8,
        }
    },
    loc_txt = {
        ['name'] = 'Northern Star',
        ['text'] = {
            [1] = '{C:chips}+#1#{} chips per',
            [2] = 'level from {C:attention}most leveled hand{}',
            [3] = '{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)',
        }
    },
    pos = {
        x = 8,
        y = SMODS.current_mod.config.starlo and 2 or 1
    },
    cost = 5,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',

    loc_vars = function(self, info_queue, card)
        local hand, highest = nil, to_big(0)
        for k, v in pairs(G.GAME.hands) do
            if v.visible and v.level > highest then
                hand = k
                highest = v.level
            end
        end
        card.ability.extra.chips = highest * card.ability.extra.chips_add
        return {vars = {card.ability.extra.chips_add, card.ability.extra.chips}}
    end,
    
    calculate = function(self, card, context)
        if context.level_up_hand and not context.blueprint then
            local hand, highest = nil, to_big(0)
            for k, v in pairs(G.GAME.hands) do
                if v.visible and v.level > highest then
                    hand = k
                    highest = v.level
                end
            end
            card.ability.extra.chips = highest * card.ability.extra.chips_add
        elseif context.scoring_hand and context.joker_main and context.cardarea == G.jokers then
            return {
                message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
                chip_mod = card.ability.extra.chips, 
                colour = G.C.CHIPS
            }
        end
    end,
}

SMODS.Joker{ --The Dealer
    name = "The Dealer",
    key = "The Dealer",
    config = {
        extra = {
            odds = 2,
        }
    },
    loc_txt = {
        ['name'] = 'The Dealer',
        ['text'] = {
            [1] = '{C:green}#1# in #2#{} chance',
            [2] = 'to retrigger each',
            [3] = 'scored card',
        }
    },
    pos = {
        x = 9,
        y = 1
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
        if context.cardarea == G.play and context.repetition and not context.repetition_only and pseudorandom('The Dealer') < G.GAME.probabilities.normal/card.ability.extra.odds then
            return {
                message = localize('k_again_ex'),
                repetitions = 1,
                card = card,
            }
        end
    end,
}

SMODS.Joker{ --Bomb
    name = "Bomb",
    key = "bomb",
    config = {
        extra = {
            rounds = 12,
        }
    },
    loc_txt = {
        ['name'] = 'Bomb',
        ['text'] = {
            [1] = '{C:attention}Blows up{} in {C:attention}#1#{} rounds',
            [2] = 'Ticks down when {C:attention}Blind{} is selected',
            [3] = '{S:1.1,C:red,E:2}Ends game{} if this Joker hits 0',
        }
    },
    pos = {
        x = 0,
        y = 2
    },
    cost = 0,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    yes_pool_flag = 'bomb_enabled',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.rounds}}
    end,
    
    calculate = function(self, card, context)
        if context.setting_blind then
            card.ability.extra.rounds = card.ability.extra.rounds - 1
            if card.ability.extra.rounds <= 0 then
                G.STATE = G.STATES.GAME_OVER
                G.STATE_COMPLETE = false
                return {
                    message = 'Boom!',
                    colour = G.C.FILTER
                }
            else
                return {
                    message = card.ability.extra.rounds..'',
                    colour = G.C.FILTER
                }
            end
        end
    end,
}
