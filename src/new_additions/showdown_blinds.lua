SMODS.Blind {
    key = "major",
    dollars = 5,
    mult = 2,
    pos = { y = 2 },
    boss = {},
    atlas = 'dx_blinds',
    boss_colour = HEX("424242"),
    in_pool = function(self)
        return G.GAME and G.GAME.selected_back and G.GAME.selected_back.effect.center.key == 'b_cracker_showdown'
    end,
    no_collection = true,
}

SMODS.Blind { -- The Hook
    object_type = "Blind",
    key = 'hook_dx',
    boss = {
        min = 1,
        dx = true,
    },
    in_pool = function(self)
        return Cracker.dx_blinds_enabled() and (G.GAME.round_resets.ante <= 2 or G.GAME.round_resets.ante >= G.GAME.win_ante)
    end,
    mult = 2,
    boss_colour = HEX("7f311c"),
    atlas = 'dx_blinds',
    pos = { y = 8 },
    loc_vars = function(self)
        return { vars = { } }
    end,
    dollars = 5,
    config = { extra = { pause_triggering = false } },
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.press_play then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local any_selected = nil
                        local _cards = {}
                        for _, playing_card in ipairs(G.hand.cards) do
                            _cards[#_cards + 1] = playing_card
                        end
                        for i = 1, 2 do
                            if G.hand.cards[i] then
                                local selected_card, card_index = pseudorandom_element(_cards, 'hook_dx')
                                G.hand:add_to_highlighted(selected_card, true)
                                table.remove(_cards, card_index)
                                any_selected = true
                                play_sound('card1', 1)
                            end
                        end
                        if any_selected then G.FUNCS.discard_cards_from_highlighted(nil, true) end
                        return true
                    end
                }))
                blind.triggered = true
                delay(0.7)
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = (function()
                        SMODS.juice_up_blind()
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.06 * G.SETTINGS.GAMESPEED,
                            blockable = false,
                            blocking = false,
                            func = function()
                                play_sound('tarot2', 0.76, 0.4); return true
                            end
                        }))
                        play_sound('tarot2', 1, 0.4)
                        return true
                    end)
                }))
                delay(0.4)
            elseif context.cracker_after_discard and G.GAME.blind.effect.extra and not G.GAME.blind.effect.extra.pause_triggering then
                G.GAME.blind.effect.extra.pause_triggering = true
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local any_selected = nil
                        local _cards = {}
                        for _, playing_card in ipairs(G.hand.cards) do
                            if not playing_card.highlighted then
                                _cards[#_cards + 1] = playing_card
                            end
                        end
                        G.hand.config.highlighted_limit = G.hand.config.highlighted_limit + 2
                        for i = 1, 2 do
                            if G.hand.cards[i] then
                                local selected_card, card_index = pseudorandom_element(_cards, 'hook_dx')
                                G.hand:add_to_highlighted(selected_card, true)
                                table.remove(_cards, card_index)
                                any_selected = true
                                play_sound('card1', 1)
                            end
                        end
                        if any_selected then G.FUNCS.discard_cards_from_highlighted(nil, true) end
                        G.hand.config.highlighted_limit = G.hand.config.highlighted_limit - 2
                        G.GAME.blind.effect.extra.pause_triggering = false
                        return true
                    end
                }))
                blind.triggered = true
                delay(0.7)
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = (function()
                        SMODS.juice_up_blind()
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.06 * G.SETTINGS.GAMESPEED,
                            blockable = false,
                            blocking = false,
                            func = function()
                                play_sound('tarot2', 0.76, 0.4); return true
                            end
                        }))
                        play_sound('tarot2', 1, 0.4)
                        return true
                    end)
                }))
                delay(0.4)
            end
        end
    end
}

