SMODS.Joker{ --Cybernana MK920
    name = "Cybernana MK920",
    key = "cybernana",
    config = {
        extra = {
            xmult_add = 3,
            odds = 10000,
            xmult_current = 3,
        }
    },
    loc_txt = {
        ['name'] = 'Cybernana MK920',
        ['text'] = {
            [1] = 'This Joker gains {X:mult,C:white}X#1#{} Mult',
            [2] = 'per round played',
            [3] = '{C:green}#2# in #3#{} chance this card',
            [4] = 'is destroyed at end of round',
            [5] = '{C:inactive}(Currently {X:mult,C:white} X#4#{C:inactive} Mult)'
        }
    },
    pos = {
        x = 3,
        y = 0
    },
    cost = 3,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    unlocked = true,
    discovered = false,
    atlas = 'Jokers',
    yes_pool_flag = 'cavendish_extinct',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xmult_add * G.GAME.food_multiplier, ''..((G.GAME and G.GAME.probabilities.normal or 1) * G.GAME.food_multiplier), card.ability.extra.odds, card.ability.extra.xmult_current}}
    end,
    
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main and context.scoring_hand and card.ability.extra.xmult_current > 1 then
            return {
                message = localize{type='variable',key='a_xmult',vars={card.ability.extra.xmult_current}},
                Xmult_mod = card.ability.extra.xmult_current,
                colour = G.C.RED
            }
        elseif context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
            if pseudorandom('Cybernana MK920') < G.GAME.probabilities.normal/card.ability.extra.odds then 
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
                    message = localize('k_extinct_ex')
                }
            else
                card.ability.extra.xmult_current = card.ability.extra.xmult_current + card.ability.extra.xmult_add * G.GAME.food_multiplier
                return {
                    message = "Safe!",
                    colour = G.C.RED
                }
            end
        end
    end
}

SMODS.Joker{ --Buttered Popcorn
    name = "Buttered Popcorn",
    key = "buttpopcorn",
    config = {
        extra = {
            mult = 50,
            mult_remove = 5,
        }
    },
    loc_txt = {
        ['name'] = 'Buttered Popcorn',
        ['text'] = {
            [1] = '{C:mult}+#1#{} Mult',
            [2] = '{C:mult}-#2#{} Mult per round played',
        }
    },
    pos = {
        x = 5,
        y = 0
    },
    cost = 5,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    yes_pool_flag = 'popcorn_eaten',
    

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult, card.ability.extra.mult_remove * G.GAME.food_multiplier}}
    end,
    
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main and context.scoring_hand and card.ability.extra.mult > 1 then
            return {
                message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
                mult_mod = card.ability.extra.mult,
                colour = G.C.RED
            }
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

SMODS.Joker{ --Sundae
    name = "Sundae",
    key = "frozencustard",
    config = {
        extra = {
            chips = 250,
            chips_remove = 5,
        }
    },
    loc_txt = {
        ['name'] = 'Sundae',
        ['text'] = {
            [1] = '{C:chips}+#1#{} Chips',
            [2] = '{C:chips}-#2#{} Chips for',
            [3] = 'every hand played'
        }
    },
    pos = {
        x = 6,
        y = 0
    },
    cost = 5,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    yes_pool_flag = 'ice_cream_eaten',
    

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.chips, card.ability.extra.chips_remove * G.GAME.food_multiplier}}
    end,
    
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main and context.scoring_hand and card.ability.extra.chips > 1 then
            return {
                message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
                chip_mod = card.ability.extra.chips,
                colour = G.C.CHIPS
            }
        elseif context.after and not context.blueprint and not context.repetition then
            card.ability.extra.chips = card.ability.extra.chips - (card.ability.extra.chips_remove * G.GAME.food_multiplier)
            if card.ability.extra.chips <= 0 then
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
                    message = localize('k_melted_ex'),
                    colour = G.C.CHIPS
                }
            else
                return {
                    message = localize{type='variable',key='a_chips_minus',vars={(card.ability.extra.chips_remove * G.GAME.food_multiplier)}},
                    colour = G.C.CHIPS
                }
            end
        end
    end
}

