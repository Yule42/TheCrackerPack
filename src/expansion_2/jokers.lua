SMODS.Joker{ --Royal Decree
    name = "Royal Decree",
    key = "royaldecree",
    config = {
        extra = {
        }
    },
    pos = {
        x = 8,
        y = 2,
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
        if card and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'None', 'sugariimari'}, key = 'artist_credits_cracker'} end
        return {vars = {}}
    end,
}

-- Royal Decree use
local get_flush_ref = get_flush

function get_flush(hand)
    if not next(SMODS.find_card("j_cracker_royaldecree")) then return get_flush_ref(hand) end

  local ret = {}
  local four_fingers = next(find_joker('Four Fingers'))
  local suits = {
    "Spades",
    "Hearts",
    "Clubs",
    "Diamonds"
  }
  
  local contains_face = false
  local contains_ace = false
  
  
  if #hand > 5 or #hand < (5 - (four_fingers and 1 or 0)) then return ret else
    local t = {}
    for i=1, #hand do
      if hand[i]:get_id() > 10 and hand[i]:get_id() < 14 then contains_face = true; t[#t+1] = hand[i] end
      if hand[i]:get_id() == 14 then contains_ace = true; t[#t+1] = hand[i] end
    end
    if contains_face and contains_ace and next(get_straight(hand, nil, true, true)) then
      table.insert(ret, t)
      return ret
    end
    for j = 1, #suits do
      local t = {}
      local suit = suits[j]
      local flush_count = 0
      for i=1, #hand do
        if hand[i]:is_suit(suit, nil, true) then flush_count = flush_count + 1;  t[#t+1] = hand[i] end 
      end
      if flush_count >= (5 - (four_fingers and 1 or 0)) then
        table.insert(ret, t)
        return ret
      end
    end
    return {}
  end
end
-- royaling rn

local get_poker_hand_info_ref = G.FUNCS.get_poker_hand_info

function G.FUNCS.get_poker_hand_info(_cards)
    if not next(SMODS.find_card("j_cracker_royaldecree")) then return get_poker_hand_info_ref(_cards) end
    local poker_hands = evaluate_poker_hand(_cards)
    local scoring_hand = {}
    local text, disp_text, loc_disp_text = 'NULL', 'NULL', 'NULL'
    for _, v in ipairs(G.handlist) do
        if next(poker_hands[v]) then
            text = v
            scoring_hand = poker_hands[v][1]
            break
        end
    end
    disp_text = text
    local _hand = SMODS.PokerHands[text]
    if text == 'Straight Flush' then
        local contains_face = false
        local contains_ace = false
        for j = 1, #scoring_hand do
            local rank = SMODS.Ranks[scoring_hand[j].base.value]
            contains_ace = contains_ace or rank.key == 'Ace'
            contains_face = contains_face or rank.key == 'Jack' or rank.key == 'Queen' or rank.key == 'King'
        end
        if contains_ace and contains_face then
            disp_text = 'Royal Flush'
        end
    elseif _hand and _hand.modify_display_text and type(_hand.modify_display_text) == 'function' then
        disp_text = _hand:modify_display_text(_cards, scoring_hand) or disp_text
    end
    loc_disp_text = localize(disp_text, 'poker_hands')
    return text, loc_disp_text, poker_hands, scoring_hand, disp_text
end

SMODS.Joker{ --Snail
    name = "Snail",
    key = "snail",
    config = {
        extra = {
            chips = 0,
            chips_add = 4,
            cards = 3,
        }
    },
    pos = {
        x = 2,
        y = 3,
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
        if card and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'None', 'palestjade'}, key = 'artist_credits_cracker'} end
        return {vars = {card.ability.extra.chips, card.ability.extra.chips_add, card.ability.extra.cards}}
    end,
    calculate = function(self, card, context)
        if context.pre_discard and table_length(G.hand.highlighted) == card.ability.extra.cards and not context.blueprint then
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_add
            return {
                message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips_add}},
                colour = G.C.CHIPS
            }
        elseif context.cardarea == G.jokers and context.joker_main and context.scoring_hand and card.ability.extra.chips > 0 then
            return {
                message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
                chip_mod = card.ability.extra.chips, 
                colour = G.C.CHIPS
            }
        end
    end
}

