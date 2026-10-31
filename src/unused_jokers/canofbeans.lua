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
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'mrkyspices', 'sugariimarii'}, key = 'artist_credits_cracker'} end
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
            if not Cracker.is_adjacent_to_freezer(card) then
                card.ability.extra.rounds = card.ability.extra.rounds - card.ability.extra.rounds_remove
            end
            if card.ability.extra.rounds <= 0 then 
                SMODS.destroy_cards(card, { pinch_anim = true })
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