SMODS.Joker{ --Hard Seltzer
    name = "Hard Seltzer",
    key = "hardseltzer",
    config = {
        extra = {
            rounds = 10,
            rounds_remove = 1
        }
    },
    loc_txt = {
        ['name'] = 'Hard Seltzer',
        ['text'] = {
            [1] = 'Retrigger all cards played',
            [2] = 'for the next {C:attention}#1#{} rounds',
        }
    },
    pos = {
        x = 7,
        y = 0
    },
    cost = 8,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    yes_pool_flag = 'seltzer_drank',
    

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.rounds, card.ability.extra.rounds_remove}}
    end,
    
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.repetition then
            return {
                message = localize('k_again_ex'),
                repetitions = 1,
                card = card
            }
        elseif context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
            card.ability.extra.rounds = card.ability.extra.rounds - (card.ability.extra.rounds_remove * G.GAME.food_multiplier)
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
                return {
                    message = localize('k_drank_ex'),
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

SMODS.Joker{ --Can of Beans
    name = "Can of Beans",
    key = "canofbeans",
    config = {
        extra = {
            hand_size = 5,
            rounds = 10,
            rounds_remove = 1
        }
    },
    loc_txt = {
        ['name'] = 'Can of Beans',
        ['text'] = {
            [1] = '{C:attention}+#3#{} hand size',
            [2] = 'for the next',
            [3] = '{C:attention}#1#{} rounds',
        }
    },
    pos = {
        x = 8,
        y = 0
    },
    cost = 6,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    yes_pool_flag = 'turtle_bean_eaten',
    

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.rounds, card.ability.extra.rounds_remove, card.ability.extra.hand_size}}
    end,
    
    add_to_deck = function(self, card, from_debuff)
        G.hand:change_size(card.ability.extra.hand_size)
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.hand:change_size(-card.ability.extra.hand_size)
    end,
    
    calculate = function(self, card, context)
        if context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
            card.ability.extra.rounds = card.ability.extra.rounds - card.ability.extra.rounds_remove * G.GAME.food_multiplier
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
                return {
                    message = localize('k_eaten_ex'),
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

SMODS.Joker{ --Tsukemen
    name = "Tsukemen",
    key = "tsukemen",
    config = {
        extra = {
            xmult = 2,
            xmult_add = 0.1,
            xmult_remove = 0.75,
        }
    },
    loc_txt = {
        ['name'] = 'Tsukemen',
        ['text'] = {
            [1] = '{X:mult,C:white} X#1#{} Mult,',
            [2] = 'gains {X:mult,C:white} X#2#{} Mult',
            [3] = 'per {C:attention}card{} discarded,',
            [4] = 'loses {X:mult,C:white} X#3# {} Mult',
            [5] = 'after {C:attention}hand is scored{}',
        }
    },
    pos = {
        x = 9,
        y = 0
    },
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    yes_pool_flag = 'ramen_eaten',
    

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xmult, card.ability.extra.xmult_add * G.GAME.food_multiplier, card.ability.extra.xmult_remove * G.GAME.food_multiplier}}
    end,
    
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main and context.scoring_hand and card.ability.extra.xmult > 1 then
            return {
                message = localize{type='variable',key='a_xmult',vars={card.ability.extra.xmult}},
                Xmult_mod = card.ability.extra.xmult,
                colour = G.C.RED
            }
        elseif context.discard and not context.blueprint then
            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_add * G.GAME.food_multiplier
            return {
                delay = 0.2,
                message = localize{type='variable',key='a_xmult',vars={card.ability.extra.xmult_add * G.GAME.food_multiplier}},
                colour = G.C.RED
            }
        elseif context.after and context.cardarea == G.jokers and not context.blueprint then
            card.ability.extra.xmult = card.ability.extra.xmult - card.ability.extra.xmult_remove * G.GAME.food_multiplier
            if card.ability.extra.xmult <= 1 then
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
                    colour = G.C.FILTER
                }
            else
                return {
                    card = card,
                    focus = card,
                    message = localize{type='variable',key='a_xmult_minus',vars={card.ability.extra.xmult_remove * G.GAME.food_multiplier}},
                    colour = G.C.RED
                }
            end
        end
    end
}