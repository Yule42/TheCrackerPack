SMODS.Joker{ --Paycheck
    key = "paycheck",
    config = {
        extra = {
            money = 20,
            active = false
        }
    },
    pos = {
        x = 7,
        y = 2
    },
    order = 36,
    attributes = { 'economy', 'skip' },
    cost = 6,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',

    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'mrkyspices', 'sugariimarii'}, key = 'artist_credits_cracker'} end
        return {vars = {card.ability.extra.money}}
    end,
    
    calc_dollar_bonus = function(self, card)
        local active = card.ability.extra.active
        local bonus = card.ability.extra.money
        card.ability.extra.active = false
        if bonus > 0 and active then
            return bonus
        end
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval and context.beat_boss then
            for _, state in pairs(G.GAME.round_resets.blind_states) do
                if state == 'Skipped' then
                    card.ability.extra.active = true
                    return nil, true
                end
            end
        end
    end,
}
