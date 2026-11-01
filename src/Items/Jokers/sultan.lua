SMODS.Joker{ -- Sultan
    key = "sultan",
    config = {
        extra = {
            xmult = 1,
            xmult_gain = 0.2,
            cards = 5,
        }
    },
    pos = {
        x = 3,
        y = 5
    },
    attributes = { 'xmult', 'scaling', 'reset', 'hands' },
    cost = 7,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'Le Ginger', 'sophiedeergirl'}, key = 'artist_credits_cracker'} end
        return {vars = {card.ability.extra.xmult, card.ability.extra.xmult_gain, card.ability.extra.cards}}
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            if #context.scoring_hand >= card.ability.extra.cards then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "xmult",
                    scalar_value = "xmult_gain",
                    operation = "+",
                    no_message = true
                })
            elseif card.ability.extra.xmult > 1 then
                card.ability.extra.xmult = 1
                return {
                    message = localize('k_reset')
                }
            end
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end
}
