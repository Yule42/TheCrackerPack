SMODS.Joker{ --Bomb Joker
    key = "bomb",
    config = {
        extra = {
            rounds = 12,
        }
    },
    pos = {
        x = 0,
        y = 2
    },
    attributes = { 'scaling' },
    cost = 0,
    rarity = 2,
    order = 999,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = false,
    no_collection = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    yes_pool_flag = 'bomb_enabled',
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'vyletbunni', 'sophiedeergirl'}, key = 'artist_credits_cracker'} end
        return {vars = {card.ability.extra.rounds}}
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            card.ability.extra.rounds = card.ability.extra.rounds - 1
            if card.ability.extra.rounds <= 0 then
                G.STATE = G.STATES.GAME_OVER
                G.STATE_COMPLETE = false
                return {
                    message = localize('k_cracker_bomb_explode_ex'),
                    colour = G.C.FILTER
                }
            else
                return {
                    message = card.ability.extra.rounds..'',
                    colour = G.C.FILTER
                }
            end
        end
    end,
}