SMODS.Joker{ --Prosopagnosia
    name = "Prosopagnosia",
    key = "prosopagnosia",
    config = {
        extra = {
            xmult = 1,
            xmult_add = 0.08,
        }
    },
    pos = {
        x = 3,
        y = 3,
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
        if card and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'palestjade', 'palestjade'}, key = 'artist_credits_cracker'} end
        return {vars = {card.ability.extra.xmult, card.ability.extra.xmult_add}}
    end,
    
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:is_face() and not context.blueprint then
            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_add
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.RED,
                card = card,
                focus = card,
            }
        elseif context.stay_flipped and context.to_area == G.hand and not context.blueprint then
            if context.other_card:is_face() then
                return { stay_flipped = true }
            end
        elseif context.cardarea == G.jokers and context.joker_main and context.scoring_hand and card.ability.extra.xmult > 1 then
            return {
                message = localize{type='variable',key='a_xmult',vars={card.ability.extra.xmult}},
                Xmult_mod = card.ability.extra.xmult,
                colour = G.C.RED
            }
        end
    end
}

SMODS.Joker{ --Shrimp Cocktail
    name = "Shrimp Cocktail",
    key = "shrimpcocktail",
    config = {
        extra = {
            discards = 6,
            discards_reduction = 1,
        }
    },
    pos = {
        x = 4,
        y = 3,
    },
    cost = 3,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    pools = {
        Food = true,
    },
    

    loc_vars = function(self, info_queue, card)
        if card and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'None', 'brook03'}, key = 'artist_credits_cracker'} end
        return {vars = {card.ability.extra.discards, math.floor(card.ability.extra.discards_reduction * G.GAME.food_multiplier), (card.ability.extra.discards == 1 --[[and G.SETTINGS.language == "en-us"]]) and "" or "s"}}
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.discards
        ease_discard(card.ability.extra.discards)
    end,
    
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.discards
        ease_discard(-card.ability.extra.discards)
    end,
    
    calculate = function(self, card, context)
        if context.pre_discard and not context.blueprint then
            card.ability.extra.discards = card.ability.extra.discards - math.floor(card.ability.extra.discards_reduction * G.GAME.food_multiplier)
            G.GAME.round_resets.discards = G.GAME.round_resets.discards - math.floor(card.ability.extra.discards_reduction * G.GAME.food_multiplier)
            if card.ability.extra.discards <= 0 then
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
                    message = localize{type='variable',key='a_discards_minus',vars={math.floor(card.ability.extra.discards_reduction * G.GAME.food_multiplier)}},
                    colour = G.C.MULT
                }
            end
        end
    end
}

SMODS.Joker{ --Hamburger
    name = "Hamburger",
    key = "hamburger",
    config = {
        extra = {
            hands = 6,
            discards_reduction = 1,
            discard_cards_required = 5,
            discard_cards_left = 5,
        }
    },
    pos = {
        x = 5,
        y = 3,
    },
    cost = 8,
    rarity = 3,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    pools = {
        Food = true,
    },
    

    loc_vars = function(self, info_queue, card)
        if card and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'None', 'brook03'}, key = 'artist_credits_cracker'} end
        return {vars = {card.ability.extra.hands, math.floor(card.ability.extra.discards_reduction * G.GAME.food_multiplier), (card.ability.extra.discards == 1 --[[and G.SETTINGS.language == "en-us"]]) and "" or "s", card.ability.extra.discard_cards_required, card.ability.extra.discard_cards_left}}
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hands
        ease_hands_played(card.ability.extra.hands)
    end,
    
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.hands
        ease_hands_played(-card.ability.extra.hands)
    end,
    
    calculate = function(self, card, context)
        if context.discard and not context.blueprint then
            card.ability.extra.discard_cards_left = card.ability.extra.discard_cards_left - 1
            if card.ability.extra.discard_cards_left <= 0 then
                card.ability.extra.discard_cards_left = card.ability.extra.discard_cards_required
                ease_hands_played(-math.floor(card.ability.extra.discards_reduction * G.GAME.food_multiplier))
                card.ability.extra.hands = card.ability.extra.hands - math.floor(card.ability.extra.discards_reduction * G.GAME.food_multiplier)
                G.GAME.round_resets.hands = G.GAME.round_resets.hands - math.floor(card.ability.extra.discards_reduction * G.GAME.food_multiplier)
                if card.ability.extra.hands <= 0 then
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
                        message = localize{type='variable',key='a_hands_minus',vars={card.ability.extra.discards_reduction * G.GAME.food_multiplier}},
                        colour = G.C.BLUE
                    }
                end
            end
        end
    end
}

