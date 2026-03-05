CardSleeves.Sleeve {
    key = "rebate",
    name = "Rebate Sleeve",
    atlas = "sleeves",
    pos = { x = 1, y = 0 },
    unlocked = true,
    config = { requirement = 15, current_amount = 15 },
    --unlock_condition = { deck = "b_cracker_rebate", stake = "stake_blue" },
    loc_vars = function(self)
        local amt = self.config.current_amount
        if G.GAME.sleeve_key and G.GAME.sleeve_key.rebate then
            amt = G.GAME.sleeve_key.rebate.current_amount
        end
        return { vars = { self.config.requirement, amt } }
    end,
    apply = function(self)
        G.GAME.sleeve_key = G.GAME.sleeve_key or {}
        G.GAME.sleeve_key.rebate = G.GAME.sleeve_key.rebate or { current_amount = self.config.current_amount }
    end,
    trigger_effect = function(self, context)
        if context.money_altered and context.from_shop and context.amount < 0 then
            G.GAME.sleeve_key.rebate.current_amount = G.GAME.sleeve_key.rebate.current_amount + context.amount
            if G.GAME.sleeve_key.rebate.current_amount <= 0 then
                repeat
                    G.GAME.sleeve_key.rebate.current_amount = G.GAME.sleeve_key.rebate.current_amount + self.config.requirement
                    if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                        G.E_MANAGER:add_event(Event({
                            func = (function()
                                G.E_MANAGER:add_event(Event({
                                    func = function()
                                        SMODS.add_card {
                                            set = 'Tarot',
                                            key_append = 'rebate_sleeve'
                                        }
                                        G.GAME.consumeable_buffer = 0
                                        return true
                                    end
                                }))
                                return {
                                    message = localize('k_plus_tarot'),
                                    colour = G.C.FILTER
                                }
                            end)
                        }))
                        return nil, true
                    end
                until G.GAME.sleeve_key.rebate.current_amount > 0
                return {
                    message = localize('k_rebate'),
                    colour = G.C.FILTER
                }
            else
                return {
                    message = ''..G.GAME.sleeve_key.rebate.current_amount,
                    colour = G.C.FILTER
                }
            end
        end
    end
}
