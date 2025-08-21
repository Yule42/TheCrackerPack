CrackerConfig = SMODS.current_mod.config

-- region smods settings

CrackerConfig.marquee = false

-- region load files

assert(SMODS.load_file('src/base_jokers.lua'))()
if not CrackerConfig.disable_upgradedfood then
    assert(SMODS.load_file('src/upgraded_food.lua'))()
end
assert(SMODS.load_file('src/voucher.lua'))()

if not CrackerConfig.disable_card then
    assert(SMODS.load_file('src/expansion_1/card_jokers.lua'))()
end

assert(SMODS.load_file('src/expansion_2/jokers.lua'))()
assert(SMODS.load_file('src/expansion_2/decks.lua'))()
assert(SMODS.load_file('src/expansion_2/deck_vouchers.lua'))()

assert(SMODS.load_file('src/expansion_3/reverse_arcana.lua'))()
assert(SMODS.load_file('src/expansion_3/tags.lua'))()
assert(SMODS.load_file('src/expansion_3/enhancements.lua'))()
assert(SMODS.load_file('src/expansion_3/editions.lua'))()
assert(SMODS.load_file('src/expansion_3/boosters.lua'))()

if JokerDisplay then
    assert(SMODS.load_file('src/compat/JokerDisplay.lua'))()
end

assert(SMODS.load_file('src/challenge.lua'))() -- load this last cause it references stuff from previous files

--region Atlas
SMODS.Atlas {
    key = 'Jokers',
    path = "Jokers.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = 'reversearcana',
    path = "reversearcana.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = 'modicon',
    px = 34,
    py = 34,
    path = 'modicon.png'
}

SMODS.Atlas {
    key = 'Vouchers',
    path = "Vouchers.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = 'Backs',
    path = "backs.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = 'pw_vouchers',
    path = "pw_vouchers.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = 'falcon',
    path = "falcon.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = 'tags',
    path = "tags.png",
    px = 34,
    py = 34
}

SMODS.Atlas {
    key = 'enhancements',
    path = "enhancements.png",
    px = 71,
    py = 95
}

SMODS.Atlas{
    key = 'booster',
    path = 'boosters.png',
    px = 71,
    py = 95
}

-- region declare variables

G.C.Cracker = {}
G.C.Cracker.reversetarot = HEX("845baa")
G.C.Cracker.Dissolve = {
    reversetarot = G.C.Cracker.reversetarot,
}

Cracker.vanilla_food = {
  j_gros_michel = true,
  j_ice_cream = true,
  j_cavendish = true,
  j_turtle_bean = true,
  j_diet_cola = true,
  j_popcorn = true,
  j_ramen = true,
  j_selzer = true,
  j_egg = true,
}

Cracker.base_rarities = {
  "Common",
  "Uncommon",
  "Rare",
  "Legendary"
}

-- Initialize pool of food jokers if it doesn't exist already, which may be created by other mods.
-- Any joker can add itself to this pool by adding pools = { Food = true } to its code
-- Credits to Cryptid for the idea and Paperback for this code
if not SMODS.ObjectTypes.Food then
  SMODS.ObjectType {
    key = 'Food',
    default = 'j_joker',
    cards = {},
    inject = function(self)
      SMODS.ObjectType.inject(self)
      -- Insert base game food jokers
      for k, _ in pairs(Cracker.vanilla_food) do
        self:inject_card(G.P_CENTERS[k])
      end
    end
  }
end

-- region declare functions
function Cracker.mostplayedhand() -- Balatro doesn't update G.GAME.current_round.most_played_poker_hand so
    if not G.GAME or not G.GAME.current_round then 
        return 'High Card'
    end
    local chosen_hand = 'High Card'
    local _handname, _played, _order = 'High Card', -1, 0
    for k, v in pairs(G.GAME.hands) do
        if v.played > _played or (v.played == _played and _order > v.order) then 
            _order = v.order
            _played = v.played
            _handname = k
        end
    end
    chosen_hand = _handname
    return chosen_hand
end

function Cracker.get_ordered_list_of_hands()
    local hands = {}

    for _, v in ipairs(G.P_CENTER_POOLS.Planet) do
        if v.config and v.config.hand_type then
            local hand = G.GAME.hands[v.config.hand_type]

            if hand and hand.visible then
                hands[#hands+1] = {
                    key = v.config.hand_type,
                    hand = hand,
                    planet_key = v.key
                }
            end
        end
    end

    table.sort(hands, function(a, b)
        if a.hand.played ~= b.hand.played then
            return a.hand.played > b.hand.played
        end
        return a.hand.order < b.hand.order
    end)

     return hands
end

function Cracker.is_in_consumeables(key)
    for _, card in ipairs(G.consumeables.cards) do
        if card.config.center_key == key then
            return true
        end
    end
    return false
end

function Cracker.is_in_array(key, current_index, array)
    for k, v in ipairs(array) do
        if k ~= current_index and v == key then
            return true
        end
    end
    return false
