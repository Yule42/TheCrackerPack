SMODS.ConsumableType{
    key = 'reversetarot',
    primary_colour = HEX('424e54'),
    secondary_colour = HEX('7360bf'),
    loc_txt = {
        collection = "Reverse Arcana Cards",
        name = "Reverse Arcana",
        label = "Reverse Arcana",
    },
}

SMODS.Consumable{ -- Strength
    set = 'reversetarot',
    atlas = 'reversearcana',
    key = 'strength',
    config = {
        extra = {
            cards = 2,
        }
    },
    
    pos = {
        x = 1,
        y = 4
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
        y = 4
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
        y = 4
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
        y = 4
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
        y = 3
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