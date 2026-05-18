SMODS.Shader {
  key = 'prismatic',
  path = 'prismatic.fs'
}

SMODS.Sound {
    key = "prismatic",
    path = 'prismatic.ogg',
}

SMODS.Edition { -- Altered
    key = 'prismatic',
    shader = 'prismatic',
    
    config = {
        extra = {
            slots = 1,
        }
    },
    sound = { sound = "cracker_prismatic", per = 1.0, vol = 0.7 },
    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.extra.slots } }
    end,
    weight = 3,
    in_shop = true,
    extra_cost = 5,
    on_apply = function(card)
        if (card.ability.set == 'Joker' and card.area == G.jokers) and G.consumeables then
            G.hand.config.card_limit = G.hand.config.card_limit + 1
        end
    end,
    on_remove = function(card)
        if (card.ability.set == 'Joker' and card.area == G.jokers) and G.consumeables then
            G.hand.config.card_limit = G.hand.config.card_limit - 1
        end
    end,
    --[[update = function(self, card)
        if not card.cracker_prismatic_active and not card.debuff and card.area and card.area == G.hand then 
            G.hand.config.card_limit = G.hand.config.card_limit + 1
            card.cracker_prismatic_active = true
        end

        if card.cracker_prismatic_active and card.area and card.area ~= G.hand then 
            G.hand.config.card_limit = G.hand.config.card_limit - 1
            card.cracker_prismatic_active = false
        end
    end,--]]
}

-- Code shamelessly ripped from Paperback
-- Prevent Prismatic edition from appearing on playing cards
local poll_edition_ref = poll_edition
function poll_edition(_key, _mod, _no_neg, _guaranteed, _options)
  local removed, pos

  if _no_neg then
    for i, v in ipairs(G.P_CENTER_POOLS.Edition) do
      if v.key == 'e_cracker_prismatic' then
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
    if self and self.edition and self.edition.cracker_prismatic then
        G.hand.config.card_limit = G.hand.config.card_limit + 1
    end
    
    add_to_deck_ref(self, from_debuff)
end

local remove_from_deck_ref = Card.remove_from_deck

function Card:remove_from_deck(from_debuff)
    if self and self.edition and self.edition.cracker_prismatic and self.added_to_deck then
        G.hand.config.card_limit = G.hand.config.card_limit - 1
    end
    
    remove_from_deck_ref(self, from_debuff)
end

SMODS.Tag {
    key = "prismatic",
    min_ante = 2,
    discovered = true,
    pos = { x = 5, y = 0 },
    atlas = 'tags',
    loc_vars = function(self, info_queue, tag)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_cracker_prismatic
    end,
    apply = function(self, tag, context)
        if context.type == 'store_joker_modify' then
            if not context.card.edition and not context.card.temp_edition and context.card.ability.set == 'Joker' then
                local lock = tag.ID
                G.CONTROLLER.locks[lock] = true
                context.card.temp_edition = true
                tag:yep('+', G.C.DARK_EDITION, function()
                    context.card.temp_edition = nil
                    context.card:set_edition("e_cracker_prismatic", true)
                    context.card.ability.couponed = true
                    context.card:set_cost()
                    G.CONTROLLER.locks[lock] = nil
                    return true
                end)
                tag.triggered = true
                return true
            end
        end
    end,
    in_pool = function(self, args)
        return G.P_CENTERS["e_cracker_prismatic"].discovered
    end
}

SMODS.Consumable {
    key = 'abyss',
    set = 'Spectral',
    pos = { x = 0, y = 0 },
    atlas = 'spectral',
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_cracker_prismatic
        return { vars = { 1 } }
    end,
    use = function(self, card, area, copier)
        local editionless_jokers = SMODS.Edition:get_edition_cards(G.jokers, true)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                local eligible_card = pseudorandom_element(editionless_jokers, 'Cracker Abyss')
                eligible_card:set_edition("e_cracker_prismatic")

                G.consumeables:change_size(-1)

                card:juice_up(0.3, 0.5)
                return true
            end
        }))
    end,
    can_use = function(self, card)
        return next(SMODS.Edition:get_edition_cards(G.jokers, true)) and #G.consumeables.cards <= (G.consumeables.config.card_limit - (card.area == G.consumeables and 0 or 1))
    end,
}
