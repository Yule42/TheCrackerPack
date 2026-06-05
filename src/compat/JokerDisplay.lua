JokerDisplay.Definitions.j_cracker_saltinecracker = {
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "chips", retrigger_type = "mult" }
    },
    extra = {
        {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = ")" },
        }
    },
    text_config = { colour = G.C.CHIPS },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },
    calc_function = function(card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'Saltine Cracker')
        card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { numerator, denominator } }
    end,
}
JokerDisplay.Definitions.j_cracker_chocolatecoin = {
    text = {
        { text = "+$" },
        { ref_table = "card.ability.extra", ref_value = "money" },
    },
    text_config = { colour = G.C.GOLD },
    reminder_text = {
        { ref_table = "card.joker_display_values", ref_value = "localized_text" },
        { text = "(" },
        { ref_table = "card.ability.extra", ref_value = "rounds" },
        { text = "/" },
        { ref_table = "card.joker_display_values", ref_value = "start_count" },
        { text = ")" },
    },
    calc_function = function(card)
        card.joker_display_values.localized_text = "(" .. localize("k_round") .. ")"
        card.joker_display_values.start_count = card.joker_display_values.start_count or card.ability.extra.rounds
    end
}
JokerDisplay.Definitions.j_cracker_grahamcracker = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "x_mult", retrigger_type = "exp" }
            }
        }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "grahamcracker_cards" },
        { text = "/" },
        { ref_table = "card.ability.extra",        ref_value = "cards_require" },
        { text = ")" },
    },
    calc_function = function(card)
        card.joker_display_values.grahamcracker_cards = card.ability.grahamcracker_cards or card.ability.extra.cards_left
    end
}
JokerDisplay.Definitions.j_cracker_thrifty_joker = {
     text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
    },
    calc_function = function(card)
        card.joker_display_values.mult = (math.max((table_length(G.GAME.used_vouchers) - (G.GAME.starting_voucher_count or 0)), 0) * card.ability.extra.vouchers_multiply)
    end,
    text_config = { colour = G.C.MULT },
}
JokerDisplay.Definitions.j_cracker_cheese = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "x_mult", retrigger_type = "exp" }
            }
        }
    },
}
JokerDisplay.Definitions.j_cracker_cheese = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "x_mult", retrigger_type = "exp" }
            }
        }
    },
}
JokerDisplay.Definitions.j_cracker_crackerbarrel = {
    reminder_text = {
        { text = "(" },
        { ref_table = "card.ability.extra", ref_value = "jokersleft" },
        { text = "/" },
        { ref_table = "card.joker_display_values", ref_value = "start_count" },
        { text = ")" },
    },
    calc_function = function(card)
        card.joker_display_values.start_count = card.joker_display_values.start_count or card.ability.extra.jokersleft
    end
}
JokerDisplay.Definitions.j_cracker_sacramentalkatana = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "x_mult", retrigger_type = "exp" }
            }
        }
    },
}
JokerDisplay.Definitions.j_cracker_lifesupport = {
    text = {
        { text = "-$" },
        { ref_table = "card.ability.extra", ref_value = "price" },
    },
    text_config = { colour = G.C.GOLD },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "active" },
        { text = ")" },
    },
    calc_function = function(card)
        card.joker_display_values.active = G.GAME and G.GAME.current_round.hands_left <= 1 and localize("jdis_active") or localize("jdis_inactive")
    end,
}
JokerDisplay.Definitions.j_cracker_curry = {
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.MULT },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "localized_text" },
        { text = ")" },
    },
    calc_function = function(card)
        card.joker_display_values.localized_text = localize("jdis_cracker_before")
    end
}
JokerDisplay.Definitions.j_cracker_northstar = {
    text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "odds" },
        { text = ")" },
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.FILTER },
        { text = ")" },
    },
    text_config = { colour = G.C.GREEN, scale = 0.3 },
    calc_function = function(card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'northstar')
        card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { numerator, denominator } }
        card.joker_display_values.localized_text = localize(Cracker.mostplayedhand(), 'poker_hands')
    end,
}
JokerDisplay.Definitions.j_cracker_thedealer = {
    text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "odds" },
        { text = ")" },
    },
    text_config = { colour = G.C.GREEN, scale = 0.3 },
    calc_function = function(card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'thedealer')
        card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { numerator, denominator } }
    end,
}
JokerDisplay.Definitions.j_cracker_bomb = {
    reminder_text = {
        { text = "(" },
        { ref_table = "card.ability.extra",              ref_value = "rounds" },
        { text = "/" },
        { ref_table = "card.joker_display_values", ref_value = "start_count" },
        { text = ")" },
    },
    calc_function = function(card)
        card.joker_display_values.start_count = card.joker_display_values.start_count or card.ability.extra.rounds
    end,
}
JokerDisplay.Definitions.j_cracker_cybernana = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "x_mult", retrigger_type = "exp" }
            }
        }
    },
    extra = {
        {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = ")" },
        }
    },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },
    calc_function = function(card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'Cybernana MK920')
        card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { numerator, denominator } }
    end
}
JokerDisplay.Definitions.j_cracker_buttpopcorn = {
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.MULT },
}
JokerDisplay.Definitions.j_cracker_sundae = {
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "adding", retrigger_type = "mult" },
        { ref_table = "card.joker_display_values", ref_value = "added_text" }
    },
    calc_function = function(card)
        card.joker_display_values.added_text = ""
        card.joker_display_values.adding = card.ability.extra.chips
        if card.ability.extra.state == 1 then
            card.joker_display_values.adding = card.ability.extra.mult
        elseif card.ability.extra.state == 2 then
            card.joker_display_values.adding = 1
            card.joker_display_values.added_text = " "..localize('k_planet')
        end
    end,
    style_function = function(card, text, reminder_text, extra)
        if text and text.children then
            local colour = card.ability.extra.state == 1 and G.C.MULT or (card.ability.extra.state == 2 and G.C.SECONDARY_SET.Planet or G.C.CHIPS)
            if text.children[1] then text.children[1].config.colour = colour end
            if text.children[2] then text.children[2].config.colour = colour end
            if text.children[3] then text.children[3].config.colour = colour end
        end
    end
}
JokerDisplay.Definitions.j_cracker_alcoholicsoda = {
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "odds" },
        { text = ")" },
    },
    calc_function = function(card)
        local numerator, denominator = 1, card.ability.extra.odds
        if SMODS then numerator, denominator = SMODS.get_probability_vars(card, numerator, denominator, 'Alcoholic Soda') end
        card.joker_display_values.odds = localize{ type = 'variable', key = "jdis_odds", vars = { numerator, denominator } }
    end,
    retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
        if held_in_hand then return 0 end
        return JokerDisplay.in_scoring(playing_card, scoring_hand) and JokerDisplay.calculate_joker_triggers(joker_card) or 0
    end
}
JokerDisplay.Definitions.j_cracker_canofbeans = {
    reminder_text = {
        { text = "(" },
        { ref_table = "card.ability.extra",        ref_value = "rounds" },
        { text = "/" },
        { ref_table = "card.joker_display_values", ref_value = "start_count" },
        { text = ")" },
    },
    reminder_text_config = { scale = 0.35 },
    calc_function = function(card)
        card.joker_display_values.start_count = card.joker_display_values.start_count or card.ability.extra.rounds
    end
}
JokerDisplay.Definitions.j_cracker_tsukemen = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "x_mult", retrigger_type = "exp" }
            }
        }
    },
}
JokerDisplay.Definitions.j_cracker_bluecard = {
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.CHIPS },
    calc_function = function(card)
        local count = 0
        for k, v in pairs(G.playing_cards) do
            if next(SMODS.get_enhancements(v)) then
                count = count + 1
            end
        end
        card.joker_display_values.chips = count * card.ability.extra.chips_add
    end
}
JokerDisplay.Definitions.j_cracker_baserunner = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "x_mult", retrigger_type = "exp" }
            }
        }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.ability.extra", ref_value = "skips_done" },
        { text = "/" },
        { ref_table = "card.ability.extra", ref_value = "skips_reset" },
        { text = ")" },
    },
    style_function = function(card, text, reminder_text, extra)
        local children = reminder_text and reminder_text.children
        if not children then return end

        local colour = (card.ability.extra.skips_done == card.ability.extra.skips_reset - 1) and G.C.RED or G.C.UI.TEXT_INACTIVE
        for i = 2, 4 do
            local child = children[i]
            if child then child.config.colour = colour end
        end
    end,
}
JokerDisplay.Definitions.j_cracker_pinkcard = {
    text = {
        { ref_table = "card.joker_display_values", ref_value = "h_size", colour = G.C.FILTER, retrigger_type = "mult" },
    },
    text_config = { colour = G.C.FILTER },
    style_function = function(card, text, reminder_text, extra)
        if text and text.children[1] then
            text.children[1].config.colour = card.joker_display_values.active and G.C.FILTER or
                G.C.UI.TEXT_INACTIVE
        end
        return false
    end,
    calc_function = function(card)
        card.joker_display_values.active = card.ability.extra.current_add > 0
        card.joker_display_values.h_size = card.joker_display_values.active and ("+" .. (card.ability.extra.current_add and JokerDisplay.number_format(card.ability.extra.current_add) or 0)) or "-"
    end,
}
JokerDisplay.Definitions.j_cracker_paycheck = {
    text = {
            { text = "+$" },
            { ref_table = "card.ability.extra", ref_value = "dollars" },
        },
        text_config = { colour = G.C.GOLD },
        reminder_text = {
            { ref_table = "card.joker_display_values", ref_value = "localized_text" },
        },
        calc_function = function(card)
            card.joker_display_values.localized_text = "(" .. localize("b_skip") .. ")"
        end
}
JokerDisplay.Definitions.j_cracker_darkroom = {
    reminder_text = {
        { text = "(" },
        { ref_table = "card.ability.extra", ref_value = "skips" },
        { text = "/" },
        { ref_table = "card.joker_display_values", ref_value = "negative_count" },
        { text = ")" },
    },
    calc_function = function(card)
        local negative_count = 0
        if G.jokers then
            for k, v in ipairs(G.jokers.cards) do
                if v and v.edition and v.edition.negative then
                    negative_count = negative_count + 1
                end
            end
        end
        card.joker_display_values.negative_count = card.ability.extra.skips_needed_base + negative_count
    end,
}
JokerDisplay.Definitions.j_cracker_whitecard = {
    text = {
        { ref_table = "card.joker_display_values", ref_value = "tarot_count", retrigger_type = "mult" },
    },
    text_config = { colour = G.C.SECONDARY_SET.Tarot },
    calc_function = function(card)
        card.joker_display_values.tarot_count = "+" .. card.ability.extra.solds
    end,
}
JokerDisplay.Definitions.j_cracker_rainbowcard = {
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "active" },
        { text = ")" },
    },
    calc_function = function(card)
        card.joker_display_values.active = card.ability.extra.active and localize("jdis_active") or localize("jdis_inactive")
    end,
    retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
        return joker_card.ability.extra.active and JokerDisplay.calculate_joker_triggers(joker_card) or 0
    end
}
JokerDisplay.Definitions.j_cracker_snail = {
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.MULT },
}
JokerDisplay.Definitions.j_cracker_prosopagnosia = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "x_mult", retrigger_type = "exp" }
            }
        }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
        { text = ")" },
    },
    calc_function = function(card)
        card.joker_display_values.localized_text = localize("k_face_cards")
    end
}
JokerDisplay.Definitions.j_cracker_shrimpcocktail = {
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "discards" },
        { text = "D" },
    },
    text_config = { colour = G.C.MULT },
}
JokerDisplay.Definitions.j_cracker_hamburger = {
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "hands" },
        { text = "H" },
    },
    text_config = { colour = G.C.CHIPS },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.ability.extra", ref_value = "discard_cards_left" },
        { text = "/" },
        { ref_table = "card.ability.extra", ref_value = "discard_cards_required" },
        { text = ")" },
    },
}
JokerDisplay.Definitions.j_cracker_potatochips = {
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "chips", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.CHIPS },
}
JokerDisplay.Definitions.j_cracker_ants = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "x_mult", retrigger_type = "exp" }
            }
        }
    },
}
JokerDisplay.Definitions.j_cracker_thefalcon = {
    text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "odds" },
        { text = ")" },
    },
    text_config = { colour = G.C.GREEN, scale = 0.3 },
    calc_function = function(card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'thefalcon')
        card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { numerator, denominator } }
    end,
}
JokerDisplay.Definitions.j_cracker_postman = {
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.MULT },
}
JokerDisplay.Definitions.j_cracker_student = {
    retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
        if held_in_hand then return 0 end
        return playing_card.config.center.key == 'm_cracker_sequenced' or playing_card.config.center.key == 'm_cracker_multi' and JokerDisplay.calculate_joker_triggers(joker_card) or 0
    end
}
JokerDisplay.Definitions.j_cracker_skillet = {
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "count",          colour = G.C.ORANGE },
        { text = "x" },
        { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.FILTER },
        { text = ")" },
    },
    calc_function = function(card)
        local count = 0
        if G.jokers then
            for _, joker_card in ipairs(G.jokers.cards) do
                if joker_card and Cracker.is_food(joker_card) then
                    count = count + 1
                end
            end
        end
        card.joker_display_values.count = count
        card.joker_display_values.localized_text = localize("k_cracker_food")
    end,
    mod_function = function(card, mod_joker)
        return { x_mult = (Cracker.is_food(card) and mod_joker.ability.extra.x_mult ^ JokerDisplay.calculate_joker_triggers(mod_joker) or nil) }
    end
}
JokerDisplay.Definitions.j_cracker_sophia = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "x_mult", retrigger_type = "exp" }
            }
        }
    },
}
JokerDisplay.Definitions.j_cracker_testLegendary = {
    text = {
        { ref_table = "card.ability.extra", ref_value = "retriggers", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.FILTER },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.ability.extra", ref_value = "cards_left" },
        { text = "/" },
        { ref_table = "card.ability.extra", ref_value = "cards_require" },
        { text = ")" },
    },
    retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
        return joker_card.ability.extra.retriggers * JokerDisplay.calculate_joker_triggers(joker_card) or 0
    end
}
JokerDisplay.Definitions.j_cracker_ufo = {
    text = {
        { text = "+",                              colour = G.C.CHIPS },
        { ref_table = "card.ability.extra",        ref_value = "chips", colour = G.C.CHIPS, retrigger_type = "mult" },
        { text = " +",                             colour = G.C.MULT },
        { ref_table = "card.ability.extra",        ref_value = "mult",  colour = G.C.MULT,  retrigger_type = "mult" }
    },
}
