SMODS.Joker{ --Tsukemen
    name = "Tsukemen",
    key = "tsukemen",
    config = {
        extra = {
            mult = 5,
            cards = 20,
            cards_reduce = 1
        }
    },
    pos = {
        x = 9,
        y = 0
    },
    pools = {
        Food = true,
    },
    order = 28,
    attributes = { 'mult', 'scaling', 'discard', 'modify_card', 'perma_bonus', 'food' },
    cost = 5,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',

    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'palestjade', 'sophiedeergirl'}, key = 'artist_credits_cracker'} end
        return {vars = {card.ability.extra.mult, card.ability.extra.cards}}
    end,
    
    calculate = function(self, card, context)
        if context.discard then
            if not context.blueprint then
                if not Cracker.is_adjacent_to_freezer(card) and card.ability.extra.cards < 2 then -- this is SO behind we need to check for 1
                    SMODS.destroy_cards(card, nil, nil, true)
                    return {
                        message = localize('k_eaten_ex'),
                        colour = G.C.FILTER
                    }
                end
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "cards",
                    scalar_value = "cards_reduce",
                    operation = "-",
                    scaling_message = {
                        message = card.ability.extra.cards..'',
                        colour = G.C.FILTER,
                        delay = 0.2
                    }
                })
            end
            context.other_card.ability.perma_mult = (context.other_card.ability.perma_mult or 0) + card.ability.extra.mult
            return nil, true
        end
    end
}
