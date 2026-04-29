SMODS.Back{ -- White Deck
    key = "white",
    pos = {
        x = 5,
        y = 0,
    },
    atlas = 'Backs',
    loc_vars = function(self, info_queue, center)
        return {vars = {}}
    end,
    config = { hands = -1 },
    calculate = function(self, back, context)
        if context.setting_blind and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                func = (function()
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            SMODS.add_card {
                                set = 'Tarot',
                                key_append = 'white_deck'
                            }
                            G.GAME.consumeable_buffer = 0
                            return true
                        end
                    }))
                    SMODS.calculate_effect({ message = localize('k_plus_tarot'), colour = G.C.TAROT }, G.deck.cards[1] or G.deck)
                    return true
                end)
            }))
        end
    end
}

SMODS.Back{ -- White Deck 2
    key = "white_2",
    pos = {
        x = 5,
        y = 0,
    },
    atlas = 'Backs',
    loc_vars = function(self, info_queue, center)
        return {vars = {}}
    end,
    config = { hands = -1, discards = 1 },
    calculate = function(self, back, context)
        if context.setting_blind and context.blind.boss then
            G.E_MANAGER:add_event(Event({
                func = (function()
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            SMODS.add_card {
                                set = 'Spectral',
                                key_append = 'white_deck',
                                edition = 'e_negative'
                            }
                            return true
                        end
                    }))
                    SMODS.calculate_effect({ message = localize('k_plus_spectral'), colour = G.C.SECONDARY_SET.Spectral }, G.deck.cards[1] or G.deck)
                    return true
                end)
            }))
        end
    end
}
