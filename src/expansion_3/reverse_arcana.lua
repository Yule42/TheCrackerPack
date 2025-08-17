SMODS.ConsumableType{
    key = 'reversetarot',
    primary_colour = HEX('424e54'),
    secondary_colour = HEX('7360bf'),
    loc_txt = {
        collection = "Reverse Arcana Cards",
        name = "Reverse Arcana",
        label = "Reverse Arcana",
    },
    collection_rows = { 5, 6 },
    default = 'c_cracker_strength',
}

SMODS.Consumable{ -- The Fool
    set = 'reversetarot',
    atlas = 'reversearcana',
    key = 'fool',
    config = {
        extra = {
        }
    },
    
    pos = {
        x = 0,
        y = 0
    },
    
    unlocked = true,
    discovered = true,
    
    loc_vars = function(self, info_queue, card)
        local last_spectral = G.GAME.last_spectral and G.P_CENTERS[G.GAME.last_spectral] or nil
        local colour = last_spectral and G.C.GREEN or G.C.RED
        local last_spectral_name = last_spectral and localize{type = 'name_text', key = last_spectral.key, set = last_spectral.set} or localize('k_none')
        info = {
            {n=G.UIT.C, config={align = "bm", padding = 0.02}, nodes={
                {n=G.UIT.C, config={align = "m", colour = colour, r = 0.05, padding = 0.05}, nodes={
                    {n=G.UIT.T, config={text = ' '..last_spectral_name..' ',colour = G.C.UI.TEXT_LIGHT, scale = 0.3, shadow = true}},
                }}
            }}
        }
        return {vars = {last_spectral_name}, main_end = info}
    end,

    can_use = function(self, card)
        return G.GAME.last_spectral
    end,

    use = function(self, card)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                if G.consumeables.config.card_limit > #G.consumeables.cards then
                    play_sound('timpani')
                    SMODS.add_card({ key = G.GAME.last_spectral })
                    card:juice_up(0.3, 0.5)
                end
                return true
            end
        }))
        delay(0.6)
    end,
}

SMODS.Consumable{ -- The Magician
    atlas = 'reversearcana',
    set = 'reversetarot',
    key = 'magician',
    pos = { 
        x = 1,
        y = 0
    },
    config = { 
        max_highlighted = 2, 
        mod_conv = 'm_cracker_cheater'
    },
    
    unlocked = true,
    discovered = true,
    
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.mod_conv]
        return { vars = { card.ability.max_highlighted, localize { type = 'name_text', set = 'Enhanced', key = card.ability.mod_conv } } }
    end
}

SMODS.Consumable{ -- High Priestess
    set = 'reversetarot',
    atlas = 'reversearcana',
    key = 'high_priestess',
    config = {
        extra = {
            cards = 2,
        }
    },
    
    pos = {
        x = 2,
        y = 0
    },
    
    unlocked = true,
    discovered = true,
    
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.cards}}
    end,

    can_use = function(self, card)
        return true
    end,

    use = function(self, card)
        local hands = Cracker.get_ordered_list_of_hands()
        local least = {}
        for i = 1, card.ability.extra.cards do
            local j = 0
            least[i] = hands[#hands + 1 - (SMODS.showman() and 1 or i)].planet_key
            while ((Cracker.is_in_consumeables(least[i]) or Cracker.is_in_array(least[i], i, least)) and j < #hands - 1) and not SMODS.showman() do
                j = j + 1
                if j == #hands - 1 then -- just give up and give em pluto
                    least[i] = 'c_pluto'
                else
                    least[i] = hands[#hands + 1 - i - j].planet_key
                end
            end
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    play_sound('timpani')
                    local ccard = SMODS.add_card({ set = 'Planet', key = least[i] })
                    ccard:set_edition({ negative = true }, true)
                    card:juice_up(0.3, 0.5)
                    return true
                end
            }))
        end
        delay(0.6)
    end,
}

SMODS.Consumable{ -- The Empress
    atlas = 'reversearcana',
    set = 'reversetarot',
    key = 'empress',
    pos = { 
        x = 3,
        y = 0
    },
    config = { 
        max_highlighted = 2, 
        mod_conv = 'm_cracker_multi'
    },
    
    unlocked = true,
    discovered = true,
    
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.mod_conv]
        return { vars = { card.ability.max_highlighted, localize { type = 'name_text', set = 'Enhanced', key = card.ability.mod_conv } } }
    end
}

