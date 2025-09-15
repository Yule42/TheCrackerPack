--[[SMODS.Shader {
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
end--]]

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
    
    in_shop = true,
    weight = 10,
    extra_cost = 2,
    
    calculate = function(self, card, context)
        if context.end_of_round and context.cardarea == G.jokers and not context.repetition and not context.individual then
            card.ability.extra_value = card.ability.extra_value + self.config.extra.money
            card:set_cost()
            return {
                message = localize('k_val_up'),
                colour = G.C.MONEY
            }
        end
    end
}



SMODS.DrawStep {
    key = 'sleeved',
    order = 50,
    func = function(card)
        if card.edition and card.edition.cracker_sleeved and (card.config.center.discovered or card.bypass_discovery_center) then
            if not G.shared_sleeved_cracker then
                G.shared_sleeved_cracker = Sprite(0, 0, G.CARD_W, G.CARD_H, G.ASSET_ATLAS["cracker_enhancements"], { x = 8, y = 0 })
            end
            G.shared_sleeved_cracker.role.draw_major = card
            G.shared_sleeved_cracker:draw_shader('dissolve', 0, nil, nil, card.children.center)
            G.shared_sleeved_cracker:draw_shader('dissolve', nil, nil, nil, card.children.center)
        end
    end,
    conditions = { vortex = false, facing = 'front' },
}

SMODS.Shader {
  key = 'altered',
  path = 'altered.fs'
}

SMODS.Edition { -- Altered
    key = 'altered',
    shader = 'altered',
    
    config = {
        extra = {
            slots = 1,
        }
    },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.extra.slots } }
    end,
    weight = 7,
    in_shop = true,
    extra_cost = 3,
    
    
    on_apply = function(card)
        if card.ability.set == 'Joker' and G.consumeables then
            G.consumeables.config.card_limit = G.consumeables.config.card_limit + 1
        end
    end,
    
    on_remove = function(card)
        if card.ability.set == 'Joker' and G.consumeables then
            G.consumeables.config.card_limit = G.consumeables.config.card_limit - 1
        end
    end,
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
    weight = 1.5,
    in_shop = true,
    extra_cost = 5,
    
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