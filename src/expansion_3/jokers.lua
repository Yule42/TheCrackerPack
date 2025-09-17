SMODS.Joker{ --Student
    name = "Student",
    key = "student",
    config = {
        extra = {
        }
    },
    pos = {
        x = 0,
        y = 4,
    },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    in_pool = function(self, args)
        for k, v in pairs(G.playing_cards) do
            if v.config.center.key == 'm_cracker_multi' or v.config.center.key == 'm_cracker_sequenced' then
                return true
            end
        end
    end,
    

    loc_vars = function(self, info_queue, card)
        if card and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'None', 'sophiedeergirl'}, key = 'artist_credits_cracker'} end
        info_queue[#info_queue + 1] = G.P_CENTERS.m_cracker_multi
        info_queue[#info_queue + 1] = G.P_CENTERS.m_cracker_sequenced
        return {vars = {}}
    end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and not context.repetition_only then
            if context.other_card.config.center.key == 'm_cracker_sequenced' or context.other_card.config.center.key == 'm_cracker_multi' then
                return {
                    message = localize('k_again_ex'),
                    repetitions = 1,
                    card = card,
                }
            end
        end
    end
}

SMODS.Joker{ --Silver Coin
    name = "Silver Coin",
    key = "silver_coin",
    config = {
        extra = {
            dollars = 4,
        }
    },
    pos = {
        x = 1,
        y = 4,
    },
    cost = 5,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    enhancement_gate = 'm_cracker_silver',
    

    loc_vars = function(self, info_queue, card)
        if card and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'None', 'sugariimarii'}, key = 'artist_credits_cracker'} end
        info_queue[#info_queue + 1] = G.P_CENTERS.m_cracker_silver
        return {vars = {card.ability.extra.dollars}}
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.individual then
            if context.other_card.config.center.key == 'm_cracker_silver' then
                return {
                    dollars = card.ability.extra.dollars
                }
            end
        end
    end
}

SMODS.Joker{ --Multijoker
    name = "Multijoker",
    key = "multijoker",
    config = {
        extra = {
            mult = 4,
        }
    },
    pos = {
        x = 2,
        y = 4,
    },
    cost = 6,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    enhancement_gate = 'm_mult',
    

    loc_vars = function(self, info_queue, card)
        if card and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'None', 'eternalqueenmelori'}, key = 'artist_credits_cracker'} end
        info_queue[#info_queue + 1] = G.P_CENTERS.m_mult
        local mult_count = 0
        if G.playing_cards then
            for _, playing_card in ipairs(G.playing_cards) do
                if SMODS.has_enhancement(playing_card, 'm_mult') then mult_count = mult_count + 1 end
            end
        end
        return {vars = {card.ability.extra.mult, mult_count * card.ability.extra.mult}}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local mult_count = 0
            for _, playing_card in ipairs(G.playing_cards) do
                if SMODS.has_enhancement(playing_card, 'm_mult') then mult_count = mult_count + 1 end
            end
            return {
                mult = card.ability.extra.mult * mult_count,
            }
        end
    end
}

SMODS.Joker{ --Bonus Joker
    name = "Bonus Joker",
    key = "bonus_joker",
    config = {
        extra = {
            odds = 4,
        }
    },
    pos = {
        x = 3,
        y = 4,
    },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    enhancement_gate = 'm_bonus',
    

    loc_vars = function(self, info_queue, card)
        if card and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'None', 'sugariimarii'}, key = 'artist_credits_cracker'} end
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bonus
        info_queue[#info_queue + 1] = G.P_CENTERS.e_foil
        info_queue[#info_queue + 1] = G.P_CENTERS.e_holo
        local new_numerator, new_denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'bonus_joker')
        return {vars = {new_numerator, new_denominator}}
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card.config.center.key == 'm_bonus' then
            local aura_card = context.other_card
            if context.other_card:get_edition() == nil and not aura_card.bonus_joker_mark and SMODS.pseudorandom_probability(card, 'bonus_joker', 1, card.ability.extra.odds, 'bonus_joker') then
                local edition = poll_edition('bonus_joker', nil, true, true, { 'e_holo', 'e_foil' })
                aura_card.bonus_joker_mark = true
                local target_card = aura_card
                local triggering_card = context.blueprint and context.blueprint_card or card
                target_card:set_edition(edition, true, true, true)
                G.E_MANAGER:add_event(Event {
                    trigger = 'after',
                    delay = 0.0,
                    func = function()
                        if edition == 'e_foil' then play_sound('foil1', 1.2, 0.4) end
                        if edition == 'e_holo' then play_sound('holo1', 1.2*1.58, 0.4) end
                        triggering_card:juice_up(0.3, 0.5)
                        target_card.bonus_joker_mark = nil
                        return true
                    end
                })
            end
        end
    end
}

SMODS.Joker{ --Dirty Joker
    name = "Dirty Joker",
    key = "dirty_joker",
    config = {
        extra = {
            mult = 0,
            mult_gain = 4,
        }
    },
    pos = {
        x = 4,
        y = 4,
    },
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    enhancement_gate = 'm_cracker_soil',
    

    loc_vars = function(self, info_queue, card)
        if card and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'None', 'sugariimarii'}, key = 'artist_credits_cracker'} end
        info_queue[#info_queue + 1] = G.P_CENTERS.m_cracker_soil
        return {vars = {card.ability.extra.mult_gain, card.ability.extra.mult}}
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.individual and not context.blueprint then
            if context.other_card.config.center.key == 'm_cracker_soil' then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
                return {
                    message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult_gain}},
                    focus = card,
                }
            end
        elseif context.joker_main then
            return {
                mult = card.ability.extra.mult,
                colour = G.C.RED
            }
        end
    end
}