SMODS.Consumable{ -- The Emperor
    set = 'reversetarot',
    atlas = 'reversearcana',
    key = 'emperor',
    config = {
        extra = {
            cards = 2,
        }
    },
    
    pos = {
        x = 4,
        y = 0
    },
    
    unlocked = true,
    discovered = true,
    
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.cards}}
    end,

    can_use = function(self, card)
        return G.consumeables and #G.consumeables.cards < G.consumeables.config.card_limit
    end,

    use = function(self, card)
        for i=1, math.min(G.consumeables.config.card_limit, card.ability.extra.cards) do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    if G.consumeables.config.card_limit > #G.consumeables.cards then
                        play_sound('timpani')
                        local ccard = SMODS.add_card({ set = 'Tarot', key = 'c_fool' })
                        card:juice_up(0.3, 0.5)
                    end
                    return true
                end
            }))
        end
    end,
}

SMODS.Consumable{ -- The Hierophant
    atlas = 'reversearcana',
    set = 'reversetarot',
    key = 'hierophant',
    pos = { 
        x = 5,
        y = 0
    },
    config = { 
        max_highlighted = 2, 
        mod_conv = 'm_cracker_sequenced'
    },
    
    unlocked = true,
    discovered = true,
    
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.mod_conv]
        return { vars = { card.ability.max_highlighted, localize { type = 'name_text', set = 'Enhanced', key = card.ability.mod_conv } } }
    end
}

SMODS.Consumable{ -- The Lovers
    atlas = 'reversearcana',
    set = 'reversetarot',
    key = 'lovers',
    pos = { 
        x = 6,
        y = 0
    },
    config = { 
        max_highlighted = 2, 
        mod_conv = 'm_cracker_mild'
    },
    
    unlocked = true,
    discovered = true,
    
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.mod_conv]
        return { vars = { card.ability.max_highlighted, localize { type = 'name_text', set = 'Enhanced', key = card.ability.mod_conv } } }
    end
}

SMODS.Consumable{ -- The Chariot
    atlas = 'reversearcana',
    set = 'reversetarot',
    key = 'chariot',
    pos = { 
        x = 7,
        y = 0
    },
    config = { 
        max_highlighted = 1, 
        mod_conv = 'm_cracker_scrap_metal'
    },
    
    unlocked = true,
    discovered = true,
    
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.mod_conv]
        return { vars = { card.ability.max_highlighted, localize { type = 'name_text', set = 'Enhanced', key = card.ability.mod_conv } } }
    end
}

SMODS.Consumable{ -- Justice
    atlas = 'reversearcana',
    set = 'reversetarot',
    key = 'justice',
    pos = { 
        x = 8,
        y = 0
    },
    config = { 
        max_highlighted = 2, 
        mod_conv = 'm_cracker_annealed'
    },
    
    unlocked = true,
    discovered = true,
    
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.mod_conv]
        return { vars = { card.ability.max_highlighted, localize { type = 'name_text', set = 'Enhanced', key = card.ability.mod_conv } } }
    end
}

SMODS.Consumable{ -- The Wheel of Fortune
    atlas = 'reversearcana',
    set = 'reversetarot',
    key = 'wheel_of_fortune',
    pos = {
        x = 0,
        y = 1
    },
    config = {
        extra = {
            odds = 2,
        }
    },
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'wheel_of_fortune')
        return { vars = { numerator, denominator } }
    end,
    use = function(self, card, area, copier)
        if SMODS.pseudorandom_probability(card, 'wheel_of_fortune', 1, card.ability.extra.odds) then
            local editionless_jokers = SMODS.Edition:get_edition_cards(G.jokers, true)

            local eligible_card = pseudorandom_element(editionless_jokers, 'wheel_of_fortune')
            local edition = poll_edition('wheel_of_fortune', nil, true, true,
                { 'e_cracker_laminated', 'e_cracker_crystalline', 'e_cracker_sleeved' })
            eligible_card:set_edition(edition, true)
            check_for_unlock({ type = 'have_edition' })
        else
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    attention_text({
                        text = localize('k_nope_ex'),
                        scale = 1.3,
                        hold = 1.4,
                        major = card,
                        backdrop_colour = G.C.SECONDARY_SET.Tarot,
                        align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and
                            'tm' or 'cm',
                        offset = { x = 0, y = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and -0.2 or 0 },
                        silent = true
                    })
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
                    card:juice_up(0.3, 0.5)
                    return true
                end
            }))
        end
    end,
    can_use = function(self, card)
        return next(SMODS.Edition:get_edition_cards(G.jokers, true))
    end
}

