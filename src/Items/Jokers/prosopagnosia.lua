SMODS.Joker{ --Prosopagnosia
    name = "Prosopagnosia",
    key = "prosopagnosia",
    config = {
        extra = {
            x_mult = 1,
            x_mult_add = 0.08,
        }
    },
    pos = {
        x = 3,
        y = 3,
    },
    order = 20,
    attributes = { 'xmult', 'face', 'scaling' },
    cost = 8,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    

    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'palestjade', 'palestjade'}, key = 'artist_credits_cracker'} end
        return {vars = {card.ability.extra.x_mult, card.ability.extra.x_mult_add}}
    end,
    
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:is_face() and not context.blueprint then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "x_mult",
                scalar_value = "x_mult_add",
                operation = "+"
            })
        elseif context.stay_flipped and context.to_area == G.hand and not context.blueprint then
            if context.other_card:is_face() then
                return { stay_flipped = true }
            end
        elseif context.cardarea == G.jokers and context.joker_main and context.scoring_hand and card.ability.extra.x_mult > 1 then
            return {
                xmult = card.ability.extra.x_mult,
            }
        end
    end
}
