SMODS.Joker{ --The Falcon
    name = "The Falcon",
    key = "thefalcon",
    config = {
        extra = {
            odds = 7,
            FPS = 10,
            delay = 0,
            x_pos = 0
        }
    },
    pos = {
        x = 0,
        y = 0,
    },
    order = 27,
    attributes = { 'destroy_card', 'discard', 'chance' },
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'falcon',

    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'palestjade', 'sugariimarii'}, key = 'artist_credits_cracker'} end
        local new_numerator, new_denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'cracker_thefalcon')
        return {vars = {new_numerator, new_denominator}}
    end,
    
    update = function(self, card, dt)
        if card.ability.extra.delay >= 1 / card.ability.extra.FPS then
            card.ability.extra.x_pos = (card.ability.extra.x_pos + 1) % 20 -- 20 is the number of frames
            card.children.center:set_sprite_pos({x=card.ability.extra.x_pos,y=0})
            card.ability.extra.delay = 0
        end
        card.ability.extra.delay = card.ability.extra.delay + love.timer.getDelta() -- dt kept returning 0
    end,
    
    calculate = function(self, card, context)
        if context.discard and not context.other_card.ability.cracker_falcon_destroyed then
			if SMODS.pseudorandom_probability(card, 'cracker_thefalcon', 1, card.ability.extra.odds, 'cracker_thefalcon') then
                context.other_card.ability.cracker_falcon_destroyed = true
                G.E_MANAGER:add_event(Event({ -- just in case it survives somehow (NEED TO TEST WHEN "CREATES COPY OF DESTROYED CARDS" IS ADDED)
                    trigger = 'after',
                    delay = 0,
                    func = function()
                        context.other_card.ability.cracker_falcon_destroyed = nil
                        return true
                    end
                }))

				return {
					message = localize('k_cracker_discard_falcon_ex'),
					colour = G.C.FILTER,
					remove = true,
				}
			end
        end
    end
}