SMODS.Joker{ --Potato Chips
    name = "Potato Chips",
    key = "potatochips",
    config = {
        extra = {
            chips = 200,
            chips_remove = 50,
        }
    },
    pos = {
        x = 6,
        y = 3,
    },
    cost = 6,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    pools = {
        Food = true,
    },
    

    loc_vars = function(self, info_queue, card)
        if card and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'None', 'sugariimari'}, key = 'artist_credits_cracker'} end
        return {vars = {card.ability.extra.chips, card.ability.extra.chips_remove}}
    end,
    
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main and context.scoring_hand and card.ability.extra.chips > 0 then
            return {
                message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
                chip_mod = card.ability.extra.chips, 
                colour = G.C.CHIPS
            }
        elseif context.end_of_round and context.cardarea == G.jokers and not context.blueprint and not context.repetition and not context.individual and G.GAME.current_round.hands_played == 1 then
            if card.ability.extra.chips - card.ability.extra.chips_remove <= 0 then 
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
                    colour = G.C.CHIPS
                }
            else
                card.ability.extra.chips = card.ability.extra.chips - card.ability.extra.chips_remove * G.GAME.food_multiplier
                return {
                    message = localize{type='variable',key='a_chips_minus',vars={card.ability.extra.chips_remove * G.GAME.food_multiplier}},
                    colour = G.C.CHIPS
                }
            end
        end
    end
}

SMODS.Joker{ --Ants
    name = "Ants",
    key = "ants",
    config = {
        extra = {
            xmult = 1,
            xmult_add = 1,
        }
    },
    pos = {
        x = 7,
        y = 3,
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
        if card and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'wombatcountry', 'courier'}, key = 'artist_credits_cracker'} end
        return {vars = {card.ability.extra.xmult, card.ability.extra.xmult_add}}
    end,
    
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main and context.scoring_hand and card.ability.extra.xmult > 1 then
            return {
                message = localize{type='variable',key='a_xmult',vars={card.ability.extra.xmult}},
                Xmult_mod = card.ability.extra.xmult,
                colour = G.C.RED
            }
        elseif context.self_destroying_food_joker and context.cardarea == G.jokers and not context.blueprint then
            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_add
            return {
                message = localize{type='variable',key='a_xmult',vars={card.ability.extra.xmult_add}},
                colour = G.C.MULT
            }
        end
    end
}

SMODS.Joker{ --High Roller
    name = "High Roller",
    key = "highroller",
    config = {
        extra = {
            xmult = 1,
            xmult_add = 0.5,
        }
    },
    pos = {
        x = 8,
        y = 3,
    },
    cost = 8,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    enhancement_gate = 'm_lucky',

    loc_vars = function(self, info_queue, card)
        if card and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'palestjade', 'brook03'}, key = 'artist_credits_cracker'} end
        return {vars = {card.ability.extra.xmult, card.ability.extra.xmult_add}}
    end,
    
    calculate = function(self, card, context)
        if context.after then
            card.ability.extra.xmult = 1
        elseif context.cardarea == G.play and context.individual and context.other_card.config.center.key == 'm_lucky' then
            if context.other_card.lucky_trigger and not context.blueprint then
                card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_add
            end
            if card.ability.extra.xmult > 1 then
                return {
                    message = localize{type='variable',key='a_xmult',vars={card.ability.extra.xmult}},
                    Xmult_mod = card.ability.extra.xmult,
                    colour = G.C.RED
                }
            end
        end
    end
}

