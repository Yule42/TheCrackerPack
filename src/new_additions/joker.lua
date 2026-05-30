SMODS.Joker{ --Charcuterie Board
    key = "charcuterie_board",
    config = {
        extra = {
            chips = 300,
            odds = 300
        }
    },
    pos = {
        x = 0,
        y = 4
    },
    pools = {
        Food = true,
    },
    cost = 3,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    yes_pool_flag = 'saltine_cracker_eaten',
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'gfs', 'DistantMind'}, key = 'artist_credits_cracker'} end
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'Charcuterie Board')
        return {vars = {card.ability.extra.chips, numerator, denominator}}
    end,
    calculate = function(self, card, context)
        if context.after and not context.blueprint and not context.repetition then
            if SMODS.pseudorandom_probability(card, 'Charcuterie Board', 1, card.ability.extra.odds, 'Charcuterie Board') then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                            func = function()
                                    G.jokers:remove_card(card)
                                    card:remove()
                                    card = nil
                                return true; end})) 
                        return true
                    end
                })) 
                return {
                    message = localize('k_eaten_ex'),
                    colour = G.C.CHIPS
                }
            else
                return {
                    message = localize('k_safe_ex'),
                    colour = G.C.CHIPS
                }
            end
        elseif context.cardarea == G.jokers and context.joker_main and context.scoring_hand and card.ability.extra.chips > 0 then
            return {
                chips = card.ability.extra.chips, 
            }
        end
    end
}
