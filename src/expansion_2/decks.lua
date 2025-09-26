SMODS.Back{ -- Golden Deck
    name = "Golden Deck",
    key = "golden",
    
    pos = {
        x = 0,
        y = 0,
    },
    atlas = 'Backs',
    
    loc_vars = function(self, info_queue, center)
        return {vars = {
            localize{type = 'name_text', key = 'v_seed_money', set = 'Voucher'},
            localize{type = 'name_text', key = 'v_cracker_silver_spoon', set = 'Voucher'},
            localize{type = 'name_text', key = 'v_hone', set = 'Voucher'},
        }}
    end,
    config = {
        vouchers = {
            "v_seed_money",
            "v_cracker_silver_spoon",
            "v_hone",
        }
    },
}

SMODS.Back{ -- Consumer Deck
    name = "Consumer Deck",
    key = "consumer",
    
    pos = {
        x = 1,
        y = 0,
    },
    config = {
        requirement = 100,
        current_amount = 100,
    },
    atlas = 'Backs',
    
    loc_vars = function(self, info_queue, center)
        return {vars = {localize{type = 'name_text', key = 'tag_investment', set = 'Tag'}, G.GAME.selected_back.effect.config.requirement or self.config.requirement, G.GAME.selected_back.effect.config.current_amount or self.config.current_amount}}
    end,
    calculate = function(self, back, context)
        if context.money_altered and context.from_shop and context.amount < 0 then
            back.effect.config.current_amount = back.effect.config.current_amount + context.amount
            if back.effect.config.current_amount <= 0 then
                repeat
                    G.E_MANAGER:add_event(Event({
                        func = (function()
                            add_tag(Tag('tag_investment'))
                            play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                            play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                            return true
                        end)
                    }))
                    back.effect.config.current_amount = back.effect.config.current_amount + back.effect.config.requirement
                until back.effect.config.current_amount > 0
            end
        end
    end,
}

SMODS.Back{ -- Blitz Deck
    name = "Blitz Deck",
    key = "blitz",
    
    pos = {
        x = 2,
        y = 0,
    },
    atlas = 'Backs',
    
    loc_vars = function(self, info_queue, center)
        return {vars = {}}
    end,
    config = {
    },
    apply = function(self, back)
        G.GAME.modifiers.scaling = (G.GAME.modifiers.scaling or 1) + 1
        G.GAME.win_ante = 6
    end,
}

SMODS.Back{ -- Catalog Deck
    name = "Catalog Deck",
    key = "catalog",
    
    pos = {
        x = 4,
        y = 0,
    },
    atlas = 'Backs',
    
    loc_vars = function(self, info_queue, center)
        return {vars = {}}
    end,
    
    apply = function(self, back)
        G.GAME.modifiers.extra_boosters = (G.GAME.modifiers.extra_boosters or 0) + 1
        G.GAME.modifiers.extra_vouchers = (G.GAME.modifiers.extra_vouchers or 0) + 1
        change_shop_size(-1)
    end
}

SMODS.Back{ -- Patchwork Deck
    name = "Patchwork Deck", 
    key = "patchwork",
    
    pos = {
        x = 3,
        y = 0,
    },
    atlas = 'Backs',
    
    loc_vars = function(self, info_queue, center)
        return {vars = {}}
    end,
    
    apply = function(self, back)
        G.GAME.modifiers.voucher_override = 'patchwork_enabled'
        G.GAME.modifiers.voucher_restock_antes = 2
    end
}