SMODS.Blind { -- The Ox
    object_type = "Blind",
    key = 'ox_dx',
    boss = {
        dx = true,
    },
    in_pool = function(self)
        return Cracker.dx_blinds_enabled() and G.GAME.round_resets.ante >= 4
    end,
    mult = 2,
    boss_colour = HEX("8c4507"),
    atlas = 'dx_blinds',
    pos = { y = 3 },
    loc_vars = function(self)
        return { vars = { localize(G.GAME.current_round.most_played_poker_hand, 'poker_hands') } }
    end,
    collection_loc_vars = function(self)
        return { vars = { localize('ph_most_played') } }
    end,
    dollars = 5,
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.debuff_hand then
                blind.triggered = false
                if not context.check and next(context.poker_hands[G.GAME.current_round.most_played_poker_hand]) then
                    blind.triggered = true
                    if not context.check then
                        ease_dollars(-G.GAME.dollars - 5, true)
                        blind:wiggle()
                    end
                end
            end
        end
    end
}

SMODS.Blind { -- The House
    object_type = "Blind",
    key = 'house_dx',
    boss = {
        min = 2,
        dx = true,
    },
    in_pool = function(self)
        return Cracker.dx_blinds_enabled() and G.GAME.round_resets.ante >= 2
    end,
    mult = 2,
    boss_colour = HEX("3d657f"),
    atlas = 'dx_blinds',
    pos = { y = 4 },
    loc_vars = function(self)
        return { vars = { } }
    end,
    dollars = 5,
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.stay_flipped and context.to_area == G.hand then
                if G.GAME.current_round.discards_left ~= 0 then
                    return {
                        stay_flipped = true
                    }
                end
            end
        end
    end,
    disable = function(self)
        for i = 1, #G.hand.cards do
            if G.hand.cards[i].facing == 'back' then
                G.hand.cards[i]:flip()
            end
        end
        for _, playing_card in pairs(G.playing_cards) do
            playing_card.ability.wheel_flipped = nil
        end
    end
}

SMODS.Blind { -- The Wall
    object_type = "Blind",
    key = 'wall_dx',
    boss = {
        min = 2,
        dx = true,
    },
    in_pool = function(self)
        return Cracker.dx_blinds_enabled() and G.GAME.round_resets.ante >= 6
    end,
    mult = 6,
    boss_colour = HEX("68447d"),
    atlas = 'dx_blinds',
    pos = { y = 10 },
    loc_vars = function(self)
        return { vars = { } }
    end,
    dollars = 5,
    disable = function(self)
        G.GAME.blind.chips = G.GAME.blind.chips / 3
        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
    end
}

SMODS.Blind { -- The Wheel
    object_type = "Blind",
    key = 'wheel_dx',
    boss = {
        min = 2,
        dx = true,
    },
    config = { extra = { odds = 1, cards_play = 3 } },
    in_pool = function(self)
        return Cracker.dx_blinds_enabled() and G.GAME.round_resets.ante >= 2
    end,
    loc_vars = function(self)
        local numerator, denominator = SMODS.get_probability_vars(self, G.GAME.blind.effect.extra and G.GAME.blind.effect.extra.odds or 1, 7)
        return { vars = { numerator, denominator, G.GAME.blind.effect.extra and G.GAME.blind.effect.extra.cards_discard or 2 } }
    end,
    collection_loc_vars = function(self)
        return { vars = { '1', '7', '3' } }
    end,
    mult = 2,
    boss_colour = HEX("3d905e"),
    atlas = 'dx_blinds',
    pos = { y = 11 },
    dollars = 5,
    calculate = function(self, blind, context)
        if not blind.disabled and G.GAME.blind.effect then
            if context.stay_flipped and context.to_area == G.hand then
                if SMODS.pseudorandom_probability(blind, 'wheel_dx', G.GAME.blind.effect.extra.odds, 7) then
                    return {
                        stay_flipped = true
                    }
                end
            elseif context.before then
                local i = #context.full_hand
                while i > 0 do
                    G.GAME.blind.effect.extra.cards_play = G.GAME.blind.effect.extra.cards_play - 1
                    if G.GAME.blind.effect.extra.cards_play <= 0 then
                        G.GAME.blind.effect.extra.odds = G.GAME.blind.effect.extra.odds + 1
                        G.GAME.blind.effect.extra.cards_play = 3
                    end
                    i = i - 1
                end
                G.GAME.blind:set_text()
            end
        end
    end,
    disable = function(self)
        for i = 1, #G.hand.cards do
            if G.hand.cards[i].facing == 'back' then
                G.hand.cards[i]:flip()
            end
        end
        for _, playing_card in pairs(G.playing_cards) do
            playing_card.ability.wheel_flipped = nil
        end
    end
}