SMODS.Consumable{ -- Hermit
    set = 'reversetarot',
    atlas = 'reversearcana',
    key = 'hermit',
    config = {
        extra = {
            tag = 'tag_cracker_interest',
        }
    },
    
    pos = {
        x = 9,
        y = 0
    },
    
    unlocked = true,
    discovered = true,
    
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_TAGS.tag_cracker_interest
        return {vars = {localize{type = 'name_text', key = card.ability.extra.tag, set = 'Tag'}}}
    end,

    can_use = function(self, card)
        return true
    end,

    use = function(self, card)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
                play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                add_tag(Tag(card.ability.extra.tag))
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
    end,
}

SMODS.Consumable{ -- Strength
    set = 'reversetarot',
    atlas = 'reversearcana',
    key = 'strength',
    config = {
        max_highlighted = 2,
    },
    
    pos = {
        x = 1,
        y = 1
    },
    
    unlocked = true,
    discovered = true,
    
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.max_highlighted}}
    end,

    use = function(self, card)
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('tarot1')
            card:juice_up(0.3, 0.5)
        return true end }))
        for i=1, #G.hand.highlighted do
            local percent = 1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:flip();play_sound('card1', percent);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
        end
        delay(0.2)
        for i=1, #G.hand.highlighted do
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                local card = G.hand.highlighted[i]
                local suit_prefix = string.sub(card.base.suit, 1, 1)..'_'
                local rank_suffix = card.base.id == 2 and 14 or math.min(card.base.id-1, 14)
                if rank_suffix < 10 then rank_suffix = tostring(rank_suffix)
                elseif rank_suffix == 10 then rank_suffix = 'T'
                elseif rank_suffix == 11 then rank_suffix = 'J'
                elseif rank_suffix == 12 then rank_suffix = 'Q'
                elseif rank_suffix == 13 then rank_suffix = 'K'
                elseif rank_suffix == 14 then rank_suffix = 'A'
                end
                card:set_base(G.P_CARDS[suit_prefix..rank_suffix])
            return true end }))
        end
        for i=1, #G.hand.highlighted do
            local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:flip();play_sound('tarot2', percent, 0.6);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
        end
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
        delay(0.5)
    end,
}

