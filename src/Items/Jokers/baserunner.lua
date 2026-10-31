SMODS.Joker{ --Baserunner
    name = "Baserunner",
    key = "baserunner",
    config = {
        extra = {
            x_mult = 1,
            x_mult_add = 0.5,
            skips_reset = 4,
            skips_done = 0,
        }
    },
    pos = {
        x = 0,
        y = 1
    },
    order = 2,
    attributes = { 'xmult', 'scaling', 'reset' },
    cost = 7,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',

    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'sophiedeergirl', 'sophiedeergirl, sugariimarii'}, key = 'artist_credits_cracker'} end
        return {vars = {card.ability.extra.x_mult, card.ability.extra.x_mult_add, card.ability.extra.skips_reset, card.ability.extra.skips_done}}
    end,
    
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.extra.x_mult,
            }
        elseif context.skipping_booster and not context.blueprint then
            card.ability.extra.skips_done = card.ability.extra.skips_done + 1
            if card.ability.extra.skips_done >= card.ability.extra.skips_reset then
                card.ability.extra.x_mult = 1
                card.ability.extra.skips_done = 0
                return {
                    message = localize('k_reset')
                }
            else
                card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_add
                return {
                    message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult } },
                    colour = G.C.RED,
                    delay = 0.45
                }
            end
        end
    end
}
