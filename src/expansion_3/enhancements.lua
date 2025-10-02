SMODS.Enhancement { -- Cheater
    key = 'cheater',
    atlas = 'enhancements',
    pos = {
        x = 0,
        y = 0
    },
    
    config = {
        extra = {
            x_mult = 4,
            dollars = 5,
            mult_odds = 10,
            dollars_odds = 5,
            cheater_trigger = nil,
        }
    },
    
    loc_vars = function(self, info_queue, card)
        local mult_numerator, mult_denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.mult_odds, 'cheater_x_mult')
        local dollars_numerator, dollars_denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.dollars_odds, 'cheater_money')
        return { vars = { mult_numerator, dollars_numerator, card.ability.extra.x_mult, mult_denominator, card.ability.extra.dollars, dollars_denominator } }
    end,
    
    in_pool = function(self, args)
        return false
    end,
    
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            local ret = {}
            if SMODS.pseudorandom_probability(card, 'cheater_x_mult', 1, card.ability.extra.mult_odds) then
                card.cheater_trigger = true
                ret.Xmult = card.ability.extra.x_mult
            end
            if SMODS.pseudorandom_probability(card, 'cheater_money', 1, card.ability.extra.dollars_odds) then
                card.cheater_trigger = true
                ret.dollars = card.ability.extra.dollars
            end
            
            return ret
        elseif context.after and not context.repetition then
            card.cheater_trigger = nil
        end
    end,
}

SMODS.Enhancement { -- Multi
    key = 'multi',
    atlas = 'enhancements',
    pos = {
        x = 1,
        y = 0
    },
    
    config = {
        perma_mult = 2,
        extra = {
            mult_base = 2,
            mult_add = 2,
        }
    },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult_base, card.ability.extra.mult_add }, key = card.fake_card and "m_cracker_multi_alt" or nil }
    end,
    
    in_pool = function(self, args)
        return false
    end,
    
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            card.ability.perma_mult = card.ability.perma_mult + card.ability.extra.mult_add
            return {
                extra = { message = localize('k_upgrade_ex'), colour = G.C.MULT },
                card = card
            }
        end
    end,
}

SMODS.Enhancement { -- Sequenced
    key = 'sequenced',
    atlas = 'enhancements',
    pos = {
        x = 2,
        y = 0
    },
    
    config = {
        perma_bonus = 15,
        extra = {
            bonus_base = 15,
            bonus_add = 5,
        }
    },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.bonus_base, card.ability.extra.bonus_add }, key = card.fake_card and "m_cracker_sequenced_alt" or nil }
    end,
    
    in_pool = function(self, args)
        return false
    end,
    
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            card.ability.perma_bonus = card.ability.perma_bonus + card.ability.extra.bonus_add
            return {
                extra = { message = localize('k_upgrade_ex'), colour = G.C.CHIPS },
                card = card
            }
        end
    end,
}

SMODS.Enhancement { -- Mild
    key = 'mild',
    atlas = 'enhancements',
    pos = {
        x = 3,
        y = 0
    },
    
    config = {
        extra = {
        }
    },
    
    loc_vars = function(self, info_queue, card)
        return { vars = {  } }
    end,
    
    in_pool = function(self, args)
        return false
    end,
    
    update = function(self, card, dt) -- eurethra!
        if card.debuff then
            card.debuff = false
        end
    end,
}

SMODS.Enhancement { -- Scrap
    key = 'scrap_metal',
    atlas = 'enhancements',
    pos = {
        x = 4,
        y = 0
    },
    
    config = {
        Xmult = 1.5,
    },
    
    in_pool = function(self, args)
        return false
    end,
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.Xmult } }
    end,
}
SMODS.Enhancement { -- Annealed
    key = 'annealed',
    atlas = 'enhancements',
    pos = {
        x = 5,
        y = 0
    },
    
    config = {
        h_x_mult = 3,
        extra = {
            odds = 3,
        }
    },
    
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'annealed')
        return { vars = { card.ability.h_x_mult, numerator, denominator } }
    end,
    
    in_pool = function(self, args)
        return false
    end,
    
    calculate = function(self, card, context)
        if context.destroy_card and context.cardarea == G.hand and context.destroy_card == card and
            SMODS.pseudorandom_probability(card, 'annealed', 1, card.ability.extra.odds) then
            return { remove = true }
        end
    end,
}

SMODS.Enhancement { -- Silver
    key = 'silver',
    atlas = 'enhancements',
    pos = {
        x = 6,
        y = 0
    },
    
    config = {
        extra = {
            dollars = 2,
        }
    },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.dollars } }
    end,
    
    in_pool = function(self, args)
        return false
    end,
    
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.main_scoring then
            return {
                dollars = card.ability.extra.dollars
            }
        end
    end,
}

SMODS.Enhancement { -- Soil
    key = 'soil',
    atlas = 'enhancements',
    pos = {
        x = 7,
        y = 0
    },
    no_rank = true,
    no_suit = true,
    always_scores = true,
    replace_base_card = true,
    in_pool = function(self, args)
        return false
    end,
    
    config = {
        mult = 10,
    },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.mult } }
    end,
}