SMODS.Consumable{ -- The Hanged Man
    set = 'reversetarot',
    atlas = 'reversearcana',
    key = 'hanged_man',
    config = {
        extra = {
            cards = 2,
        }
    },
    
    pos = {
        x = 2,
        y = 1
    },
    
    unlocked = true,
    discovered = true,
    
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.cards}}
    end,

    can_use = function(self, card)
        return #G.hand.highlighted <= card.ability.extra.cards
    end,

    use = function(self, card)
        G.E_MANAGER:add_event(Event({
            func = function()
                local _first_dissolve = nil
                local new_cards = {}
                for i = 1, math.min(card.ability.extra.cards, #G.hand.highlighted) do
                    G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                    local _card = copy_card(G.hand.highlighted[i], nil, nil, G.playing_card)
                    _card:add_to_deck()
                    G.deck.config.card_limit = G.deck.config.card_limit + 1
                    table.insert(G.playing_cards, _card)
                    G.hand:emplace(_card)
                    _card:start_materialize(nil, _first_dissolve)
                    _first_dissolve = true
                    new_cards[#new_cards + 1] = _card
                end
                SMODS.calculate_context({ playing_card_added = true, cards = new_cards })
                return true
            end
        }))
    end,
}

SMODS.Consumable{ -- Death
    set = 'reversetarot',
    atlas = 'reversearcana',
    key = 'death',
    config = {
        extra = {
            cards = 2,
        }
    },
    
    pos = {
        x = 3,
        y = 1
    },
    
    unlocked = true,
    discovered = true,
    
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.cards}}
    end,

    can_use = function(self, card)
        return #G.hand.highlighted <= card.ability.extra.cards
    end,

    use = function(self, card)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        for i = 1, #G.hand.highlighted do
            local percent = 1.15 - (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip()
                    play_sound('card1', percent)
                    G.hand.highlighted[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        delay(0.2)
        local left = G.hand.highlighted[1]
        local right = G.hand.highlighted[2]
        if right.T.x < left.T.x then
            local swap = left
            left = right
            right = swap
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                local rank = left.base.value
                local suit = left.base.suit
                copy_card(right, left)
                SMODS.change_base(left, suit, rank)
                right:set_ability(G.P_CENTERS.c_base)
                right:set_seal(nil, true, true)
                right:set_edition(nil, true, true)
                SMODS.destroy_cards(right)
                return true
            end
        }))
        for i = 1, #G.hand.highlighted do
            local percent = 0.85 + (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip()
                    play_sound('tarot2', percent, 0.6)
                    G.hand.highlighted[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
        delay(0.5)
    end,
}

SMODS.Consumable{ -- Temperance
    set = 'reversetarot',
    atlas = 'reversearcana',
    key = 'temperance',
    config = {
        extra = {
            multiply = 2,
        }
    },
    
    pos = {
        x = 4,
        y = 1
    },
    
    unlocked = true,
    discovered = true,
    
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.destroy}}
    end,

    can_use = function(self, card)
        return G.jokers and #G.jokers.cards > 0
    end,

    use = function(self, card)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                for k, v in ipairs(G.jokers.cards) do
                    v.sell_cost = v.sell_cost * card.ability.extra.multiply
                    v:juice_up(0.3, 0.5)
                end
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        delay(0.6)
    end,
}

SMODS.Consumable{ -- The Devil
    atlas = 'reversearcana',
    set = 'reversetarot',
    key = 'devil',
    pos = { 
        x = 5,
        y = 1
    },
    config = { 
        max_highlighted = 1, 
        mod_conv = 'm_cracker_silver'
    },
    
    unlocked = true,
    discovered = true,
    
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.mod_conv]
        return { vars = { card.ability.max_highlighted, localize { type = 'name_text', set = 'Enhanced', key = card.ability.mod_conv } } }
    end
}

SMODS.Consumable{ -- The Tower
    atlas = 'reversearcana',
    set = 'reversetarot',
    key = 'tower',
    pos = { 
        x = 6,
        y = 1
    },
    config = { 
        max_highlighted = 1, 
        mod_conv = 'm_cracker_soil'
    },
    
    unlocked = true,
    discovered = true,
    
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.mod_conv]
        return { vars = { card.ability.max_highlighted, localize { type = 'name_text', set = 'Enhanced', key = card.ability.mod_conv } } }
    end
}

SMODS.Consumable{ -- The Star
    set = 'reversetarot',
    atlas = 'reversearcana',
    key = 'star',
    config = {
        extra = {
            destroy = 3,
            suit_conv = 'Diamonds',
        }
    },
    
    pos = {
        x = 7,
        y = 1
    },
    
    unlocked = true,
    discovered = true,
    
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.destroy, localize(card.ability.extra.suit_conv, 'suits_singular'), colours = {G.C.SUITS[card.ability.extra.suit_conv]}}}
    end,

    can_use = function(self, card)
        return #G.hand.cards > 0
    end,

    use = function(self, card)
        local temp_hand = {}
        local destroyed_cards = {}
        for k, v in ipairs(G.hand.cards) do
            if v:is_suit(card.ability.extra.suit_conv) then
                temp_hand[#temp_hand+1] = v
            end
        end
        table.sort(temp_hand, function (a, b) return not a.playing_card or not b.playing_card or a.playing_card < b.playing_card end)
        pseudoshuffle(temp_hand, pseudoseed('star'))
        
        for i = 1, card.ability.extra.destroy do destroyed_cards[#destroyed_cards+1] = temp_hand[i] end
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('tarot1')
            card:juice_up(0.3, 0.5)
            return true end }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function() 
                for i=#destroyed_cards, 1, -1 do
                    local _card = destroyed_cards[i]
                    if _card.ability.name == 'Glass Card' then 
                        _card:shatter()
                    else
                        _card:start_dissolve(nil, i == #destroyed_cards)
                    end
                end
                return true end }))
        delay(0.6)
        for i = 1, #G.jokers.cards do
            G.jokers.cards[i]:calculate_joker({remove_playing_cards = true, removed = destroyed_cards})
        end
    end,
}