SMODS.Blind { -- The Arm
    object_type = "Blind",
    key = 'arm_dx',
    boss = {
        min = 2,
        dx = true,
    },
    in_pool = function(self)
        return Cracker.dx_blinds_enabled() and G.GAME.round_resets.ante >= 2
    end,
    mult = 2,
    boss_colour = HEX("4f4db7"),
    atlas = 'dx_blinds',
    pos = { y = 12 },
    dollars = 5,
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.debuff_hand then
                blind.triggered = false
                if G.GAME.hands[context.scoring_name].level == 1 then
                    blind.triggered = true
                    if not context.check then
                        return {
                            level_up = -1
                        }
                    end
                elseif G.GAME.hands[context.scoring_name].level > 1 then
                    blind.triggered = true
                    if not context.check then
                        return {
                            level_up = -2
                        }
                    end
                end
            end
        end
    end,
}

SMODS.Blind { -- The Club
    object_type = "Blind",
    key = 'club_dx',
    boss = {
        min = 1,
        dx = true,
    },
    in_pool = function(self)
        if not Cracker.dx_blinds_enabled() then return false end
        if G.playing_cards then
            local count = 0
            for k, v in ipairs(G.playing_cards) do
                if v:is_suit('Clubs') then
                    count = count + 1
                end
            end
            return count >= math.floor(#G.playing_cards/3)
        end
        return false
    end,
    mult = 2,
    boss_colour = HEX("8c996e"),
    atlas = 'dx_blinds',
    pos = { y = 5 },
    dollars = 5,
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.debuff_hand then
                blind.triggered = false
                for _, card in ipairs(context.scoring_hand) do
                    if card:is_suit('Clubs') then
                        blind.triggered = true
                        if not context.check then
                            blind:wiggle()
                        end
                        break
                    end
                end
            elseif context.individual and context.cardarea == G.play then
                if context.other_card:is_suit('Clubs') then
                    mult = mod_mult(1)
                end
            end
        end
    end,
}

SMODS.Blind { -- The Fish
    object_type = "Blind",
    key = 'fish_dx',
    boss = {
        min = 2,
        dx = true,
    },
    in_pool = function(self)
        return Cracker.dx_blinds_enabled() and G.GAME.round_resets.ante >= 4
    end,
    mult = 2,
    boss_colour = HEX("6da3cd"),
    atlas = 'dx_blinds',
    pos = { y = 6 },
    dollars = 5,
    config = { extra = { discards = 2, } },
    loc_vars = function(self)
        return { vars = { G.GAME.blind.effect.extra and G.GAME.blind.effect.extra.discards or 2 } }
    end,
    collection_loc_vars = function(self)
        return { vars = { '2' } }
    end,
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.press_play then
                blind.prepped = true
            elseif context.pre_discard then
                G.GAME.blind.effect.extra.discards = G.GAME.blind.effect.extra.discards - 1
                if G.GAME.blind.effect.extra.discards <= 0 then
                    G.GAME.blind.effect.extra.discards = 2
                    blind.prepped = true
                end
                G.GAME.blind:set_text()
            end
            if context.stay_flipped and context.to_area == G.hand and blind.prepped then
                return {
                    stay_flipped = true
                }
            end
        end
        if context.setting_blind or context.hand_drawn then
            blind.prepped = nil
        end
    end,
    disable = function(self)
        for i = 1, #G.hand.cards do
            if G.hand.cards[i].facing == 'back' then
                G.hand.cards[i]:flip()
            end
        end
        for _, playing_card in pairs(G.playing_cards) do
            playing_card.ability.wheel_flipped = nil
        end
    end
}

SMODS.Blind { -- The Pyschic
    object_type = "Blind",
    key = 'pyschic_dx',
    boss = {
        min = 1,
        dx = true,
    },
    in_pool = function(self)
        return Cracker.dx_blinds_enabled()
    end,
    mult = 2,
    boss_colour = HEX("b5902d"),
    atlas = 'dx_blinds',
    pos = { y = 13 },
    dollars = 5,
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.debuff_hand then
                if #context.full_hand < 5 then
                    blind.triggered = true
                    return {
                        debuff = true
                    }
                end
            end
        end
    end
}

local can_discard_ref = G.FUNCS.can_discard
G.FUNCS.can_discard = function(e)
	if G.GAME.blind and G.GAME.blind.name == 'bl_cracker_pyschic_dx' and not G.GAME.blind.disabled then
		if to_big(G.GAME.current_round.discards_left) <= to_big(0) or to_big(#G.hand.highlighted) <= to_big(4) then
			e.config.colour = G.C.UI.BACKGROUND_INACTIVE
			e.config.button = nil
		else
			e.config.colour = G.C.RED
			e.config.button = 'discard_cards_from_highlighted'
		end
	else
		can_discard_ref(e)
	end
end

SMODS.Blind { -- The Goad
    object_type = "Blind",
    key = 'goad_dx',
    boss = {
        min = 1,
        dx = true,
    },
    in_pool = function(self)
        if not Cracker.dx_blinds_enabled() then return false end
        if G.playing_cards then
            local count = 0
            for k, v in ipairs(G.playing_cards) do
                if v:is_suit('Spades') then
                    count = count + 1
                end
            end
            return count >= math.floor(#G.playing_cards/3)
        end
        return false
    end,
    mult = 2,
    boss_colour = HEX("673353"),
    atlas = 'dx_blinds',
    pos = { y = 14 },
    dollars = 5,
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.debuff_hand then
                blind.triggered = false
                for _, card in ipairs(context.scoring_hand) do
                    if card:is_suit('Spades') then
                        if G.GAME.hands[context.scoring_name].level > 1 then
                            blind.triggered = true
                            if not context.check then
                                return {
                                    level_up = -G.GAME.hands[context.scoring_name].level + 1
                                }
                            end
                        end
                    end
                end
            end
        end
    end
}

SMODS.Blind { -- The Water
    object_type = "Blind",
    key = 'water_dx',
    boss = {
        min = 2,
        dx = true,
    },
    in_pool = function(self)
        return Cracker.dx_blinds_enabled() and G.GAME.round_resets.ante >= 6
    end,
    mult = 2,
    boss_colour = HEX("d4e7ef"),
    atlas = 'dx_blinds',
    pos = { y = 15 },
    dollars = 5,
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.setting_blind then
                blind.discards_sub = G.GAME.current_round.discards_left
                ease_discard(-blind.discards_sub)
            end
        end
    end,
    disable = function(self)
        ease_discard(G.GAME.blind.discards_sub)
    end,
    set_blind = function(self)
        for i=1, G.GAME.current_round.discards_left*5 do
            draw_card(G.deck, G.discard)
        end
    end,
}

SMODS.Blind { -- The Window
    object_type = "Blind",
    key = 'window_dx',
    boss = {
        min = 1,
        dx = true,
    },
    in_pool = function(self)
        if not Cracker.dx_blinds_enabled() then return false end
        if G.playing_cards then
            local count = 0
            for k, v in ipairs(G.playing_cards) do
                if v:is_suit('Diamonds') then
                    count = count + 1
                end
            end
            return count >= math.floor(#G.playing_cards/3)
        end
        return false
    end,
    mult = 2,
    boss_colour = HEX("807a71"),
    atlas = 'dx_blinds',
    pos = { y = 7 },
    dollars = 5,
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.debuff_hand then
                blind.triggered = false
                for _, card in ipairs(context.scoring_hand) do
                    if card:is_suit('Diamonds') then
                        blind.triggered = true
                        if not context.check then
                            blind:wiggle()
                        end
                        break
                    end
                end
            elseif context.individual and context.cardarea == G.play then
                if context.other_card:is_suit('Diamonds') then
                    ease_dollars(-5)
                end
            end
        end
    end,
}

SMODS.Blind { -- The Manacle
    object_type = "Blind",
    key = 'manacle_dx',
    boss = {
        min = 1,
        dx = true,
    },
    in_pool = function(self)
        return Cracker.dx_blinds_enabled() and G.GAME.round_resets.ante >= 4
    end,
    mult = 2,
    boss_colour = HEX("808080"),
    atlas = 'dx_blinds',
    pos = { y = 9 },
    dollars = 5,
    config = { extra = { hand_size_reduction = 1, } },
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.setting_blind then
                G.hand:change_size(-1)
            elseif context.pre_discard and G.GAME.blind.effect then
                G.hand:change_size(-1)
                G.GAME.blind.effect.extra.hand_size_reduction = G.GAME.blind.effect.extra.hand_size_reduction + 1
                blind:wiggle()
                blind.triggered = true
            end
        end
    end,
    disable = function(self)
        if G.GAME.blind.effect then
            G.hand:change_size(G.GAME.blind.effect.extra.hand_size_reduction)
        end
    end,
    defeat = function(self)
        if not G.GAME.blind.disabled then
            if G.GAME.blind.effect then
                G.hand:change_size(G.GAME.blind.effect.extra.hand_size_reduction)
            end
        end
    end
}

SMODS.Blind { -- The Eye
    object_type = "Blind",
    key = 'eye_dx',
    boss = {
        min = 3,
        dx = true,
    },
    in_pool = function(self)
        return Cracker.dx_blinds_enabled() and (G.GAME.round_resets.ante == 4 or G.GAME.round_resets.ante >= G.GAME.win_ante)
    end,
    mult = 2,
    boss_colour = HEX("3956ac"),
    atlas = 'dx_blinds',
    pos = { y = 18 },
    dollars = 5,
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.debuff_hand then
                if context.check then
                    if G.GAME.hands[context.scoring_name].played_this_ante and G.GAME.hands[context.scoring_name].played_this_ante > 0 then
                        blind.triggered = true
                        return {
                            debuff = true
                        }
                    end
                elseif G.GAME.hands[context.scoring_name].played_this_ante and G.GAME.hands[context.scoring_name].played_this_ante > 1 then
                    blind.triggered = true
                    return {
                        debuff = true
                    }
                end
            end
        end
    end
}

SMODS.Blind { -- The Mouth
    object_type = "Blind",
    key = 'mouth_dx',
    boss = {
        min = 2,
        dx = true,
    },
    in_pool = function(self)
        return Cracker.dx_blinds_enabled() and G.GAME.round_resets.ante >= 2
    end,
    mult = 2,
    boss_colour = HEX("84566b"),
    atlas = 'dx_blinds',
    pos = { y = 19 },
    dollars = 5,
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.debuff_hand then
                if context.scoring_name ~= G.GAME.first_hand_played then
                    blind.triggered = true
                    return {
                        debuff = true
                    }
                end
            end
        end
    end
}

SMODS.Blind { -- The Plant
    object_type = "Blind",
    key = 'plant_dx',
    boss = {
        min = 4,
        dx = true,
    },
    in_pool = function(self)
        return Cracker.dx_blinds_enabled() and G.GAME.round_resets.ante >= 6
    end,
    mult = 2,
    boss_colour = HEX("3e5149"),
    atlas = 'dx_blinds',
    pos = { y = 20 },
    dollars = 5,
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.after then
                if blind.triggered then
                    mod_mult(1)
                    mod_chips(1)
                end
            elseif context.debuff_hand then
                blind.triggered = false
                for _, card in ipairs(context.scoring_hand) do
                    if card:is_face() then
                        blind.triggered = true
                        if not context.check then
                            blind:wiggle()
                        end
                        break
                    end
                end
            end
        end
    end
}

SMODS.Blind { -- The Serpent
    object_type = "Blind",
    key = 'serpent_dx',
    boss = {
        min = 5,
        dx = true,
    },
    in_pool = function(self)
        return Cracker.dx_blinds_enabled() and G.GAME.round_resets.ante >= 5
    end,
    mult = 2,
    boss_colour = HEX("33743c"),
    atlas = 'dx_blinds',
    pos = { y = 16 },
    dollars = 5,
    set_blind = function(self)
        local deck_length = #G.deck.cards
        for i=1, math.floor(deck_length/3) do
            draw_card(G.deck, G.hand)
        end
        delay(0.4)
        for i=math.floor(deck_length/3)+1, deck_length do
            draw_card(G.deck, G.discard)
        end
    end,
}


SMODS.Blind { -- The Pillar
    object_type = "Blind",
    key = 'pillar_dx',
    boss = {
        min = 1,
        dx = true,
    },
    in_pool = function(self)
        return Cracker.dx_blinds_enabled()
    end,
    mult = 2,
    boss_colour = HEX("5f4e3e"),
    atlas = 'dx_blinds',
    pos = { y = 17 },
    dollars = 5,
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.debuff_card and context.debuff_card.area ~= G.jokers and context.debuff_card.ability.played_ever then
                return {
                    debuff = true
                }
            end
        end
    end
}

SMODS.Blind { -- The Needle
    object_type = "Blind",
    key = 'needle_dx',
    boss = {
        min = 2,
        dx = true,
    },
    in_pool = function(self)
        return Cracker.dx_blinds_enabled() and G.GAME.round_resets.ante >= 6
    end,
    mult = 1,
    boss_colour = HEX("465325"),
    atlas = 'dx_blinds',
    pos = { y = 21 },
    dollars = 5,
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.setting_blind then
                blind.hands_sub = G.GAME.round_resets.hands - 2
                ease_hands_played(-blind.hands_sub)
                blind.discards_sub = G.GAME.current_round.discards_left
                ease_discard(-blind.discards_sub)
            end
        end
    end,
    disable = function(self)
        ease_hands_played(G.GAME.blind.hands_sub)
        ease_discard(G.GAME.blind.discards_sub)
    end
}

SMODS.Blind { -- The Head
    object_type = "Blind",
    key = 'head_dx',
    boss = {
        min = 1,
        dx = true,
    },
    in_pool = function(self)
        if not Cracker.dx_blinds_enabled() then return false end
        if G.playing_cards then
            local count = 0
            for k, v in ipairs(G.playing_cards) do
                if v:is_suit('Hearts') then
                    count = count + 1
                end
            end
            return count >= math.floor(#G.playing_cards/3)
        end
        return false
    end,
    mult = 2,
    boss_colour = HEX("605764"),
    atlas = 'dx_blinds',
    pos = { y = 22 },
    dollars = 5,
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.debuff_hand and not context.check then
                blind.triggered = false
                for _, card in ipairs(context.scoring_hand) do
                    if card:is_suit('Hearts') then
                        blind.triggered = true
                        if not context.check then
                            local jokers = {}
                            for i = 1, #G.jokers.cards do
                                if not G.jokers.cards[i].debuff then
                                    jokers[#jokers + 1] = G.jokers.cards[i]
                                end
                            end
                            if #jokers == 0 then break end
                            local _card = pseudorandom_element(jokers, 'head_dx')
                            SMODS.debuff_card(_card, true, 'head_dx')
                            _card:juice_up()
                            blind:wiggle()
                        end
                    end
                end
            end
        end
    end,
    disable = function(self)
        for _, joker in ipairs(G.jokers.cards) do
            SMODS.debuff_card(joker, false, 'head_dx')
        end
    end,
    defeat = function(self)
        for _, joker in ipairs(G.jokers.cards) do
            SMODS.debuff_card(joker, false, 'head_dx')
        end
    end,
}

SMODS.Blind { -- The Tooth
    object_type = "Blind",
    key = 'tooth_dx',
    boss = {
        min = 3,
        dx = true,
    },
    in_pool = function(self)
        return Cracker.dx_blinds_enabled() and (G.GAME.round_resets.ante == 2 or G.GAME.round_resets.ante >= G.GAME.win_ante)
    end,
    mult = 2,
    boss_colour = HEX("892222"),
    atlas = 'dx_blinds',
    pos = { y = 23 },
    dollars = 5,
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.press_play then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.2,
                    func = function()
                        for i = 1, #G.play.cards do
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    G.play.cards[i]:juice_up()
                                    return true
                                end,
                            }))
                            ease_dollars(-1)
                            delay(0.23)
                        end
                        return true
                    end
                }))
                blind.triggered = true
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = (function()
                        SMODS.juice_up_blind()
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.06 * G.SETTINGS.GAMESPEED,
                            blockable = false,
                            blocking = false,
                            func = function()
                                play_sound('tarot2', 0.76, 0.4)
                                return true
                            end
                        }))
                        play_sound('tarot2', 1, 0.4)
                        return true
                    end)
                }))
                delay(0.4)
            elseif context.discard then
                ease_dollars(-1)
                delay(0.23)
            end
        end
    end,
}