--[[

SMODS.Back{ -- Test Deck
    name = "Test Deck", 
    key = "test",
    
    config = {
    },
    
    pos = {
        x = 5,
        y = 0,
    },
    atlas = 'Decks',
    
    loc_vars = function(self, info_queue, center)
        return {vars = {}}
    end,
    
    loc_txt = {
        name = 'Test Deck',
        text = {
            'reverse arcana packs are {C:attention}x5{} more common yay',
            '{C:inactive,s:1.25,E:1}why is this baby so bald'
        }
    },
}

SMODS.Back{ -- Gambling Deck
    name = "Gambler's Deck", 
    key = "gambler",
    
    config = {
        odds_double = 4,
        odds_no_money = 4,
        already_triggered = false
    },
    
    pos = {
        x = 6,
        y = 0,
    },
    atlas = 'Decks',
    
    loc_vars = function(self, info_queue, center)
        local new_numerator, new_denominator = SMODS.get_probability_vars(self, 1, self.config.odds_double, 'Gambler\'s Deck', false)
        local new_numerator_2, new_denominator_2 = SMODS.get_probability_vars(self, 1, self.config.odds_no_money, 'Gambler\'s Deck', false)
        return {vars = {new_numerator, new_denominator, new_numerator_2, new_denominator_2}}
    end,
    
    calculate = function(self, card, context)
        if context.money_altered and context.amount > 0 and not self.config.already_triggered then
            self.config.already_triggered = true -- prevent this joker from triggering from itself this isn't a joker
            if SMODS.pseudorandom_probability(self, 'Gambler\'s Deck', 1, self.config.odds_double, 'Gambler\'s Deck', true) then
                ease_dollars(context.amount)
                self.config.already_triggered = false
                return {
                    message = localize('k_winner')
                }
            elseif SMODS.pseudorandom_probability(self, 'Gambler\'s Deck', 1, self.config.odds_no_money, 'Gambler\'s Deck', true) then
                ease_dollars(-math.ceil(context.amount/2))
                self.config.already_triggered = false
                return {
                    message = localize('k_nope_ex')
                }
            end
            self.config.already_triggered = false
        end
    end,
}

SMODS.Back{ -- I'm afraid.
    name = "Gambler's Deck Part 2: Revenge of Stuff", 
    key = "gambler2",
    
    config = {
        odds_double = 5,
        odds_no_money = 5,
        already_triggered = false
    },
    
    pos = {
        x = 6,
        y = 0,
    },
    atlas = 'Decks',
    
    loc_vars = function(self, info_queue, center)
        local new_numerator, new_denominator = SMODS.get_probability_vars(self, 1, self.config.odds_double, 'Gambler\'s Deck', false, true)
        local new_numerator_2, new_denominator_2 = SMODS.get_probability_vars(self, 1, self.config.odds_no_money, 'Gambler\'s Deck', false, true)
        return {vars = {new_numerator, new_denominator, new_numerator_2, new_denominator_2}}
    end,
    
    calculate = function(self, card, context)
        if context.money_altered and context.amount > 0 and not self.config.already_triggered then
            self.config.already_triggered = true -- prevent this joker from triggering from itself this isn't a joker
            if SMODS.pseudorandom_probability(self, 'Gambler\'s Deck', 1, self.config.odds_double, 'Gambler\'s Deck', true, true) then
                ease_dollars(math.min(math.max(G.GAME.dollars, 0), 100))
                self.config.already_triggered = false
                return {
                    message = localize('k_winner')
                }
            elseif SMODS.pseudorandom_probability(self, 'Gambler\'s Deck', 1, self.config.odds_no_money, 'Gambler\'s Deck', true, true) then
                ease_dollars(-math.ceil(math.min(math.max(G.GAME.dollars/2, 0), 100)))
                self.config.already_triggered = false
                return {
                    message = localize('k_nope_ex')
                }
            end
            self.config.already_triggered = false
        end
    end,
}

local add_voucher_to_shop_ref = SMODS.add_voucher_to_shop
function SMODS.add_voucher_to_shop(...)
    if G.GAME.modifiers.every_other_ante then
        if math.fmod(G.GAME.round_resets.ante, 2) == 1 then
            return add_voucher_to_shop_ref(...)
        end
        return
    end
    return add_voucher_to_shop_ref(...)
end--]]
