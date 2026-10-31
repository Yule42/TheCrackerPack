SMODS.Joker{ --High Roller
    key = "highroller",
    config = {
        extra = {
            x_mult = 1,
            x_mult_add = 0.25,
        }
    },
    pos = {
        x = 8,
        y = 3,
    },
    order = 6,
    attributes = { 'enhancements', 'xmult', 'scaling', 'reset' },
    cost = 7,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    enhancement_gate = 'm_lucky',
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'palestjade', 'brook03'}, key = 'artist_credits_cracker'} end
        info_queue[#info_queue + 1] = G.P_CENTERS.m_lucky
        return {vars = {card.ability.extra.x_mult, card.ability.extra.x_mult_add}}
    end,
    
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and not context.blueprint then
            card.ability.extra.x_mult = 1
            return {
                message = localize('k_reset')
            }
        elseif context.cardarea == G.play and context.individual and context.other_card.config.center.key == 'm_lucky' then
            local returnthis = false
            if context.other_card.lucky_trigger and not context.blueprint then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "x_mult",
                    scalar_value = "x_mult_add",
                    operation = "+",
                    no_message = true,
                })
                returnthis = true
            end
            if card.ability.extra.x_mult > 1 then
                if returnthis then
                    return {
                        extra = {
                            colour = G.C.MULT,
                            xmult = card.ability.extra.x_mult,
                        },
                        message = localize('k_upgrade_ex'),
                        message_card = card,
                    }
                end
                return {
                    xmult = card.ability.extra.x_mult,
                }
            end
        end
    end
}
