SMODS.Tag{
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
    discovered = true,
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

SMODS.Tag{
  key = 'curse',
    config = {
    },
    atlas = 'tags',
    pos = { 
        x = 1,
        y = 0
    },
    discovered = true,

    loc_vars = function(self, info_queue)
        return {vars = {self.config.interest, self.config.interest_requirement}}
    end,

    apply = function(self, tag, context)
        if context.type == 'new_blind_choice' then
            local lock = tag.ID
            G.CONTROLLER.locks[lock] = true
            tag:yep('+', G.C.PURPLE, function()
                local booster = SMODS.create_card{ key = 'p_cracker_reverse_arcana_mega_' .. math.random(1, 2), area = G.play }
                booster.T.x = G.play.T.x + G.play.T.w / 2 - G.CARD_W * 1.27 / 2
                booster.T.y = G.play.T.y + G.play.T.h / 2 - G.CARD_H * 1.27 / 2
                booster.T.w = G.CARD_W * 1.27
                booster.T.h = G.CARD_H * 1.27
                booster.cost = 0
                booster.from_tag = true
                G.FUNCS.use_card({ config = { ref_table = booster } })
                booster:start_materialize()
                G.CONTROLLER.locks[lock] = nil
                return true
            end)
            tag.triggered = true
            return true
        end
    end
}