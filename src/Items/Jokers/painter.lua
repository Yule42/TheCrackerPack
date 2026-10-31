SMODS.Joker{ -- Painter
    key = "painter",
    config = {
        extra = {
            mult = 10,
            above = 7
        }
    },
    pos = {
        x = 0,
        y = 5
    },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    order = 44,
    attributes = { 'mult', 'hand_size' },
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'Le Ginger', 'palestjade'}, key = 'artist_credits_cracker'} end
        local mult = math.max(0, card.ability.extra.mult * ((G.hand and G.hand.config.card_limit or 8) - card.ability.extra.above))
        return {vars = { card.ability.extra.mult, card.ability.extra.above, mult }}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = math.max(0, card.ability.extra.mult * ((G.hand and G.hand.config.card_limit or 8) - card.ability.extra.above)),
            }
        end
    end,
}