SMODS.Joker{ --Card Counter
    name = "Card Counter",
    key = "card_counter",
    config = {
        extra = {
            hand_size = 0,
        }
    },
    pos = {
        x = 5,
        y = 4,
    },
    cost = 6,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    enhancement_gate = 'm_cracker_cheater',
    

    loc_vars = function(self, info_queue, card)
        if card and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'None', 'sophiedeergirl'}, key = 'artist_credits_cracker'} end
        info_queue[#info_queue + 1] = G.P_CENTERS.m_cracker_cheater
        return {vars = {card.ability.extra.hand_size}}
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.hand:change_size(-card.ability.extra.hand_size)
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card.cheater_trigger and not context.blueprint then
            card.ability.extra.hand_size = card.ability.extra.hand_size + 1
            G.hand:change_size(1)
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.FILTER,
                message_card = card
            }
        elseif context.setting_blind and not context.blueprint then
            G.hand:change_size(-card.ability.extra.hand_size)
            card.ability.extra.hand_size = 0
            return {
                message = localize('k_reset'),
                colour = G.C.FILTER,
                card = card,
            }
        end
    end
}

SMODS.Joker{ --Tempered Glass
    name = "Tempered Glass",
    key = "tempered_glass",
    config = {
        extra = {
            add_xmult = 0.1
        }
    },
    pos = {
        x = 6,
        y = 4,
    },
    cost = 7,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    enhancement_gate = 'm_glass',
    

    loc_vars = function(self, info_queue, card)
        if card and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'None', 'palestjade'}, key = 'artist_credits_cracker'} end
        return {vars = {card.ability.extra.add_xmult}}
    end,
    calculate = function(self, card, context)
        if context.remove_playing_cards then
            for k, v in ipairs(context.removed) do
                if v.config.center.key == 'm_glass' then
                    G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                    local _card = copy_card(v, nil, nil, G.playing_card)
                    _card.ability.Xmult = _card.ability.Xmult + card.ability.extra.add_xmult
                    _card:add_to_deck()
                    G.deck.config.card_limit = G.deck.config.card_limit + 1
                    G.deck:emplace(_card)
                    table.insert(G.playing_cards, _card)
                    playing_card_joker_effects({true})
                    G.E_MANAGER:add_event(Event({
                        func = function() 
                            _card:start_materialize()
                            return true
                    end}))
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, { message = localize('k_copied_ex'), colour = G.C.FILTER })
                end
            end
        elseif context.cards_destroyed then
            for k, v in ipairs(context.glass_shattered) do
                G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                local _card = copy_card(v, nil, nil, G.playing_card)
                _card.ability.Xmult = _card.ability.Xmult + card.ability.extra.add_xmult
                _card:add_to_deck()
                G.deck.config.card_limit = G.deck.config.card_limit + 1
                G.deck:emplace(_card)
                table.insert(G.playing_cards, _card)
                playing_card_joker_effects({true})
                G.E_MANAGER:add_event(Event({
                    func = function() 
                        _card:start_materialize()
                        return true
                end}))
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, { message = localize('k_copied_ex'), colour = G.C.FILTER })
            end
        end
    end
}

SMODS.Joker{ --Black Cat
    name = "Black Cat",
    key = "black_cat",
    config = {
        extra = {
            mult = 0,
            mult_add = 1,
            FPS = 16,
            delay = 0,
            x_pos = 0,
        }
    },
    pos = {
        x = 0,
        y = 5,
    },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    enhancement_gate = 'm_lucky',

    loc_vars = function(self, info_queue, card)
        if card and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'None', 'papiliu'}, key = 'artist_credits_cracker'} end
        info_queue[#info_queue + 1] = G.P_CENTERS.m_lucky
        return {vars = {card.ability.extra.mult, card.ability.extra.mult_add}}
    end,
    
    update = function(self, card, dt)
        if card.ability.extra.delay >= 1 / card.ability.extra.FPS then
            card.ability.extra.x_pos = (card.ability.extra.x_pos + 1) % 5 -- 5 is the number of frames
            card.children.center:set_sprite_pos({x=card.ability.extra.x_pos,y=5})
            card.ability.extra.delay = 0
        end
        card.ability.extra.delay = card.ability.extra.delay + love.timer.getDelta() -- dt kept returning 0
    end,
    
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.individual and context.other_card.config.center.key == 'm_lucky' then
            if not context.blueprint then
                if context.other_card.lucky_trigger then
                    --[[card.ability.extra.mult = 0
                    return {
                        message = localize('k_reset'),
                        colour = G.C.FILTER
                    }--]]
                else
                    SMODS.scale_card(card, {
                        ref_table = card.ability.extra,
                        ref_value = "mult",
                        scalar_value = "mult_add",
                        operation = "+",
                        message_key = 'a_mult',
                        message_colour = G.C.RED
                    })
                end
            end
        elseif context.joker_main and card.ability.extra.mult > 0 then
            return {
                mult = card.ability.extra.mult,
                colour = G.C.RED
            }
        end
    end
}