end

-- Code modified from Paperback 
---@param card table | string a center key or a card
---@return boolean
function Cracker.is_food(card)
    if not card then
        return false
    else
        local center = type(card) == "string"
            and G.P_CENTERS[card]
            or (card.config and card.config.center)

        if not center then
            return false
        end
        -- If the center has the Food pool in its definition
        if center.pools and center.pools.Food then
            return true
        end
    end
end

-- Tailsman Compat (fake)

to_big = to_big or function(x)
  return x
end

to_number = to_number or function(n)
  return n
end



-- region Hooks

local igo = Game.init_game_object
Game.init_game_object = function(self)
    local ret = igo(self)
    ret.food_multiplier = 1
    
    return ret
end

local remove_ref = Card.remove
function Card.remove(self)
    if self.added_to_deck and self.ability.set == 'Joker' and not G.CONTROLLER.locks.selling_card and not self.getting_sliced and Cracker.is_food(self.config.center_key) then
        SMODS.calculate_context({
            self_destroying_food_joker = true,
            destroyed_joker = self
        })
    end

    return remove_ref(self)
end

local cref = set_consumeable_usage
function set_consumeable_usage(card)
    if card.config.center_key and card.ability.consumeable and card.config.center.set == 'Spectral' and not card.config.center.hidden then
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = function()
                        G.GAME.last_spectral = card.config.center_key
                        return true
                    end
                }))
                return true
            end
        }))
    end
    return cref(card)
end

-- extra tabs
SMODS.current_mod.extra_tabs = function() --Credits
    local scale = 0.4
    return {
        label = "Credits",
        tab_definition_function = function()
        return {
            n = G.UIT.ROOT,
            config = {
                align = "cm",
                padding = 0.05,
                colour = G.C.CLEAR,
            },
            nodes = {
                {
                    n = G.UIT.R,
                    config = {
                        padding = 0,
                        align = "cm"
                    },
                    nodes = {
                        {
                            n = G.UIT.T,
                            config = {
                                text = "Directors: sugariimarii, sophiedeergirl",
                                shadow = true,
                                scale = scale,
                                colour = G.C.GREEN
                            }
                        }
                    }
                },
                {
                    n = G.UIT.R,
                    config = {
                        padding = 0,
                        align = "cm"
                    },
                    nodes = {
                        {
                            n = G.UIT.T,
                            config = {
                                text = "Art: palestjade, MrkySpices, amoryax, LumaHoneyy, vyletbunni, wombatcountry",
                                shadow = true,
                                scale = scale,
                                colour = G.C.BLUE
                            }
                        },
                    }
                },
                {
                    n = G.UIT.R,
                    config = {
                        padding = 0,
                        align = "cm"
                    },
                    nodes = {
                        {
                            n = G.UIT.T,
                            config = {
                                text = "Programming: sophiedeergirl, I'm an issue",
                                shadow = true,
                                scale = scale,
                                colour = G.C.GREEN
                            }
                        }
                    },
                },
                {
                    n = G.UIT.R,
                    config = {
                        padding = 0,
                        align = "cm"
                    },
                    nodes = {
                        {
                            n = G.UIT.T,
                            config = {
                                text = "Testing: brook03",
                                shadow = true,
                                scale = scale,
                                colour = G.C.MONEY
                            }
                        }
                    },
                },
                {
                    n = G.UIT.R,
                    config = {
                        padding = 0,
                        align = "cm"
                    },
                    nodes = {
                        {
                            n = G.UIT.T,
                            config = {
                                text = "Joker Ideas: sophiedeergirl, sugariimarii, palestjade, brook03, plebmiester",
                                shadow = true,
                                scale = scale,
                                colour = G.C.SECONDARY_SET.Spectral
                            }
                        }
                    },
                },
            }
        }
        end
    }
end

SMODS.current_mod.config_tab = function() --Config
    return {
      n = G.UIT.ROOT,
      config = {
        align = "cm",
        padding = 0.05,
        colour = G.C.CLEAR,
      },
      nodes = {
        {
            n = G.UIT.R,
            config = {
                padding = 0,
                align = "cm"
            },
            nodes = {
                {
                    n = G.UIT.T,
                    config = {
                        text = "All changes require a restart.",
                        shadow = true,
                        scale = 0.5,
                        colour = G.C.SECONDARY_SET.Enhanced
                    }
                },
            }
        },
        create_toggle({
            label = "Disable Card Pack",
            ref_table = CrackerConfig,
            ref_value = "disable_card",
        }),
        create_toggle({
            label = "Disable Upgraded Food Jokers",
            ref_table = CrackerConfig,
            ref_value = "disable_upgradedfood",
        }),
        create_toggle({
            label = "Disable Tier 3 Vouchers",
            ref_table = CrackerConfig,
            ref_value = "disable_tier3",
        }),
        create_toggle({
            label = "Dev Textures",
            ref_table = CrackerConfig,
            ref_value = "starlo",
        }),
      },
    }
end