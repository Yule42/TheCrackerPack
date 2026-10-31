SMODS.Joker{ --Pink Card
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
}
