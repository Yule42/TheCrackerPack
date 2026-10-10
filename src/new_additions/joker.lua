SMODS.Joker{ --Charcuterie Board
    key = "charcuterie_board",
    config = {
        extra = {
            chips = 300,
            odds = 300
        }
    },
    pos = {
        x = 0,
        y = 4
    },
    pools = {
        Food = true,
    },
    attributes = { 'chips', 'chance', 'food' },
    cost = 3,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    yes_pool_flag = 'saltine_cracker_eaten',
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'gfsg', 'DistantMind'}, key = 'artist_credits_cracker'} end
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'cracker_Charcuterie Board')
        return {vars = {card.ability.extra.chips, numerator, denominator}}
    end,
    calculate = function(self, card, context)
        if context.after and not context.blueprint and not context.repetition then
            if SMODS.pseudorandom_probability(card, 'cracker_Charcuterie Board', 1, card.ability.extra.odds, 'cracker_Charcuterie Board') then
                SMODS.destroy_cards(card, { pinch_anim = true })
                return {
                    message = localize('k_eaten_ex'),
                    colour = G.C.CHIPS
                }
            else
                return {
                    message = localize('k_safe_ex'),
                    colour = G.C.CHIPS
                }
            end
        elseif context.cardarea == G.jokers and context.joker_main and context.scoring_hand and card.ability.extra.chips > 0 then
            return {
                chips = card.ability.extra.chips, 
            }
        end
    end
}

SMODS.Joker{ --Knight
    key = "knight",
    config = {
        extra = {
        }
    },
    pos = {
        x = 4,
        y = 4,
    },
    cost = 5,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    attributes = { 'passive', 'face' },
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'sugariimarii, lumahoneyy', 'sugariimarii, sophiedeergirl'}, key = 'artist_credits_cracker'} end
        return {vars = {}}
    end,
    calculate = function(self, card, context)
        if context.modify_scoring_hand and not context.blueprint then
            if context.other_card:is_face() then
                return {
                    add_to_hand = true,
                }
            end
        elseif context.debuff_card and not context.blueprint then
            if context.debuff_card:is_face() then
                return {
                    prevent_debuff = true,
                }
            end
        end
    end
}

SMODS.Joker{ --U.F.O.
    key = "ufo",
    config = {
        extra = {
            mult = 0,
            counter = 3,
            counter_max = 3
        }
    },
    pos = {
        x = 3,
        y = 4
    },
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'sugariimarii', 'sophiedeergirl, sugariimarii'}, key = 'artist_credits_cracker'} end
        return {vars = {card.ability.extra.mult, card.ability.extra.counter, card.ability.extra.counter_max}}
    end,
    
    calculate = function(self, card, context)
        if context.before and card.ability.extra.counter == 1 and G.GAME.hands[context.scoring_name].level > 1 and not context.blueprint then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "mult",
                scalar_table = G.GAME.hands[context.scoring_name],
                scalar_value = "l_mult",
                operation = function(ref_table, ref_value, initial, change)
                    ref_table[ref_value] = initial + change*3
                end,
            })
            return {
                level_up = -1,
                no_retrigger = true
            }
        elseif context.after and not context.blueprint then
            card.ability.extra.counter = card.ability.extra.counter - 1
            if card.ability.extra.counter == 1 then
                local eval = function() return card.ability.extra.counter == 1 and not G.RESET_JIGGLES end
                juice_card_until(card, eval, true)
            elseif card.ability.extra.counter <= 0 then
                card.ability.extra.counter = card.ability.extra.counter_max
            end
		elseif context.joker_main then
			return {
                mult = card.ability.extra.mult,
            }
		end
    end
}

SMODS.Joker{ -- Sailor
    key = "sailor",
    config = {
        extra = {
            planets = 0,
            planets_max = 3
        }
    },
    pos = {
        x = 6,
        y = 4
    },
    cost = 5,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'Infamousinvictis', 'sophiedeergirl'}, key = 'artist_credits_cracker'} end
        return {vars = {card.ability.extra.planets, card.ability.extra.planets_max}}
    end,
    
    calculate = function(self, card, context)
        if context.using_consumeable and context.consumeable.ability.set == 'Planet' then
            if not context.retrigger_planet_cards then
                if not context.blueprint then
                    card.ability.extra.planets = card.ability.extra.planets + 1
                end
                if card.ability.extra.planets >= card.ability.extra.planets_max or (context.blueprint and context.blueprint_card.T.x < card.T.x and card.ability.extra.planets == card.ability.extra.planets_max - 1) then
                    SMODS.calculate_context({using_consumeable = true, consumeable = context.consumeable, area = context.from_area, retrigger_planet_cards = true})
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_again_ex'), colour = G.C.FILTER})
                    context.consumeable:use_consumeable(context.area)
                    if not context.blueprint then
                        G.E_MANAGER:add_event(Event({
                            func = function() 
                                card.ability.extra.planets = 0
                                return true
                        end}))
                    end
                    return nil, true
                end
            end
        end
    end
}

