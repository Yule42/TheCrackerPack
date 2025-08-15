SMODS.Tag {
  key = 'interest',
    config = {
        interest = 1,
        interest_requirement = 5,
        interest_reset = 5,
    },
    atlas = 'tags',
    pos = { 
        x = 0,
        y = 0
    },
    discovered = false,
    in_pool = function(self, args)
        return false
    end,

    loc_vars = function(self, info_queue)
        return {vars = {self.config.interest, self.config.interest_requirement}}
    end,

    apply = function(self, tag, context)
        if context.type == 'eval' then
            if G.GAME.last_blind then
                tag:yep('+', G.C.GOLD, function()
                    return true
                end)
                self.config.interest_reset = G.GAME.interest_cap
                G.GAME.interest_cap = math.huge

                G.E_MANAGER:add_event(Event{
                    trigger = 'after',
                    delay = 0.0,
                    func = function()
                        G.GAME.interest_cap = self.config.interest_reset
                        return true
                    end
                })

                tag.triggered = true
            end
        end
    end
}