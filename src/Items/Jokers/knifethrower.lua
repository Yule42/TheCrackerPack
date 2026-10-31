SMODS.Joker{ --Knife Thrower
    key = "knifethrower",
    config = {
        extra = {
            hands = 1,
        }
    },
    pos = {
        x = 7,
        y = 1
    },
    order = 35,
    attributes = { 'hands', 'passive' },
    cost = 6,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'palestjade', 'sugariimarii'}, key = 'artist_credits_cracker'} end
        return {vars = {card.ability.extra.hands}}
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hands
        ease_hands_played(card.ability.extra.hands)
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.hands
        ease_hands_played(-card.ability.extra.hands)
    end
}
