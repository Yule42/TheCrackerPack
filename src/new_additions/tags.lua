SMODS.Tag {
    key = 'crystal',
    config = {
        dollars_per_tarot = 2
    },
    pos = { 
        x = 0,
        y = 0
    },
    min_ante = 2,
    discovered = true,
    atlas = 'tags',
    loc_vars = function(self, info_queue, tag)
        return {vars = {tag.config.dollars_per_tarot, tag.config.dollars_per_tarot * (G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.tarot or 0)}}
    end,

    apply = function(self, tag, context)
        if context.type == 'immediate' then
            local lock = tag.ID
            G.CONTROLLER.locks[lock] = true
            tag:yep('+', G.C.MONEY, function()
                G.CONTROLLER.locks[lock] = nil
                return true
            end)
            ease_dollars((G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.tarot or 0) * tag.config.dollars_per_tarot)
            tag.triggered = true
            return true
        end
    end
}

SMODS.Tag {
    key = 'rocket',
    config = {
        dollars_per_planet = 2
    },
    pos = { 
        x = 1,
        y = 0
    },
    min_ante = 2,
    discovered = true,
    atlas = 'tags',
    loc_vars = function(self, info_queue, tag)
        return {vars = {tag.config.dollars_per_planet, tag.config.dollars_per_planet * (G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.planet or 0)}}
    end,

    apply = function(self, tag, context)
        if context.type == 'immediate' then
            local lock = tag.ID
            G.CONTROLLER.locks[lock] = true
            tag:yep('+', G.C.MONEY, function()
                G.CONTROLLER.locks[lock] = nil
                return true
            end)
            ease_dollars((G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.planet or 0) * tag.config.dollars_per_planet)
            tag.triggered = true
            return true
        end
    end
}

SMODS.Tag {
    key = 'wheel',
    config = {
    },
    pos = { 
        x = 2,
        y = 0
    },
    min_ante = 2,
    discovered = true,
    atlas = 'tags',
    loc_vars = function(self, info_queue, tag)
        return {vars = {}}
    end,

    apply = function(self, tag, context)
        if context.type == 'immediate' then
            local editionless_jokers = SMODS.Edition:get_edition_cards(G.jokers, true)
            if #editionless_jokers > 0 then
                tag:yep('+', G.C.ATTENTION, function()
                    local eligible_card = pseudorandom_element(editionless_jokers, 'wheel')
                    local edition = poll_edition('wheel', nil, false, true)
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                        eligible_card:set_edition(edition, true)
                        check_for_unlock({ type = 'have_edition' })
                        return true end
                    }))
                    return true
                end)
                tag.triggered = true
            else
                tag:nope()
            end
        end
    end
}