SMODS.Blind { -- The Flint
    object_type = "Blind",
    key = 'flint_dx',
    boss = {
        min = 2,
        dx = true,
    },
    in_pool = function(self)
        return Cracker.dx_blinds_enabled() and G.GAME.round_resets.ante >= 6
    end,
    mult = 1,
    boss_colour = HEX("ad5024"),
    atlas = 'dx_blinds',
    pos = { y = 25 },
    dollars = 5,
}

SMODS.Blind { -- The Mark
    object_type = "Blind",
    key = 'mark_dx',
    boss = {
        min = 2,
        dx = true,
    },
    in_pool = function(self)
        return Cracker.dx_blinds_enabled() and (G.GAME.round_resets.ante == 4 or G.GAME.round_resets.ante >= G.GAME.win_ante)
    end,
    mult = 2,
    boss_colour = HEX("502b36"),
    atlas = 'dx_blinds',
    pos = { y = 24 },
    dollars = 5,
    set_blind = function(self)
        local deck_length = #G.deck.cards
        for i=1, deck_length do
            if G.deck.cards[i]:get_id() == 11 or G.deck.cards[i]:get_id() == 12 or G.deck.cards[i]:get_id() == 13 then
                draw_card(G.deck, G.discard, nil, 'up', nil, G.deck.cards[i])
            end
        end
    end,
}

