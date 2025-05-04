CrackerConfig = SMODS.current_mod.config

assert(SMODS.load_file('src/base_jokers.lua'))()
if not CrackerConfig.disable_upgradedfood then
    assert(SMODS.load_file('src/upgraded_food.lua'))()
end
assert(SMODS.load_file('src/voucher.lua'))()
assert(SMODS.load_file('src/challenge.lua'))()

if not CrackerConfig.disable_card then
    assert(SMODS.load_file('src/expansion_1/card_jokers.lua'))()
end

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

-- these are a few mods with food jokers i could think of off the cuff
-- freezer still lacks cross-compatiblity though

if next(SMODS.find_mod('paperback')) then
    Cracker.food[#Cracker.food+1] = "j_paperback_apple"
    Cracker.food[#Cracker.food+1] = "j_paperback_joker_cookie"
    Cracker.food[#Cracker.food+1] = "j_paperback_nachos"
    Cracker.food[#Cracker.food+1] = "j_paperback_crispy_taco"
    Cracker.food[#Cracker.food+1] = "j_paperback_soft_taco"
    Cracker.food[#Cracker.food+1] = "j_paperback_ghost_cola"
    Cracker.food[#Cracker.food+1] = "j_paperback_complete_breakfast"
    Cracker.food[#Cracker.food+1] = "j_paperback_b_soda"
    Cracker.food[#Cracker.food+1] = "j_paperback_cream_liqueur"
    Cracker.food[#Cracker.food+1] = "j_paperback_champagne"
    Cracker.food[#Cracker.food+1] = "j_paperback_coffee"
    Cracker.food[#Cracker.food+1] = "j_paperback_matcha"
    Cracker.food[#Cracker.food+1] = "j_paperback_epic_sauce"
    Cracker.food[#Cracker.food+1] = "j_paperback_dreamsicle"
    Cracker.food[#Cracker.food+1] = "j_paperback_cakepop"
    Cracker.food[#Cracker.food+1] = "j_paperback_caramel_apple"
    Cracker.food[#Cracker.food+1] = "j_paperback_charred_marshmallow"
    Cracker.food[#Cracker.food+1] = "j_paperback_rock_candy"
    Cracker.food[#Cracker.food+1] = "j_paperback_tanghulu"
    Cracker.food[#Cracker.food+1] = "j_paperback_ice_cube"
end

if next(SMODS.find_mod('extracredit')) then
    Cracker.food[#Cracker.food+1] = "j_ExtraCredit_starfruit"
    Cracker.food[#Cracker.food+1] = "j_ExtraCredit_candynecklace"
    Cracker.food[#Cracker.food+1] = "j_ExtraCredit_espresso"
    Cracker.food[#Cracker.food+1] = "j_ExtraCredit_ambrosia"
    Cracker.food[#Cracker.food+1] = "j_ExtraCredit_badapple"
end

if next(SMODS.find_mod('Bunco')) then
    Cracker.food[#Cracker.food+1] = "j_bunc_starfruit"
end

if next(SMODS.find_mod('Cryptid')) then
    Cracker.food[#Cracker.food+1] = "j_cry_pickle"
    Cracker.food[#Cracker.food+1] = "j_cry_chili_pepper"
    Cracker.food[#Cracker.food+1] = "j_cry_oldcandy"
    Cracker.food[#Cracker.food+1] = "j_cry_foodm"
    Cracker.food[#Cracker.food+1] = "j_cry_cotton_candy"
    Cracker.food[#Cracker.food+1] = "j_cry_wrapped"
    Cracker.food[#Cracker.food+1] = "j_cry_candy_cane"
    Cracker.food[#Cracker.food+1] = "j_cry_candy_buttons"
    Cracker.food[#Cracker.food+1] = "j_cry_jawbreaker"
    Cracker.food[#Cracker.food+1] = "j_cry_mellowcreme"
    Cracker.food[#Cracker.food+1] = "j_cry_brittle"
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

function Cracker.mostplayedhand() -- Balatro doesn't update G.GAME.current_round.most_played_poker_hand so
    if not G.GAME or not G.GAME.current_round then 
        return 'High Card'
    end
    local chosen_hand = 'High Card'
    local _handname, _played, _order = 'High Card', -1, 100
    for k, v in pairs(G.GAME.hands) do
        if v.played > _played or (v.played == _played and _order > v.order) then 
            _played = v.played
            _handname = k
        end
    end
    chosen_hand = _handname
    return chosen_hand
end

-- Tailsman Compat (fake)

to_big = to_big or function(x)
  return x
end

to_number = to_number or function(n)
  return n
end

--

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
            label = "Dev Textures",
            ref_table = CrackerConfig,
            ref_value = "starlo",
        }),
      },
    }
end