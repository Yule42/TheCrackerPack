CardSleeves.Sleeve {
    key = "blitz",
    name = "Blitz Sleeve",
    atlas = "sleeves",
    pos = { x = 2, y = 0 },
    unlocked = true,
    config = { },
    --unlock_condition = { deck = "b_cracker_rebate", stake = "stake_blue" },
    loc_vars = function(self)
        return { vars = { } }
    end,
    apply = function(self)
        G.GAME.modifiers.no_small_blind = true
        G.GAME.modifiers.scaling = (G.GAME.modifiers.scaling or 1) - 0.25
        if G.GAME.modifiers.scaling < 1 then G.GAME.modifiers.scaling = 1 end
        G.GAME.round_resets.blind_states["Small"] = "Hide"
    end,
}

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
        G.GAME.sleeve_key.rebate = G.GAME.sleeve_key.rebate or { current_amount = self.config.current_amount, requirement = self.config.requirement }
    end,
    trigger_effect = function(self, context)
        if context.money_altered and context.from_shop and context.amount < 0 then
            G.GAME.sleeve_key.rebate.current_amount = G.GAME.sleeve_key.rebate.current_amount + context.amount
            if G.GAME.sleeve_key.rebate.current_amount <= 0 then
                while G.GAME.sleeve_key.rebate.current_amount <= 0 do
                    G.GAME.sleeve_key.rebate.current_amount = G.GAME.sleeve_key.rebate.current_amount + G.GAME.sleeve_key.rebate.requirement
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
                                --SMODS.calculate_effect({message = localize("k_plus_tarot"), colour = G.C.FILTER}, G.GAME.selected_back)
                                return true
                            end)
                        }))
                        return nil, true
                    end
                end
            end
        end
    end
}

CardSleeves.Sleeve {
    key = "card_pack",
    name = "Card Pack Testing Sleeve",
    atlas = "sleeves",
    pos = { x = 0, y = 0 },
    unlocked = true,
    config = { },
    --unlock_condition = { deck = "b_cracker_rebate", stake = "stake_blue" },
    loc_vars = function(self)
        self.config = { voucher = 'v_cracker_card_pack' }
        local vars = { localize{type = 'name_text', key = self.config.voucher, set = 'Voucher'} }
        return { key = key, vars = vars }
    end,
}