SMODS.Blind { -- Amber Acorn
    object_type = "Blind",
    key = 'final_acorn_dx',
    boss = {
        dx = true,
        showdown = true
    },
    in_pool = function(self)
        return Cracker.dx_blinds_enabled()
    end,
    mult = 2,
    boss_colour = HEX("fda200"),
    atlas = 'dx_blinds',
    pos = { y = 28 },
    dollars = 8,
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.setting_blind then
                if #G.jokers.cards > 0 then
                    G.jokers:unhighlight_all()
                    for _, joker in ipairs(G.jokers.cards) do
                        joker:flip()
                    end
                    if #G.jokers.cards > 1 then
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.2,
                            func = function()
                                G.E_MANAGER:add_event(Event({
                                    func = function()
                                        if G.CONTROLLER.dragging.target then 
                                            G.CONTROLLER.dragging.target:stop_drag()
                                            G.CONTROLLER.dragging.target.states.drag.is = false
                                            G.CONTROLLER.dragging.target = nil
                                        end
                                        G.jokers:shuffle('aajk')
                                        play_sound('cardSlide1', 0.85)
                                        return true
                                    end,
                                }))
                                delay(0.15)
                                G.E_MANAGER:add_event(Event({
                                    func = function()
                                        G.jokers:shuffle('aajk')
                                        play_sound('cardSlide1', 1.15)
                                        return true
                                    end
                                }))
                                delay(0.15)
                                G.E_MANAGER:add_event(Event({
                                    func = function()
                                        G.jokers:shuffle('aajk')
                                        play_sound('cardSlide1', 1)
                                        return true
                                    end
                                }))
                                delay(0.5)
                                return true
                            end
                        }))
                    end
                end
            end
        end
    end,
}