SMODS.Joker{ -- Spider
    key = "spider",
    config = {
        extra = {
            cards_draw = 13
        }
    },
    pos = {
        x = 7,
        y = 4
    },
    cost = 6,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'Infamousinvictis', 'palestjade, brook03, sugariimarii'}, key = 'artist_credits_cracker'} end
        return {vars = {card.ability.extra.cards_draw, localize('Straight Flush', 'poker_hands')}}
    end,
    
    calculate = function(self, card, context)
        if context.press_play and not context.blueprint then
            if G.FUNCS.get_poker_hand_info(G.hand.highlighted) == 'Straight Flush' then
                SMODS.draw_cards(card.ability.extra.cards_draw)
            end
        end
    end
}

SMODS.Joker{ -- Circuit Board
    key = "circuit_board",
    config = {
        extra = {
            slot_copy = 1,
        }
    },
    pos = {
        x = 8,
        y = 4
    },
    cost = 10,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'Infamousinvictis', 'sophiedeergirl'}, key = 'artist_credits_cracker'} end
        local main_end
        if card.area and card.area == G.jokers then
            local other_joker = G.jokers.cards[card.ability.extra.slot_copy] or nil
            local compatible = other_joker and other_joker ~= card and other_joker.config.center.blueprint_compat
            main_end = {
                {
                    n = G.UIT.C,
                    config = { align = "bm", minh = 0.4 },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = { ref_table = card, align = "m", colour = compatible and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8) or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8), r = 0.05, padding = 0.06 },
                            nodes = {
                                { n = G.UIT.T, config = { text = ' ' .. localize('k_' .. (compatible and 'compatible' or 'incompatible')) .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.8 } },
                            }
                        }
                    }
                }
            }
        end
        return {vars = {card.ability.extra.slot_copy}, main_end = main_end}
    end,
    set_ability = function(self, card, initial, delay_sprites)
        G.E_MANAGER:add_event(Event({
            func = function()
                if not G.SETTINGS.paused and initial and not (card.area and card.area.config.collection) then
                    card.ability.extra.slot_copy = pseudorandom("cracker_circuit_board", 1, #G.jokers.cards)
                end
                return true
        end}))
    end,
    calculate = function(self, card, context)
        local other_joker = G.jokers.cards[card.ability.extra.slot_copy] or nil
        local ret = SMODS.blueprint_effect(card, other_joker, context)
        if ret then
            ret.colour = G.C.GREEN
        end
        return ret
    end
}

SMODS.Joker{ -- Painter
    key = "painter",
    config = {
        extra = {
            mult = 10,
            above = 7
        }
    },
    pos = {
        x = 0,
        y = 5
    },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'Le Ginger', 'palestjade'}, key = 'artist_credits_cracker'} end
        local mult = math.max(0, card.ability.extra.mult * ((G.hand and G.hand.config.card_limit or 8) - card.ability.extra.above))
        return {vars = { card.ability.extra.mult, card.ability.extra.above, mult }}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = math.max(0, card.ability.extra.mult * ((G.hand and G.hand.config.card_limit or 8) - card.ability.extra.above)),
            }
        end
    end,
}

SMODS.Joker{ -- Tax Collector
    key = "tax_collector",
    config = {
        extra = {
        }
    },
    pos = {
        x = 1,
        y = 5
    },
    cost = 6,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'Le Ginger', 'sophiedeergirl'}, key = 'artist_credits_cracker'} end
        return {vars = { }}
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == "unscored" then
            if context.other_card.debuff then
                return {
                    message = localize('k_debuffed'),
                    colour = G.C.RED,
                }
            else
                return { mult = math.floor(context.other_card:get_chip_bonus()/2) }
            end
        end
    end,
}
