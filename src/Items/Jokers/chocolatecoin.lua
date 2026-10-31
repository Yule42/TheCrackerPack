SMODS.Joker{ --Chocolate Coin
    key = "chocolatecoin",
    config = {
        extra = {
            money = 3,
            rounds = 5,
            rounds_mod = 1
        }
    },
    pos = {
        x = 1,
        y = 0
    },
    pools = {
        Food = true,
    },
    order = 25,
    attributes = { 'economy', 'scaling', 'food' },
    cost = 3,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    loc_vars = function(self, info_queue, card)
    if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'lumahoneyy', 'sophiedeergirl'}, key = 'artist_credits_cracker'} end
        return {vars = {card.ability.extra.money, card.ability.extra.rounds}}
    end,
    calc_dollar_bonus = function(self, card)
        local bonus = card.ability.extra.money
        if card.ability.extra.rounds <= 0 then
            SMODS.destroy_cards(card, { pinch_anim = true })
        end
        if bonus > 0 then return bonus end
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "rounds",
                scalar_value = "rounds_mod",
                operation = "-",
                no_message = true
            })
            if card.ability.extra.rounds <= 0 then
                return {
                    message = localize('k_eaten_ex'),
                    colour = G.C.FILTER
                }
            else
                return {
                    message = tostring(card.ability.extra.rounds),
                    colour = G.C.FILTER
                }
            end
        end
    end
}
