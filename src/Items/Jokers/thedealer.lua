SMODS.Joker{ --The Dealer
    key = "thedealer",
    config = {
        extra = {
            odds = 2,
        }
    },
    pos = {
        x = SMODS.current_mod.config.starlo and 1 or 9,
        y = SMODS.current_mod.config.starlo and 3 or 1
    },
    order = 26,
    attributes = { 'chance', 'retrigger' },
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'wombatcountry', 'sophiedeergirl'}, key = 'artist_credits_cracker'} end
        local new_numerator, new_denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'cracker_thedealer')
        return {vars = {new_numerator, new_denominator}}
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.repetition and not context.repetition_only and SMODS.pseudorandom_probability(card, 'cracker_thedealer', 1, card.ability.extra.odds, 'cracker_thedealer') then
            return {
                message = localize('k_again_ex'),
                repetitions = 1,
                card = card,
            }
        end
    end,
}
