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
        return { vars = { self.config.extra.money }, key = (card and card.ability and (card.ability.set == "Default" or card.ability.set == "Enhanced")) and "e_cracker_sleeved_playing" or "e_cracker_sleeved" }
    end,
    
    in_shop = true,
    weight = 10,
    extra_cost = 2,
    
    calculate = function(self, card, context)
        if context.end_of_round then
            if context.playing_card_end_of_round and context.cardarea == G.hand then
                card.ability.perma_d_dollars = card.ability.perma_d_dollars or 0 + self.config.extra.money
                return {
                    message = localize('k_val_up'),
                    colour = G.C.MONEY
                }
            elseif context.cardarea == G.jokers and not context.repetition and not context.individual then
                card.ability.extra_value = card.ability.extra_value + self.config.extra.money
                card:set_cost()
                return {
                    message = localize('k_val_up'),
                    colour = G.C.MONEY
                }
            end
        end
    end
}



SMODS.DrawStep { -- this doesnt work with nonstandard joker sizes but that's okay for now
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
        if (card.ability.set == 'Joker' and card.area == G.jokers) and G.consumeables then
            G.consumeables.config.card_limit = G.consumeables.config.card_limit + 1
        end
    end,
    on_remove = function(card)
        if (card.ability.set == 'Joker' and card.area == G.jokers) and G.consumeables then
            G.consumeables.config.card_limit = G.consumeables.config.card_limit - 1
        end
    end,
    --[[update = function(self, card)
        if not card.cracker_altered_active and not card.debuff and card.area and card.area == G.hand then 
            G.consumeables.config.card_limit = G.consumeables.config.card_limit + 1
            card.cracker_altered_active = true
        end

        if card.cracker_altered_active and card.area and card.area ~= G.hand then 
            G.consumeables.config.card_limit = G.consumeables.config.card_limit - 1
            card.cracker_altered_active = false
        end
    end,--]]
}

-- Code shamelessly ripped from Paperback
-- Prevent Altered edition from appearing on playing cards
local poll_edition_ref = poll_edition
function poll_edition(_key, _mod, _no_neg, _guaranteed, _options)
  local removed, pos

  if _no_neg then
    for i, v in ipairs(G.P_CENTER_POOLS.Edition) do
      if v.key == 'e_cracker_altered' then
        pos = i
        removed = table.remove(G.P_CENTER_POOLS.Edition, i)
        break
      end
    end
  end

  local ret = poll_edition_ref(_key, _mod, _no_neg, _guaranteed, _options)

  if _no_neg and removed and pos then
    table.insert(G.P_CENTER_POOLS.Edition, pos, removed)
  end

  return ret
end

local add_to_deck_ref = Card.add_to_deck

function Card:add_to_deck(from_debuff)
    if self and self.edition and self.edition.cracker_altered then
        G.consumeables.config.card_limit = G.consumeables.config.card_limit + 1
    end
    
    add_to_deck_ref(self, from_debuff)
end

local remove_from_deck_ref = Card.remove_from_deck

function Card:remove_from_deck(from_debuff)
    if self and self.edition and self.edition.cracker_altered and self.added_to_deck then
        G.consumeables.config.card_limit = G.consumeables.config.card_limit - 1
    end
    
    remove_from_deck_ref(self, from_debuff)
end

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
        if context.post_joker or (context.main_scoring and context.cardarea == G.play) then
            return {
                chips = self.config.extra.chips,
                mult = self.config.extra.mult,
                x_mult = self.config.extra.x_mult,
            }
        end
    end
}