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
    order = 16,
    attributes = { 'mult', 'scaling', 'food' },
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
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'amoryax', 'sugariimarii'}, key = 'artist_credits_cracker'} end
        return {vars = {card.ability.extra.mult, card.ability.extra.mult_remove}}
    end,
    
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main and context.scoring_hand and card.ability.extra.mult > 1 then
            return {
                mult = card.ability.extra.mult,
            }
        elseif context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
            if card.ability.extra.mult - card.ability.extra.mult_remove > 0 or Cracker.is_adjacent_to_freezer(card) then -- scale card if adjacent to freezer so frozen can pop off
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "mult",
                    scalar_value = "mult_remove",
                    operation = "-",
                    message_key = 'a_mult_minus',
                    message_colour = G.C.RED
                })
            else
                SMODS.destroy_cards(card, { pinch_anim = true })
                return {
                    message = localize('k_eaten_ex'),
                    colour = G.C.RED
                }
            end
        end
    end
}
