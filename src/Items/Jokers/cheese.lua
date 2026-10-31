SMODS.Joker{ --Cheese
    key = "cheese",
    config = {
        extra = {
            x_mult = 2.5,
            x_mult_remove = 0.5,
            x_mult_base = 2.5,
            x_mult_min = 1,
        }
    },
    pos = {
        x = 1,
        y = 1
    },
    pools = {
        Food = true,
    },
    order = 32,
    attributes = { 'xmult', 'scaling', 'food' },
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'amoryax', 'sophiedeergirl'}, key = 'artist_credits_cracker'} end
        return {vars = {card.ability.extra.x_mult, card.ability.extra.x_mult_remove, card.ability.extra.x_mult_min}}
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main and context.scoring_hand and card.ability.extra.x_mult > 1 then
            return {
                xmult = card.ability.extra.x_mult,
            }
        elseif context.after and not context.blueprint and not context.repetition and (to_big(hand_chips) * to_big(mult) + to_big(G.GAME.chips)) < to_big(G.GAME.blind.chips) then
            if Cracker.is_adjacent_to_freezer(card) or card.ability.extra.x_mult - card.ability.extra.x_mult_remove > card.ability.extra.x_mult_min then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "x_mult",
                    scalar_value = "x_mult_remove",
                    operation = "-",
                    message_key = 'a_xmult_minus',
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
        elseif context.end_of_round and context.cardarea == G.jokers and not context.blueprint and not context.repetition and not context.individual then
            card.ability.extra.x_mult = card.ability.extra.x_mult_base
            return {
                message = localize('k_reset'),
                colour = G.C.FILTER
            }
            
        end
    end
}