SMODS.Consumable{ -- The Moon
    set = 'reversetarot',
    atlas = 'reversearcana',
    key = 'moon',
    config = {
        extra = {
            destroy = 3,
            suit_conv = 'Clubs',
        }
    },
    
    pos = {
        x = 8,
        y = 1
    },
    
    unlocked = true,
    discovered = true,
    
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.destroy, localize(card.ability.extra.suit_conv, 'suits_singular'), colours = {G.C.SUITS[card.ability.extra.suit_conv]}}}
    end,

    can_use = function(self, card)
        local contains_suit = false
        for _, playing_card in ipairs(G.hand.cards) do
            if playing_card:is_suit(card.ability.extra.suit_conv, nil, true) then
                contains_suit = true
                break
            end
        end
        return #G.hand.cards > 0 and contains_suit
    end,

    use = function(self, card)
        local temp_hand = {}
        local destroyed_cards = {}
        for k, v in ipairs(G.hand.cards) do
            if v:is_suit(card.ability.extra.suit_conv) then
                temp_hand[#temp_hand+1] = v
            end
        end
        table.sort(temp_hand, function (a, b) return not a.playing_card or not b.playing_card or a.playing_card < b.playing_card end)
        pseudoshuffle(temp_hand, pseudoseed('moon'))
        
        for i = 1, card.ability.extra.destroy do destroyed_cards[#destroyed_cards+1] = temp_hand[i] end
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('tarot1')
            card:juice_up(0.3, 0.5)
            return true end }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function() 
                for i=#destroyed_cards, 1, -1 do
                    local _card = destroyed_cards[i]
                    if _card.ability.name == 'Glass Card' then 
                        _card:shatter()
                    else
                        _card:start_dissolve(nil, i == #destroyed_cards)
                    end
                end
                return true end }))
        delay(0.6)
        for i = 1, #G.jokers.cards do
            G.jokers.cards[i]:calculate_joker({remove_playing_cards = true, removed = destroyed_cards})
        end
    end,
}

SMODS.Consumable{ -- The Sun
    set = 'reversetarot',
    atlas = 'reversearcana',
    key = 'sun',
    config = {
        extra = {
            destroy = 3,
            suit_conv = 'Hearts',
        }
    },
    
    pos = {
        x = 9,
        y = 1
    },
    
    unlocked = true,
    discovered = true,
    
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.destroy, localize(card.ability.extra.suit_conv, 'suits_singular'), colours = {G.C.SUITS[card.ability.extra.suit_conv]}}}
    end,

    can_use = function(self, card)
        local contains_suit = false
        for _, playing_card in ipairs(G.hand.cards) do
            if playing_card:is_suit(card.ability.extra.suit_conv, nil, true) then
                contains_suit = true
                break
            end
        end
        return #G.hand.cards > 0 and contains_suit
    end,

    use = function(self, card)
        local temp_hand = {}
        local destroyed_cards = {}
        for k, v in ipairs(G.hand.cards) do
            if v:is_suit(card.ability.extra.suit_conv) then
                temp_hand[#temp_hand+1] = v
            end
        end
        table.sort(temp_hand, function (a, b) return not a.playing_card or not b.playing_card or a.playing_card < b.playing_card end)
        pseudoshuffle(temp_hand, pseudoseed('sun'))
        
        for i = 1, card.ability.extra.destroy do destroyed_cards[#destroyed_cards+1] = temp_hand[i] end
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('tarot1')
            card:juice_up(0.3, 0.5)
            return true end }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function() 
                for i=#destroyed_cards, 1, -1 do
                    local _card = destroyed_cards[i]
                    if _card.ability.name == 'Glass Card' then 
                        _card:shatter()
                    else
                        _card:start_dissolve(nil, i == #destroyed_cards)
                    end
                end
                return true end }))
        delay(0.6)
        for i = 1, #G.jokers.cards do
            G.jokers.cards[i]:calculate_joker({remove_playing_cards = true, removed = destroyed_cards})
        end
    end,
}

