SMODS.Joker{ --Hamburger
    name = "Hamburger",
    key = "hamburger",
    config = {
        extra = {
            hands = 4,
            discards_reduction = 1,
            discard_cards_required = 5,
            discard_cards_left = 5,
        }
    },
    pos = {
        x = 5,
        y = 3,
    },
    order = 13,
    attributes = { 'passive', 'food', 'hands', 'discard' },
    cost = 8,
    rarity = 3,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    pools = {
        Food = true,
    },
    

    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'amoryax, palestjade', 'brook03'}, key = 'artist_credits_cracker'} end
        return {vars = {card.ability.extra.hands, card.ability.extra.discards_reduction, (card.ability.extra.discards == 1 --[[and G.SETTINGS.language == "en-us"]]) and "" or "s", card.ability.extra.discard_cards_required, card.ability.extra.discard_cards_left}}
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hands
        ease_hands_played(card.ability.extra.hands)
    end,
    
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.hands
        ease_hands_played(-card.ability.extra.hands, true)
        if G.GAME.current_round.hands_left < 1 then
            G.GAME.current_round.hands_left = 1
        end
    end,
    
    calculate = function(self, card, context)
        if context.pre_discard and not context.blueprint then
            if Cracker.is_adjacent_to_freezer(card) then
                return {
                    message = localize('k_cracker_frozen_ex')
                }
            end
        end
        if context.discard and not context.blueprint and not Cracker.is_adjacent_to_freezer(card) then
            card.ability.extra.discard_cards_left = card.ability.extra.discard_cards_left - 1
            if card.ability.extra.discard_cards_left <= 0 then
                card.ability.extra.discard_cards_left = card.ability.extra.discard_cards_required
                card.ability.extra.hands = card.ability.extra.hands - card.ability.extra.discards_reduction
                G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.discards_reduction
                if G.GAME.current_round.hands_left < 1 then
                    G.GAME.current_round.hands_left = 1
                end
                if card.ability.extra.hands <= 0 then
                    SMODS.destroy_cards(card, { pinch_anim = true })
                    return {
                        message = localize('k_eaten_ex'),
                        colour = G.C.FILTER
                    }
                else
                    return {
                        message = localize{type='variable',key='a_cracker_hands_minus',vars={card.ability.extra.discards_reduction}},
                        colour = G.C.BLUE
                    }
                end
            end
        end
    end
}
