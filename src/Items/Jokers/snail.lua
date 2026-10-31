SMODS.Joker{ --Snail
    name = "Snail",
    key = "snail",
    config = {
        extra = {
            mult = 0,
            mult_add = 8
        }
    },
    pos = {
        x = 2,
        y = 3,
    },
    order = 40,
    attributes = { 'mult', 'scaling' },
    cost = 6,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    

    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'mrkyspices', 'palestjade'}, key = 'artist_credits_cracker'} end
        return {vars = {card.ability.extra.mult, card.ability.extra.mult_add}}
    end,
    calculate = function(self, card, context)
        if context.joker_main and card.ability.extra.mult > 0 then
            return {
                mult = card.ability.extra.mult, 
            }
        elseif context.setting_blind and context.blind.big and not context.blueprint then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "mult",
                scalar_value = "mult_add",
                operation = "+",
                message_key = 'a_mult',
                message_colour = G.C.MULT
            })
            return nil, true
        end
    end
}
