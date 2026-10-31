SMODS.Joker{ --Thrifty Joker
    key = "thrifty_joker",
    config = {
        extra = {
            vouchers_multiply = 10,
        }
    },
    pos = {
        x = 4,
        y = 0
    },
    order = 42,
    attributes = { 'mult' },
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'wombatcountry', 'palestjade'}, key = 'artist_credits_cracker'} end
        return {vars = {card.ability.extra.vouchers_multiply, (math.max((table_length(G.GAME.used_vouchers) - (G.GAME.starting_voucher_count or 0)), 0) * card.ability.extra.vouchers_multiply)}}
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main and context.scoring_hand and (table_length(G.GAME.used_vouchers) - (G.GAME.starting_voucher_count or 0)) > 0 then
            return {
                mult = (math.max((table_length(G.GAME.used_vouchers) - (G.GAME.starting_voucher_count or 0)), 0) * card.ability.extra.vouchers_multiply),
            }
        end
    end
}
