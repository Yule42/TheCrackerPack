SMODS.Joker{ --U.F.O.
    key = "ufo",
    config = {
        extra = {
            mult = 0,
            counter = 3,
            counter_max = 3
        }
    },
    pos = {
        x = 3,
        y = 4
    },
    order = 29,
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'sugariimarii', 'sophiedeergirl, sugariimarii'}, key = 'artist_credits_cracker'} end
        return {vars = {card.ability.extra.mult, card.ability.extra.counter, card.ability.extra.counter_max}}
    end,
    
    calculate = function(self, card, context)
        if context.before and card.ability.extra.counter == 1 and G.GAME.hands[context.scoring_name].level > 1 and not context.blueprint then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "mult",
                scalar_table = G.GAME.hands[context.scoring_name],
                scalar_value = "l_mult",
                operation = function(ref_table, ref_value, initial, change)
                    ref_table[ref_value] = initial + change*3
                end,
            })
            return {
                level_up = -1,
                no_retrigger = true
            }
        elseif context.after and not context.blueprint then
            card.ability.extra.counter = card.ability.extra.counter - 1
            if card.ability.extra.counter == 1 then
                local eval = function() return card.ability.extra.counter == 1 and not G.RESET_JIGGLES end
                juice_card_until(card, eval, true)
            elseif card.ability.extra.counter <= 0 then
                card.ability.extra.counter = card.ability.extra.counter_max
            end
		elseif context.joker_main then
			return {
                mult = card.ability.extra.mult,
            }
		end
    end
}