local eval_status_text_ref = card_eval_status_text
function card_eval_status_text(card, eval_type, amt, percent, dir, extra)
    if G.GAME.blind and (G.GAME.blind.name == 'bl_cracker_final_acorn_dx' or G.GAME.blind.name == 'bl_cracker_aij_the_bird_dx') and card and card.ability and card.ability.set == 'Joker' and not G.GAME.blind.disabled then
        return true
    else
        eval_status_text_ref(card, eval_type, amt, percent, dir, extra)
    end
end

SMODS.Blind { -- Verdant Leaf
    object_type = "Blind",
    key = 'final_leaf_dx',
    boss = {
        dx = true,
        showdown = true
    },
    in_pool = function(self)
        return Cracker.dx_blinds_enabled()
    end,
    mult = 2,
    boss_colour = HEX("56a786"),
    atlas = 'dx_blinds',
    pos = { y = 29 },
    dollars = 8,
    config = { extra = { disable = true } },
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.selling_card and context.card.ability.set == 'Joker' then
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = function()
                        for _, joker in ipairs(G.jokers.cards) do
                            SMODS.debuff_card(joker, false, 'leaf_dx')
                        end
                        return true
                    end
                }))
            end
            if context.after then
                for _, joker in ipairs(G.jokers.cards) do
                    SMODS.debuff_card(joker, true, 'leaf_dx')
                end
            end
        end
    end,
    set_blind = function(self)
        for _, joker in ipairs(G.jokers.cards) do
            SMODS.debuff_card(joker, true, 'leaf_dx')
        end
    end,
    disable = function(self)
        for _, joker in ipairs(G.jokers.cards) do
            SMODS.debuff_card(joker, false, 'leaf_dx')
        end
    end,
    defeat = function(self)
        for _, joker in ipairs(G.jokers.cards) do
            SMODS.debuff_card(joker, false, 'leaf_dx')
        end
    end
}

