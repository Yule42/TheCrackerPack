CrackerConfig = SMODS.current_mod.config

SMODS.current_mod.no_marquee = true

--region Atlas
SMODS.Atlas {
    key = 'Jokers',
    path = "Jokers.png",
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
    key = 'falcon',
    path = "falcon.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = 'dx_blinds',
    path = "dxblinds.png",
    px = 34,
    py = 34,
    frames = 21, 
    atlas_table = 'ANIMATION_ATLAS'
}

SMODS.Atlas {
    key = 'tags',
    path = "tags.png",
    px = 34,
    py = 34,
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

-- Initialize pool of food jokers if it doesn't exist already, which may be created by other mods.
-- Any joker can add itself to this pool by adding pools = { Food = true } to its code
-- Credits to Cryptid for the idea and Paperback for this code
if not SMODS.ObjectTypes.Food then
    SMODS.ObjectType {
        key = 'Food',
        default = 'j_joker',
        cards = copy_table(Cracker.vanilla_food)
    }
end

SMODS.ObjectType {
    key = 'DeckVoucher',
    default = 'v_pw_erratic',
    cards = {}
}

local cracker_mod_id = SMODS.current_mod and SMODS.current_mod.id

SMODS.current_mod.custom_collection_tabs = function()
    local deck_voucher_pool = G.P_CENTER_POOLS and G.P_CENTER_POOLS.DeckVoucher or {}
    local tally = { tally = 0, of = 0 }
    local active_mod_id = (G.ACTIVE_MOD_UI and G.ACTIVE_MOD_UI.id) or cracker_mod_id
    for _, center in ipairs(deck_voucher_pool) do
        if type(center) == 'table' and center.mod and center.mod.id == active_mod_id then
            tally.of = tally.of + 1
            if center.discovered then
                tally.tally = tally.tally + 1
            end
        end
    end
    if tally.of <= 0 then
        return {}
    end

    return {
        UIBox_button({
            button = 'your_collection_deckvouchers',
            label = { localize('b_cracker_deck_vouchers') },
            count = tally,
            minw = 5,
            id = 'your_collection_deckvouchers'
        })
    }
end

G.FUNCS.your_collection_deckvouchers = function(e)
    G.SETTINGS.paused = true
    G.FUNCS.overlay_menu {
        definition = create_UIBox_your_collection_deckvouchers(),
    }
end

-- this is so stupid please figure out a better way to do this eventually
local function cracker_card_collection_UIBox_raw(_pool, rows, args) -- copied from smods code, modified for deck vouchers.
    args = args or {}
    args.w_mod = args.w_mod or 1
    args.h_mod = args.h_mod or 1
    args.card_scale = args.card_scale or 1
    local deck_tables = {}
    local pool = {}

    if type(_pool) == 'table' then
        for _, center in ipairs(_pool) do
            if not G.ACTIVE_MOD_UI or center.mod == G.ACTIVE_MOD_UI then
                pool[#pool + 1] = center
            end
        end
    end

    G.your_collection = {}
    local cards_per_page = 0
    local row_totals = {}
    for j = 1, #rows do
        if cards_per_page >= #pool and args.collapse_single_page then
            rows[j] = nil
        else
            row_totals[j] = cards_per_page
            cards_per_page = cards_per_page + rows[j]
            G.your_collection[j] = CardArea(
                G.ROOM.T.x + 0.2 * G.ROOM.T.w / 2,
                G.ROOM.T.h,
                (args.w_mod * rows[j] + 0.25) * G.CARD_W,
                args.h_mod * G.CARD_H,
                { card_limit = rows[j], type = args.area_type or 'title', highlight_limit = 0, collection = true }
            )
            table.insert(deck_tables, {
                n = G.UIT.R,
                config = { align = 'cm', padding = 0.07, no_fill = true },
                nodes = {
                    { n = G.UIT.O, config = { object = G.your_collection[j] } }
                }
            })
        end
    end

    local options = {}
    local total_pages = math.max(1, math.ceil(#pool / math.max(1, cards_per_page)))
    for i = 1, total_pages do
        options[#options + 1] = localize('k_page') .. ' ' .. tostring(i) .. '/' .. tostring(total_pages)
    end

    G.FUNCS.cracker_deckvoucher_collection_page = function(e)
        if not e or not e.cycle_config then return end
        for j = 1, #G.your_collection do
            for i = #G.your_collection[j].cards, 1, -1 do
                local c = G.your_collection[j]:remove_card(G.your_collection[j].cards[i])
                c:remove()
                c = nil
            end
        end
        for j = 1, #rows do
            for i = 1, rows[j] do
                local center = pool[i + row_totals[j] + (cards_per_page * (e.cycle_config.current_option - 1))]
                if not center then break end
                local card = Card(
                    G.your_collection[j].T.x + G.your_collection[j].T.w / 2,
                    G.your_collection[j].T.y,
                    G.CARD_W * args.card_scale,
                    G.CARD_H * args.card_scale,
                    G.P_CARDS.empty,
                    (args.center and G.P_CENTERS[args.center]) or center
                )
                if args.modify_card then args.modify_card(card, center, i, j) end
                if not args.no_materialize then card:start_materialize(nil, i > 1 or j > 1) end
                G.your_collection[j]:emplace(card)
            end
        end
        INIT_COLLECTION_CARD_ALERTS()
    end


    G.FUNCS.cracker_deckvoucher_collection_page({ cycle_config = { current_option = 1 } })

    return create_UIBox_generic_options({
        colour = G.ACTIVE_MOD_UI and ((G.ACTIVE_MOD_UI.ui_config or {}).collection_colour or (G.ACTIVE_MOD_UI.ui_config or {}).colour),
        bg_colour = G.ACTIVE_MOD_UI and ((G.ACTIVE_MOD_UI.ui_config or {}).collection_bg_colour or (G.ACTIVE_MOD_UI.ui_config or {}).bg_colour),
        back_colour = G.ACTIVE_MOD_UI and ((G.ACTIVE_MOD_UI.ui_config or {}).collection_back_colour or (G.ACTIVE_MOD_UI.ui_config or {}).back_colour),
        outline_colour = G.ACTIVE_MOD_UI and ((G.ACTIVE_MOD_UI.ui_config or {}).collection_outline_colour or (G.ACTIVE_MOD_UI.ui_config or {}).outline_colour),
        back_func = (args and args.back_func) or G.ACTIVE_MOD_UI and 'openModUI_' .. G.ACTIVE_MOD_UI.id or 'your_collection',
        snap_back = args.snap_back,
        infotip = args.infotip,
        contents = {
            { n = G.UIT.R, config = { align = 'cm', r = 0.1, colour = G.C.BLACK, emboss = 0.05 }, nodes = deck_tables },
            (not args.hide_single_page or cards_per_page < #pool) and {
                n = G.UIT.R,
                config = { align = 'cm' },
                nodes = {
                    create_option_cycle({
                        options = options,
                        w = 4.5,
                        cycle_shoulders = true,
                        opt_callback = 'cracker_deckvoucher_collection_page',
                        current_option = 1,
                        colour = G.ACTIVE_MOD_UI and (G.ACTIVE_MOD_UI.ui_config or {}).collection_option_cycle_colour or G.C.RED,
                        no_pips = true,
                        focus_args = { snap_to = true, nav = 'wide' }
                    })
                }
            } or nil,
        }
    })
end

create_UIBox_your_collection_deckvouchers = function()
    return cracker_card_collection_UIBox_raw(G.P_CENTER_POOLS.DeckVoucher, {4, 4}, {
        area_type = 'voucher',
        back_func = 'your_collection_other_gameobjects',
        modify_card = function(card, center, i, j)
            card.ability.order = i + (j - 1) * 4
        end,
    })
end

Cracker.money_tags = {
    tag_investment = true,
    tag_handy = true,
    tag_garbage = true,
    tag_skip = true,
    tag_economy = true,
    tag_cracker_rocket = true,
    tag_cracker_crystal = true,
}

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

function Cracker.dx_blinds_enabled()
    return G.GAME and G.GAME.selected_back and G.GAME.selected_back.effect.center.key == 'b_cracker_showdown'
end

function Cracker.force_dx_blind()
    return G.GAME and G.GAME.selected_back and G.GAME.selected_back.effect.center.key == 'b_cracker_showdown'
end

function Cracker.tag_is_in_shop(tag)
    if not tag or not G.shop_jokers then return false end
    for _, card in ipairs(G.shop_jokers.cards or {}) do
        if card.tag == tag or (card.config.center and card.config.center.key == tag.key) then
            return true
        end
    end
    return false
end

local remove_ref = Card.remove
function Card.remove(self)
    if self.added_to_deck and self.ability.set == 'Joker' and not G.CONTROLLER.locks.selling_card and Cracker.is_food(self.config.center_key) then
        SMODS.calculate_context({
            food_joker_destroyed = true,
            destroyed_joker = self
        })
    end

    return remove_ref(self)
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
    ret.Cracker = {}
    ret.Cracker.food_multiplier = 1
    ret.Cracker.tags_in_shop = 0
    
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
                                text = "Art: palestjade, MrkySpices, amoryax, LumaHoneyy, vyletbunni, wombatcountry, sugariimarii",
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
            label = "Dev Textures",
            ref_table = CrackerConfig,
            ref_value = "starlo",
        }),
      },
    }
end

assert(SMODS.load_file('src/base_jokers.lua'))()
assert(SMODS.load_file('src/upgraded_food.lua'))()
assert(SMODS.load_file('src/voucher.lua'))()

if not CrackerConfig.disable_card then
    assert(SMODS.load_file('src/expansion_1/card_jokers.lua'))()
end

assert(SMODS.load_file('src/expansion_2/jokers.lua'))()
assert(SMODS.load_file('src/expansion_2/decks.lua'))()
assert(SMODS.load_file('src/expansion_2/deck_vouchers.lua'))()

assert(SMODS.load_file('src/new_additions/decks.lua'))()
assert(SMODS.load_file('src/new_additions/showdown_blinds.lua'))()
assert(SMODS.load_file('src/new_additions/tags.lua'))()

assert(SMODS.load_file('src/ever_stuffer/decks.lua'))()
assert(SMODS.load_file('src/ever_stuffer/jokers.lua'))()
assert(SMODS.load_file('src/ever_stuffer/vouchers.lua'))()

if JokerDisplay then
    assert(SMODS.load_file('src/compat/JokerDisplay.lua'))()
end

if next(SMODS.find_mod('allinjest')) then
    assert(SMODS.load_file('src/compat/AllInJest.lua'))()
end

if next(SMODS.find_mod('paperback')) then
    assert(SMODS.load_file('src/compat/Paperback.lua'))()
end

if next(SMODS.find_mod('partner')) then
	SMODS.Atlas {
		key = 'Partner',
		path = "Partners.png",
		px = 46,
		py = 58
	}
	assert(SMODS.load_file('src/compat/Partner.lua'))()
end

if CardSleeves then
	SMODS.Atlas {
		key = 'sleeves',
		path = "sleeves.png",
		px = 73,
		py = 95
	}
	assert(SMODS.load_file('src/compat/CardSleeves.lua'))()
end

assert(SMODS.load_file('src/challenge.lua'))() -- load this last cause it references stuff from previous files

SMODS.current_mod.calculate = function(self, context)
    if context.tag_added and context.tag_added.key == "tag_cracker_loan" then
        ease_dollars(30)
    end
end
