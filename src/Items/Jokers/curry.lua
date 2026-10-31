SMODS.Joker{ --Curry
    key = "curry",
    config = {
        extra = {
            mult = 15,
            mult_remove = 3,
        }
    },
    pos = {
        x = 6,
        y = 1
    },
    pools = {
        Food = true,
    },
    order = 33,
    attributes = { 'mult', 'scaling', 'food' },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'mrkyspices', 'sophiedeergirl'}, key = 'artist_credits_cracker'} end
        return {vars = {card.ability.extra.mult, card.ability.extra.mult_remove}}
    end,
    calculate = function(self, card, context)
        if context.initial_scoring_step then
            return {
                mult = card.ability.extra.mult,
            }
        elseif context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
            if Cracker.is_adjacent_to_freezer(card) or card.ability.extra.mult - card.ability.extra.mult_remove > 0 then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "mult",
                    scalar_value = "mult_remove",
                    operation = "-",
                    message_key = 'a_mult_minus',
                    message_colour = G.C.RED
                })
                return nil, true
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
