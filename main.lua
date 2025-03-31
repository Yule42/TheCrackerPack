config = SMODS.current_mod.config

assert(SMODS.load_file('src/base_jokers.lua'))()
assert(SMODS.load_file('src/upgraded_food.lua'))()
assert(SMODS.load_file('src/voucher.lua'))()
assert(SMODS.load_file('src/challenge.lua'))()

assert(SMODS.load_file('src/expansion_1/card_jokers.lua'))()

CrackerConfig = SMODS.current_mod.config

--region Atlas
SMODS.Atlas {
    key = 'Jokers',
    path = "Jokers.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = 'Vouchers',
    path = "Vouchers.png",
    px = 71,
    py = 95
}

local food_jokers = {
    "j_gros_michel",
    "j_ice_cream",
    "j_cavendish",
    "j_turtle_bean",
    "j_diet_cola",
    "j_popcorn",
    "j_ramen",
    "j_selzer",
    "j_cracker_saltinecracker",
    "j_cracker_chocolatecoin",
    "j_cracker_grahamcracker",
    "j_cracker_cybernana",
    "j_cracker_buttpopcorn",
    "j_cracker_frozencustard",
    "j_cracker_hardseltzer",
    "j_cracker_curry",
    "j_cracker_canofbeans",
    "j_cracker_tsukemen",
    "j_cracker_cheese",
}

Cracker = {}
Cracker.food = {}

for i = 1, #food_jokers do
    Cracker.food[#Cracker.food+1] = food_jokers[i]
end

function Cracker.get_food(seed)
    local pool = get_current_pool('Joker')
    local food_keys = {}

    for k, v in pairs(Cracker.food) do  
        if not G.GAME.banned_keys[v] and G.P_CENTERS[v] then
            local found = false
            for num, text in pairs(pool) do
                if text == v then  -- compare the value, not the key
                    found = true
                    break
                end
            end
            if found then
                table.insert(food_keys, v)
            end
        end
    end
    if #food_keys <= 0 then
    return "j_joker"
    else
        return pseudorandom_element(food_keys, pseudoseed(seed))
    end
end



local igo = Game.init_game_object
Game.init_game_object = function(self)
    local ret = igo(self)
    ret.food_multiplier = 1
    
    return ret
end

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
                                text = "Directors: sugariimari, sophiedeergirl",
                                shadow = true,
                                scale = scale,
                                colour = G.C.SUITS.Hearts
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
                                text = "Art: palestjade, MrkySpices, amoryax, LumaHoneyy",
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
                                text = "Joker Ideas: sophiedeergirl, sugariimari, palestjade, brook03",
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
            label = "I like men",
            ref_table = CrackerConfig,
            ref_value = "starlo",
        }),
      },
    }
end