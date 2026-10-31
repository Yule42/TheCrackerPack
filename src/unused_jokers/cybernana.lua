SMODS.Joker{ --Cybernana MK920
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
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'mrkyspices', 'sugariimarii'}, key = 'artist_credits_cracker'} end
        local new_numerator, new_denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'cracker_Cybernana MK920')
        return {vars = {card.ability.extra.x_mult_add, new_numerator, new_denominator, card.ability.extra.x_mult}}
    end,
    
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main and context.scoring_hand and card.ability.extra.x_mult > 1 then
            return {
                xmult = card.ability.extra.x_mult,
            }
        elseif context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
            if Cracker.is_adjacent_to_freezer(card) then
                return {
                    message = localize('k_cracker_frozen_ex'),
                    colour = G.C.FILTER
                }
            else
                if SMODS.pseudorandom_probability(card, 'cracker_Cybernana MK920', 1, card.ability.extra.odds, 'cracker_Cybernana MK920') then 
                    SMODS.destroy_cards(card, { pinch_anim = true })
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
}