SMODS.Blind { -- Violet Vessel
    object_type = "Blind",
    key = 'final_vessel_dx',
    boss = {
        dx = true,
        showdown = true
    },
    in_pool = function(self)
        return Cracker.dx_blinds_enabled()
    end,
    mult = 10,
    boss_colour = HEX("8a71e1"),
    atlas = 'dx_blinds',
    pos = { y = 30 },
    dollars = 8,
    disable = function(self)
        G.GAME.blind.chips = G.GAME.blind.chips / 5
        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
    end
}

SMODS.Blind { -- Crimson Heart
    object_type = "Blind",
    key = 'final_heart_dx',
    boss = {
        dx = true,
        showdown = true
    },
    in_pool = function(self)
        return Cracker.dx_blinds_enabled()
    end,
    mult = 2,
    boss_colour = HEX("ac3232"),
    atlas = 'dx_blinds',
    pos = { y = 26 },
    dollars = 8,
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.before then
                local card_count = #G.jokers.cards
                for i, joker in ipairs(G.jokers.cards) do
                    if i == 1 or i == card_count then
                        SMODS.debuff_card(joker, true, 'heart_dx')
                    else
                        SMODS.debuff_card(joker, false, 'heart_dx')
                    end
                end
            end
        end
    end,
    disable = function(self)
        for _, joker in ipairs(G.jokers.cards) do
            SMODS.debuff_card(joker, false, 'heart_dx')
        end
    end,
    defeat = function(self)
        for _, joker in ipairs(G.jokers.cards) do
            SMODS.debuff_card(joker, false, 'heart_dx')
        end
    end,
}

SMODS.Blind { -- Cerulean Bell
    object_type = "Blind",
    key = 'final_bell_dx',
    boss = {
        dx = true,
        showdown = true
    },
    in_pool = function(self)
        return Cracker.dx_blinds_enabled()
    end,
    mult = 2,
    boss_colour = HEX("007ecb"),
    atlas = 'dx_blinds',
    pos = { y = 27 },
    dollars = 8,
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.hand_drawn then
                local any_forced = nil
                local temp_hand = {}
                for _, playing_card in ipairs(G.hand.cards) do
                    temp_hand[#temp_hand + 1] = playing_card
                end
                if temp_hand[1] then
                    pseudoshuffle(temp_hand, 'bell_dx')
                    G.hand:unhighlight_all()
                    temp_hand[1].ability.forced_selection = true
                    G.hand:add_to_highlighted(temp_hand[1])
                    temp_hand[2].ability.forced_selection = true
                    G.hand:add_to_highlighted(temp_hand[2])
                end
            end
        end
    end,
    disable = function(self)
        for _, playing_card in ipairs(G.playing_cards) do
            playing_card.ability.forced_selection = nil
        end
    end
}
