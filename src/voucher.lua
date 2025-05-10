SMODS.Voucher {
    key = 'silver_spoon',
    loc_txt = {
        ['name'] = 'Silver Spoon',
        ['text'] = {
            [1] = 'Earn {C:money}$#1#{}',
            [2] = 'at end of round',
        }
    },
    pos = {
        x = 0,
        y = 0
    },
    unlocked = true,
    discovered = true,
    atlas = 'Vouchers',
    config = {
        extra = {
            money = 2,
        }
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.money}}
    end,
    
    calc_dollar_bonus = function(self, card)
        local bonus = card.ability.extra.money
        if bonus > 0 then return bonus end
    end,
}

SMODS.Voucher {
    key = 'heirloom',
    loc_txt = {
        ['name'] = 'Heirloom',
        ['text'] = {
            [1] = 'Earn {C:money}$#1#{}',
            [2] = 'at end of round',
        }
    },
    pos = {
        x = 1,
        y = 0
    },
    unlocked = true,
    discovered = true,
    atlas = 'Vouchers',
    config = {
        extra = {
            money = 3,
        }
    },
    requires = { "v_cracker_silver_spoon" },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.money}}
    end,
    calc_dollar_bonus = function(self, card)
        local bonus = card.ability.extra.money
        if bonus > 0 then return bonus end
    end,
}

SMODS.Voucher {
    key = 'clowncar',
    loc_txt = {
        ['name'] = 'Clown Car',
        ['text'] = {
            [1] = '{C:green}Uncommon Jokers{}',
            [2] = 'appear 40% more often',
        }
    },
    pos = {
        x = 4,
        y = 0
    },
    unlocked = true,
    discovered = true,
    atlas = 'Vouchers',
    config = {
        extra = {
            weight_mod = 1.4,
        }
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.weight_mod}}
    end,
    redeem = function(self)
        G.GAME["uncommon"..'_mod'] = self.config.extra.weight_mod
    end,
}

SMODS.Voucher {
    key = 'busfullofclowns',
    loc_txt = {
        ['name'] = 'Bus Full o\' Clowns',
        ['text'] = {
            [1] = '{C:red}Rare Jokers{}',
            [2] = 'appear twice as often',
        }
    },
    pos = {
        x = 5,
        y = 0
    },
    unlocked = true,
    discovered = true,
    atlas = 'Vouchers',
    config = {
        extra = {
            weight_mod = 2,
        }
    },
    requires = { "v_cracker_clowncar" },
    loc_vars = function(self, info_queue, card)
        return {vars = {}}
    end,
    redeem = function(self)
        G.GAME["rare"..'_mod'] = self.config.extra.weight_mod
    end,
}

if not CrackerConfig.disable_tier3 then
    SMODS.Voucher {
        key = 'cheese_touch',
        loc_txt = {
            ['name'] = 'Cheese Touch',
            ['text'] = {
                [1] = 'Permanently',
                [2] = 'gain {C:blue}+#1#{} hands',
                [3] = 'per round',
            }
        },
        pos = {
            x = 2,
            y = 0
        },
        unlocked = true,
        discovered = true,
        atlas = 'Vouchers',
        config = {
            extra = {
                hands = 1,
            }
        },
        requires = { "v_nacho_tong" },
        loc_vars = function(self, info_queue, card)
            return {vars = {card.ability.extra.hands}}
        end,
        
        redeem = function(self)
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.GAME.round_resets.hands = G.GAME.round_resets.hands + self.config.extra.hands
                    ease_hands_played(self.config.extra.hands)
                    return true
                end,
            }))
        end
    }

    SMODS.Voucher {
        key = 'dumpster',
        loc_txt = {
            ['name'] = 'Dumpster',
            ['text'] = {
                [1] = 'Permanently',
                [2] = 'gain {C:red}+#1#{} discard',
                [3] = 'each round',
            }
        },
        pos = {
            x = 3,
            y = 0
        },
        unlocked = true,
        discovered = true,
        atlas = 'Vouchers',
        config = {
            extra = {
                discards = 1,
            }
        },
        requires = { "v_recyclomancy" },
        loc_vars = function(self, info_queue, card)
            return {vars = {card.ability.extra.discards}}
        end,
        
        redeem = function(self)
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.GAME.round_resets.discards = G.GAME.round_resets.discards + self.config.extra.discards
                    ease_discard(self.config.extra.discards)
                    return true
                end,
            }))
        end
    }
end