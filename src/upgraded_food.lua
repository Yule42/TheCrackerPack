--[[SMODS.Joker{ --Cybernana MK920
    name = "Cybernana MK920",
    key = "cybernana",
    config = {
        extra = {
            x_mult_add = 3,
            odds = 10000,
            x_mult = 3,
        }
    },
    pos = {
        x = 3,
        y = 0
    },
    pools = {
        Food = true,
    },
    cost = 3,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    unlocked = true,
    atlas = 'Jokers',
    yes_pool_flag = 'cavendish_extinct',

    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'mrkyspices', 'sugariimari'}, key = 'artist_credits_cracker'} end
        local new_numerator, new_denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'Cybernana MK920')
        return {vars = {card.ability.extra.x_mult_add, new_numerator, new_denominator, card.ability.extra.x_mult}}
    end,
    
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main and context.scoring_hand and card.ability.extra.x_mult > 1 then
            return {
                xmult = card.ability.extra.x_mult,
            }
        elseif context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
            if G.GAME.food_multiplier == 0 then
                return {
                    message = localize('k_frozen'),
                    colour = G.C.FILTER
                }
            else
                if SMODS.pseudorandom_probability(card, 'Cybernana MK920', 1, card.ability.extra.odds * G.GAME.food_multiplier, 'Cybernana MK920') then 
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
                    SMODS.scale_card(card, {
                        ref_table = card.ability.extra,
                        ref_value = "x_mult",
                        scalar_value = "x_mult_add",
                        operation = "+",
                        message_key = 'a_xmult',
                        message_colour = G.C.RED
                    })
                end
            end
            
        end
    end
}]]

SMODS.Joker{ --Buttered Popcorn
    name = "Buttered Popcorn",
    key = "buttpopcorn",
    config = {
        extra = {
            mult = 50,
            mult_remove = 5,
        }
    },
    pos = {
        x = 5,
        y = 0
    },
    pools = {
        Food = true,
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
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'amoryax', 'sugariimari'}, key = 'artist_credits_cracker'} end
        return {vars = {card.ability.extra.mult, card.ability.extra.mult_remove}}
    end,
    
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main and context.scoring_hand and card.ability.extra.mult > 1 then
            return {
                mult = card.ability.extra.mult,
            }
        elseif context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
            if card.ability.extra.mult - card.ability.extra.mult_remove * G.GAME.food_multiplier > 0 then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "mult",
                    scalar_value = "mult_remove",
                    operation = "-",
                    message_key = 'a_mult_minus',
                    message_colour = G.C.RED
                })
            else
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
            end
        end
    end
}

SMODS.Joker{ --Sundae
    name = "Sundae",
    key = "sundae",
    config = {
        extra = {
            chips = 75,
            mult = 15,
            left = 4,
            state = 0,
        }
    },
    pos = {
        x = 6,
        y = 0
    },
    pools = {
        Food = true,
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
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'mrkyspices', 'sophiedeergirl'}, key = 'artist_credits_cracker'} end
        local key = "j_cracker_sundae_chips"
        if card.ability.extra.state == 1 then key = "j_cracker_sundae_mult"
        elseif card.ability.extra.state == 2 then key = "j_cracker_sundae_planet" end
        return {key = key, vars = {card.ability.extra.chips, card.ability.extra.mult, card.ability.extra.left}}
    end,
    
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main and context.scoring_hand then
            if card.ability.extra.state == 0 then
                return {
                    chips = card.ability.extra.chips,
                }
            elseif card.ability.extra.state == 1 then
                return {
                    mult = card.ability.extra.mult,
                }
            else
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        SMODS.add_card {
                            set = 'Planet',
                            key_append = 'sundae'
                        }
                        G.GAME.consumeable_buffer = 0
                        return true
                    end)
                }))
                return {
                    message = localize('k_plus_planet'),
                    colour = G.C.SECONDARY_SET.Planet,
                }
            end
        elseif context.after and not context.blueprint and not context.repetition then
            if card.ability.extra.state == 2 then
                if card.ability.extra.left - math.floor(1 * G.GAME.food_multiplier) > 0 then
                    card.ability.extra.left = card.ability.extra.left - math.floor(1 * G.GAME.food_multiplier)
                    SMODS.calculate_effect({message = G.GAME.food_multiplier > 0 and ''..card.ability.extra.left or localize('k_frozen'), colour = G.C.FILTER}, card)
                else
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
                end
            end
            card.ability.extra.state = card.ability.extra.state + 1
            if card.ability.extra.state > 2 then
                card.ability.extra.state = 0
                return {
                    message = localize('k_chips'),
                    colour = G.C.CHIPS
                }
            elseif card.ability.extra.state == 1 then
                return {
                    message = localize('k_mult'),
                    colour = G.C.MULT
                }
            else
                return {
                    message = localize('k_planet'),
                    colour = G.C.SECONDARY_SET.Planet 
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
    pos = {
        x = 7,
        y = 0
    },
    pools = {
        Food = true,
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
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'mrkyspices', 'sugariimari'}, key = 'artist_credits_cracker'} end
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
    pos = {
        x = 8,
        y = 0
    },
    pools = {
        Food = true,
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
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'mrkyspices', 'sugariimari'}, key = 'artist_credits_cracker'} end
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
            x_mult = 2,
            x_mult_add = 0.05,
            x_mult_remove = 0.35,
        }
    },
    pos = {
        x = 9,
        y = 0
    },
    pools = {
        Food = true,
    },
    cost = 8,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',

    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'palestjade', 'sugariimari'}, key = 'artist_credits_cracker'} end
        return {vars = {card.ability.extra.x_mult, card.ability.extra.x_mult_add, card.ability.extra.x_mult_remove}}
    end,
    
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main and context.scoring_hand and card.ability.extra.x_mult > 1 then
            return {
                xmult = card.ability.extra.x_mult,
            }
        elseif context.discard and not context.blueprint then
            if G.GAME.food_multiplier > 0 then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "x_mult",
                    scalar_value = "x_mult_add",
                    operation = "+",
                    scaling_message = {
                        message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.x_mult_add * G.GAME.food_multiplier}},
                        colour = G.C.RED,
                        delay = 0.2
                    }
                })
            end
        elseif context.after and context.cardarea == G.jokers and not context.blueprint then
            if card.ability.extra.x_mult - card.ability.extra.x_mult_remove * G.GAME.food_multiplier >= 1 then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "x_mult",
                    scalar_value = "x_mult_remove",
                    operation = "-",
                    scaling_message = {
                        card = card,
                        focus = card,
                        message = localize{type='variable',key='a_xmult_minus',vars={card.ability.extra.x_mult_remove * G.GAME.food_multiplier}},
                        colour = G.C.RED
                    }
                })
            else
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
            end
        end
    end
}
