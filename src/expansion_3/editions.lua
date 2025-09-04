SMODS.Shader {
  key = 'laminated',
  path = 'laminated.fs'
}

SMODS.Edition { -- Laminated
    key = 'laminated',
    shader = 'laminated',
    
    config = {
        extra = {
        }
    },
    weight = 20,
    
    loc_vars = function(self, info_queue, card)
        return { vars = { } }
    end,
    
    in_shop = false,
    on_apply = function(card)
        if card.debuff then
            card.debuff = false
            if card.area == G.jokers then card:add_to_deck(true) end
        end
    end,
    calculate = function(self, card, context)
        if context.check_eternal and context.other_card == card then
            return {
                no_destroy = {
                    override_compat = true
                }
            }
        end
    end
}

local cscr = Card.can_sell_card
function Card:can_sell_card(context)
    local ref = cscr(self, context)
    local can_sell = self.ability.set == 'Joker' and self.edition and self.edition.cracker_laminated and not self.ability.eternal
    if not ref and can_sell then
        return true
    end
    return ref
end

SMODS.Edition { -- Sleeved
    key = 'sleeved',
    shader = false,
    
    config = {
        extra = {
            money = 2,
        }
    },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.extra.money } }
    end,
    
    in_shop = false,
    weight = 14,
    
    calculate = function(self, card, context)
        if context.end_of_round and context.cardarea == G.jokers and not context.repetition and not context.individual then
            card.ability.extra_value = card.ability.extra_value + self.config.extra.money
            card:set_cost()
        end
    end
}

SMODS.DrawStep {
    key = 'sleeved',
    order = 50,
    func = function(card)
        if card.edition and card.edition.cracker_sleeved and (card.config.center.discovered or card.bypass_discovery_center) then
            G.shared_soul.role.draw_major = card
            G.shared_soul:draw_shader('dissolve', 0, nil, nil, card.children.center)
            G.shared_soul:draw_shader('dissolve', nil, nil, nil, card.children.center)
        end
    end,
    conditions = { vortex = false, facing = 'front' },
}

SMODS.Edition { -- Crystalline
    key = 'crystalline',
    shader = 'booster',
    
    config = {
        extra = {
            chips = 25,
            mult = 5,
            x_mult = 1.25
        }
    },
    prefix_config = {
        shader = false,
    },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.extra.chips, self.config.extra.mult, self.config.extra.x_mult } }
    end,
    weight = 3,
    
    in_shop = false,
    
    calculate = function(self, card, context)
        if context.edition and context.cardarea == G.jokers and context.joker_main then
            return {
                chips = self.config.extra.chips,
                mult = self.config.extra.mult,
                x_mult = self.config.extra.x_mult,
            }
        end
        if context.cardarea == G.play and context.main_scoring then
            return {
                chips = self.config.extra.chips,
                mult = self.config.extra.mult,
                x_mult = self.config.extra.x_mult,
            }
        end
    end
}