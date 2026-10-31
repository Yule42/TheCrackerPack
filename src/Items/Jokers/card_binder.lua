SMODS.Joker{ --Card Binder
    key = "card_binder",
    config = {
        extra = {
            mult = 3,
        }
    },
    pos = {
        x = 2,
        y = 2
    },
    order = 30,
    attributes = { 'mult', 'enhancements' },
    cost = 5,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',

    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'GeorgeTheRat', 'sugariimarii'}, key = 'artist_credits_cracker'} end
        local mult = card.ability.extra.mult * G.GAME.Cracker.triggered_jokers_count
        return {vars = {card.ability.extra.mult, mult}}
    end,
    
    calculate = function(self, card, context)
        if context.joker_main then
            if G.GAME.Cracker.triggered_jokers_count > 0 then
                return {
                    mult = card.ability.extra.mult * G.GAME.Cracker.triggered_jokers_count,
                }
            end
        end
    end
}
