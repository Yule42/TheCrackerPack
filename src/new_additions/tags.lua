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
