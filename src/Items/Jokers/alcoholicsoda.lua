SMODS.Joker{ --Alcoholic Soda
    name = "Alcoholic Soda",
    key = "alcoholicsoda",
    config = {
        extra = {
            odds = 4
        }
    },
    pos = {
        x = 7,
        y = 0
    },
    pools = {
        Food = true,
    },
    order = 31,
    attributes = { 'chance', 'debuff', 'food' },
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',

    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'mrkyspices', 'sophiedeergirl'}, key = 'artist_credits_cracker'} end
        local new_numerator, new_denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'cracker_Alcoholic Soda')
        return {vars = {new_numerator, new_denominator}}
    end,
    
    remove_from_deck = function(self, card, from_debuff)
        for k, v in pairs(G.playing_cards) do
            SMODS.debuff_card(v, false, 'cracker_Alcoholic Soda')
        end
    end,
    
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.repetition then
            return {
                message = localize('k_again_ex'),
                repetitions = 1,
                card = card
            }
        elseif context.setting_blind and not context.blueprint then
            for k, v in pairs(G.playing_cards) do
                if SMODS.pseudorandom_probability(card, 'cracker_Alcoholic Soda', 1, card.ability.extra.odds, 'cracker_Alcoholic Soda') then
                    SMODS.debuff_card(v, true, 'cracker_Alcoholic Soda')
                end
            end
        elseif context.end_of_round and context.main_eval and not context.blueprint then
            for k, v in pairs(G.playing_cards) do
                SMODS.debuff_card(v, false, 'cracker_Alcoholic Soda')
            end
        end
    end
}
