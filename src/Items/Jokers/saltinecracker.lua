SMODS.Joker{ --Saltine Cracker
    key = "saltinecracker",
    config = {
        extra = {
            chips = 25,
            chip_mod = 25,
            odds = 15
        }
    },
    pos = {
        x = 0,
        y = 0
    },
    pools = {
        Food = true,
    },
    order = 5,
    attributes = { 'chips', 'chance', 'food' },
    cost = 5,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    no_pool_flag = 'saltine_cracker_eaten',
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'mrkyspices', 'DistantMind'}, key = 'artist_credits_cracker'} end
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'cracker_Saltine Cracker')
        return {vars = {card.ability.extra.chips, numerator, denominator}}
    end,
    calculate = function(self, card, context)
        if context.after and not context.blueprint and not context.repetition then
            if SMODS.pseudorandom_probability(card, 'cracker_Saltine Cracker', 1, card.ability.extra.odds, 'cracker_Saltine Cracker') then
                SMODS.destroy_cards(card, nil, nil, true)
                G.GAME.pool_flags.saltine_cracker_eaten = true
                return {
                    message = localize('k_cracker_eaten_crumble_ex'),
                    colour = G.C.CHIPS
                }
            else
                return {
                    message = localize('k_safe_ex'),
                    colour = G.C.CHIPS
                }
            end
        elseif context.joker_main then
            return {
                chips = card.ability.extra.chips * (G.GAME.current_round.hands_played + 1), 
            }
        end
    end
}