SMODS.Consumable{ -- Judgement
    set = 'reversetarot',
    atlas = 'reversearcana',
    key = 'judgement',
    config = {
        extra = {
        }
    },
    
    pos = {
        x = 0,
        y = 2
    },
    
    unlocked = true,
    discovered = true,
    
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.destroy}}
    end,

    can_use = function(self, card)
        local destructable_jokers = {}
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i] ~= card and not SMODS.is_eternal(G.jokers.cards[i], card) then
                destructable_jokers[#destructable_jokers + 1] = G.jokers.cards[i]
            end
        end
        return #destructable_jokers > 0 or (G.jokers and #G.jokers.cards < G.jokers.config.card_limit)
    end,

    use = function(self, card)
        local destructable_jokers = {}
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i] ~= card and not SMODS.is_eternal(G.jokers.cards[i], card) then
                destructable_jokers[#destructable_jokers + 1] = G.jokers.cards[i]
            end
        end
        local joker_to_destroy = pseudorandom_element(destructable_jokers, 'judgement')
        local destroyjoker = false
        local chosen_joker = nil
        local chosen_rarity = nil
        local edition = poll_edition("judgement", nil, false, true)
        if #destructable_jokers > 0 then
            destroyjoker = true
            chosen_joker = destructable_jokers[1]
            chosen_rarity = Cracker.base_rarities[chosen_joker.config.center.rarity] -- doesn't support custom rarities LMAO
        end
        G.E_MANAGER:add_event(Event{
            trigger = 'after',
            delay = 0.4,
            func = function()
                card:juice_up()
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                if destroyjoker then
                                    G.jokers:remove_card(chosen_joker)
                                    chosen_joker:remove()
                                    SMODS.add_card{set = 'Joker', rarity = chosen_rarity, edition = edition}
                                else
                                    SMODS.add_card{set = 'Joker', edition = edition}
                                end
                                return true
                            end
                        }))
                        return true
                    end
                }))

                return true
            end
        })
    end,
}

SMODS.Consumable{ -- The World
    set = 'reversetarot',
    atlas = 'reversearcana',
    key = 'world',
    config = {
        extra = {
            destroy = 3,
            suit_conv = 'Spades',
        }
    },
    
    pos = {
        x = 1,
        y = 2
    },
    
    unlocked = true,
    discovered = true,
    
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.destroy, localize(card.ability.extra.suit_conv, 'suits_singular'), colours = {G.C.SUITS[card.ability.extra.suit_conv]}}}
    end,

    can_use = function(self, card)
        local contains_suit = false
        for _, playing_card in ipairs(G.hand.cards) do
            if playing_card:is_suit(card.ability.extra.suit_conv, nil, true) then
                contains_suit = true
                break
            end
        end
        return #G.hand.cards > 0 and contains_suit
    end,

    use = function(self, card)
        local temp_hand = {}
        local destroyed_cards = {}
        for k, v in ipairs(G.hand.cards) do
            if v:is_suit(card.ability.extra.suit_conv) then
                temp_hand[#temp_hand+1] = v
            end
        end
        table.sort(temp_hand, function (a, b) return not a.playing_card or not b.playing_card or a.playing_card < b.playing_card end)
        pseudoshuffle(temp_hand, pseudoseed('world'))
        
        for i = 1, card.ability.extra.destroy do destroyed_cards[#destroyed_cards+1] = temp_hand[i] end
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('tarot1')
            card:juice_up(0.3, 0.5)
            return true end }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function() 
                for i=#destroyed_cards, 1, -1 do
                    local _card = destroyed_cards[i]
                    if _card.ability.name == 'Glass Card' then 
                        _card:shatter()
                    else
                        _card:start_dissolve(nil, i == #destroyed_cards)
                    end
                end
                return true end }))
        delay(0.6)
        for i = 1, #G.jokers.cards do
            G.jokers.cards[i]:calculate_joker({remove_playing_cards = true, removed = destroyed_cards})
        end
    end,
}

